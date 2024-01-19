import 'dart:convert';

import 'package:kambas/models/request/database/DbTransactions.dart';
import 'package:kambas/models/responses/ResponseUserDetails.dart';
import 'package:kambas/repository/DatabaseRepository.dart';

import '../constants/app_strings.dart';
import '../models/request/RequestOAuth.dart';
import '../models/responses/base/ResponseBundle.dart';
import '../models/responses/errors/ResponseErrorMessage.dart';
import '../models/responses/errors/ResponseGeneric.dart';
import '../repository/PreferenceRepository.dart';
import '../repository/RemoteRepository.dart';
import '../utils/HttpErrorHandler.dart';
import 'BaseProvider.dart';

class ProviderAccount extends BaseProvider {
  final PreferenceRepository preferenceRepository;
  final RemoteRepository remoteRepository;
  final DatabaseRepository databaseRepository;

  ProviderAccount({
    required this.remoteRepository,
    required this.preferenceRepository,
    required this.databaseRepository,
  });

  // Future<ResponseBundle<ResponseOAuth, ResponseErrorMessage>> postLogin(RequestOAuth request, [bool fromRegister = false]) async {
  //   try {
  //     final response = await remoteRepository.getOauthToken(request);
  //     ResponseOAuth data = ResponseOAuth.fromJson(response.data);
  //     if (response.statusCode == 200) {
  //       await preferenceRepository.saveUserEmail(request.email ?? ""); //todo: move saving of user data in get user
  //       await preferenceRepository.persistToken(data.accessToken, data.refreshToken ?? data.accessToken, fromRegister);
  //       remoteRepository.setToken(data.accessToken);
  //       return ResponseBundle.success(response: ResponseOAuth.fromJson(response.data));
  //     } else {
  //       return ResponseBundle.failed(error: ResponseErrorMessage(errorMsg: AppStrings.error_general_throwable_msg));
  //     }
  //   } catch (e) {
  //     return ResponseBundle.failed(
  //       error: ResponseErrorMessage(
  //         errorMsg: getErrorMessage(
  //           e,
  //           httpErrorHandlers: <HttpErrorHandler>[
  //             HttpErrorHandler.message(
  //                 400, AppStrings.error_login_invalidfields_msg),
  //             HttpErrorHandler.message(
  //                 401, AppStrings.error_login_incorrectfields_msg),
  //             HttpErrorHandler.message(
  //                 404, AppStrings.error_login_usernotfound_msg),
  //             HttpErrorHandler.message(
  //                 422, AppStrings.error_login_incorrectfields_msg),
  //             HttpErrorHandler.message(
  //                 500, AppStrings.error_general_throwable_msg),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<bool> initDatabase() async {
    return await databaseRepository.initDatabase();
  }

  Future<bool> storeDBTransaction(DBTransactions data) async {
    return await databaseRepository.storeTransactionData(data);
  }

  Future<List<DBTransactions>> getStoredDBTransactions() async {
    return await databaseRepository.getStoredTransactions();
  }

  Future<List<DBTransactions>> getFilteredDBTransactions(DateTime selectedDatetime) async {
    return await databaseRepository.getFilteredTransactions(selectedDatetime);
  }

  Future<ResponseUserDetails?> getLocalUserData() async {
    // await preferenceRepository.saveUserdetails(response.data);
    try {
      String userDataString = await preferenceRepository.getUserdetails();
      Map<String, dynamic> data = jsonDecode(userDataString);
      return ResponseUserDetails.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> getLocalOnboardingStatus() async {
    try {
      return await preferenceRepository.getUserOnboardStatus();
    } catch (e) {
      return false;
    }
  }

  Future<bool> getLocalNewLaunchStatus() async {
    try {
      return await preferenceRepository.getNewLaunchStatus();
      // await preferenceRepository.saveNewLaunch(false);
    } catch (e) {
      return true;
    }
  }

  Future<void> setNewLaunchStatus() async {
    await preferenceRepository.saveNewLaunch(false);
  }

  Future<bool> hasLogoutToken() async {
    return await preferenceRepository.hasLogoutToken();
  }

  Future<bool> hasToken() async {
    return await preferenceRepository.hasToken();
  }

  Future<String?> getToken() async {
    return await preferenceRepository.getToken();
  }

  Future<void> initTokenHeader() async {
    String? token = await preferenceRepository.getToken();
    remoteRepository.setToken(token);
  }

  void setLogoutTag() async {
    preferenceRepository.saveLogout();
  }

  void clearToken() async {
    preferenceRepository.saveLogout();
  }

  void logout() async {
    databaseRepository.clearDatabase();
    remoteRepository.clearDioCache();
    preferenceRepository.deleteToken();

    remoteRepository.setToken(null);
  }

  Future<void> saveBetNumbers(List<String> numbers) async {
    await preferenceRepository.saveBetNumbers(numbers);
  }

  Future<List<String>?> getBetNumbers() async {
    return await preferenceRepository.getBetNumbers();
  }

  Future<void> saveBetAmount(String amount) async {
    await preferenceRepository.saveBetAmount(amount);
  }

  Future<String?> getBetAmount() async {
    return await preferenceRepository.getBetAmount();
  }

  Future<void> deleteUserBetInput() async {
    await preferenceRepository.deleteUserInputData();
  }
}
