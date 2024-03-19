import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache_fix/dio_http_cache.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:kambas/models/request/RequestBets.dart';
import 'package:kambas/models/responses/ResponseOAuth.dart';
import 'package:universal_platform/universal_platform.dart';
import '../constants/api_settings.dart';
import '../models/request/RequestOAuth.dart';
import 'PreferenceRepository.dart';

class RemoteRepository {
  late Dio client;
  String? userAgent;

  late DioCacheManager dioCacheManager;
  Options cacheOptions = buildCacheOptions(
    const Duration(days: 30),
    maxStale: const Duration(days: 60),
    forceRefresh: true,
  );

  PreferenceRepository preferenceRepository;
  final GlobalKey<NavigatorState> navigator;//Create a key for navigator


  RemoteRepository({required this.preferenceRepository, required this.navigator,}) {
    BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30));

    client = Dio(options);
    setDioInterceptor(null);

    dioCacheManager = DioCacheManager(CacheConfig(baseUrl: ApiSettings.HOST_LIVE));
    setDioCacheInterceptor();
  }

  void setDioInterceptor(String? token) async {
    if (userAgent == null) {
      await _initUserAgent();
    }

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Map<String, String?> customHeaders;
          if (token != null) {
            customHeaders = {
              'accept': 'application/json',
              'authorization': 'Bearer $token',
              'User-Agent': userAgent,
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE',
              'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept, Cookie, X-CSRF-TOKEN, Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin',
              'Access-Control-Expose-Headers': 'Authorization, authenticated',
              'Access-Control-Allow-Credentials': 'true'
            };
          } else {
            customHeaders = {
              'accept': 'application/json',
              'User-Agent': userAgent,
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE',
              'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept, Cookie, X-CSRF-TOKEN, Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin',
              'Access-Control-Expose-Headers': 'Authorization, authenticated',
              'Access-Control-Allow-Credentials': 'true'
            };
          }

          options.headers.addAll(customHeaders);
          options.contentType = "application/x-www-form-urlencoded";

          Fimber.d('path: ${options.path}');
          Fimber.d('data: ${options.headers}');
          if (options.data != null) {
            Fimber.d('data: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            Fimber.d('query: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Fimber.d('response: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          Fimber.d("DioException occured: ------- "
              "\nresponse: ${e.response}"
              "\ntype: ${e.type}"
              "\nmessage: ${e.message}"
              "\nerror: ${e.error}"
              "\nstackTrace: ${e.stackTrace}");

          if (e.response?.statusCode == 401 &&
              !(e.requestOptions.path.contains(ApiSettings.ENDPOINT_LOGIN))) {

            String userEmail = await preferenceRepository.getUserEmail();
            String refreshToken = await preferenceRepository.getRefreshToken();

            // Request OAuth via Refresh Token
            try {
              var refreshTokenRequest = RequestOAuth.refresh(refresh: refreshToken, email: userEmail);
              var response = await getOauthToken(refreshTokenRequest);

              if (response.statusCode == 200) {
                ResponseOAuth data = ResponseOAuth.fromJson(response.data);
                await preferenceRepository.persistToken(data.accessToken, data.refreshToken ?? data.accessToken);
                setToken(data.accessToken);

                // Replicate last request
                final opts = Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers);
                final cloneReq = await client.request(e.requestOptions.path,
                    options: opts,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters);
                return handler.resolve(cloneReq);
              } else {
                // forceLogout();
                return handler.next(e);
              }
            } catch (error) {
              // forceLogout();
              return handler.next(e);
            }

          }
          return handler.next(e);
        },
      ),
    );
  }

  //todo: dont force user. change jwt express backend flow to oauth2
  void forceLogout() {
    clearDioCache();
    preferenceRepository.deleteToken();
    setToken(null);
    // navigator.currentState?.pushNamedAndRemoveUntil('/loginScreen', (Route route) => false);
  }

  Future<void> _initUserAgent() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (UniversalPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var release = androidInfo.version.release;
      // var sdkInt = androidInfo.version.sdkInt;
      // var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      userAgent = 'Mobile(Android;Android $release; $model Build)';
    } else if (UniversalPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var machine = iosInfo.utsname.machine;
      userAgent = 'Mobile($systemName;iOS $version;$machine)';
    } else if (UniversalPlatform.isMacOS){
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      var machine = macOsInfo.computerName;
      var model = macOsInfo.model;
      var version = macOsInfo.kernelVersion;
      userAgent = 'Web($model;macOS $version;$machine)';
    } else {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      userAgent = webInfo.userAgent;
    }
  }

  void setDioCacheInterceptor() {
    client.interceptors.add(dioCacheManager.interceptor);
  }

  void setToken(String? token) {
    clearToken();
    setDioInterceptor(token);
    setDioCacheInterceptor();
  }

  void clearToken() {
    client.interceptors.clear();
  }

  void clearDioCache() {
    dioCacheManager.clearAll();
  }

  dynamic getOauthToken(RequestOAuth request) => client.post(ApiSettings.API_LOGIN, data: request.getData(),);

  dynamic postBets(RequestBets request) => client.post(ApiSettings.API_BETS, data: request.getData(),);

  dynamic getUserDetails() => client.get(ApiSettings.API_GET_USER_DETAILS,); //options: cacheOptions,

}
