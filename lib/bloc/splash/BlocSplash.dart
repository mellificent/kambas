
import 'package:app_links/app_links.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../providers/ProviderAccount.dart';
import 'EventSplash.dart';
import 'StateSplash.dart';

class BlocSplash extends Bloc<EventSplash, StateSplash> {
  final ProviderAccount providerAccount;

  bool isLatestAppVersion = true;

  BlocSplash({
    required this.providerAccount,
  }) : super(InitState()) {
    on<AppStarted>(_mapAppStarted);
  }

  Future<void> _mapAppStarted(AppStarted event, Emitter<StateSplash> emit) async {
    final bool hasToken = await providerAccount.hasToken();
    final bool hasLogoutToken = await providerAccount.hasLogoutToken();
    await _mapGetAppVersion();

    if(UniversalPlatform.isAndroid){
      final bool isDbReady = await providerAccount.initDatabase();
      if (hasToken && isDbReady) {
        await providerAccount.initTokenHeader();
        if (hasLogoutToken) {
          providerAccount.logout();
          emit(AuthenticationUnauthenticated());
        } else {
          emit(AuthenticationAuthenticated());
        }
      }else {
        emit(AuthenticationUnauthenticated());
      }
    } else {
      emit(AuthenticationUnauthenticated());
    }

  }

  Future<void> _mapGetAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      //todo: display app version in splashscreen
    } catch (e) {
      Fimber.e("_mapGetAppVersion :: $e");
    }
  }

}
