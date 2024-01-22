import 'dart:convert';

import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';
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

  Future<bool> storeNewUser(UserItemData data) async {
    return await databaseRepository.storeUserData(data);
  }

  Future<List<UserItemData>> getStoredDBUsers() async {
    return await databaseRepository.getDBUsers();
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
