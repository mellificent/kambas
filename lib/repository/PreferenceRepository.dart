import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  PreferenceRepository() {
    // Create storage
    // migrateStorage();
  }

  // void migrateStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys = prefs.getKeys();
  //
  //   final prefsMap = <String, dynamic>{};
  //   for (String key in keys) {
  //     prefsMap[key] = prefs.get(key);
  //   }
  //
  //   prefs.clear();
  // }

  // ACCOUNT
  Future<void> saveUsername(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user);
    return;
  }
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> persistToken(String token, String rtoken,
      [bool fromRegister = false]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('rtoken', rtoken);
    await prefs.setBool('register', fromRegister);
    return;
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    return;
  }
  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  Future<void> saveUserOnboardStatus(bool isOnboarded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserOnboarded', isOnboarded);
    return;
  }
  Future<bool> getUserOnboardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUserOnboarded') ?? false;
  }

  Future<void> saveNewLaunch(bool isNewLaunch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNewLaunch', isNewLaunch);
    return;
  }
  Future<bool> getNewLaunchStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isNewLaunch') ?? true;
  }

  Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rtoken') ?? '';
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return (((prefs.getString('token') ?? '').isNotEmpty));
  }

  Future<bool> hasLogoutToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logout') ?? false;
  }

  Future<void> saveLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logout', true);
    return;
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    await prefs.setString('rtoken', '');
    await prefs.setBool('logout', false);
    await prefs.setString('username', '');
    return;
  }

  // main
  Future<void> saveBetNumbers(List<String> numbers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('betNumbers', numbers);
    return;
  }

  Future<List<String>> getBetNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('betNumbers') ?? [];
  }

  Future<void> saveBetAmount(String amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('betAmount', amount);
    return;
  }

  Future<String> getBetAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('betAmount') ?? '';
  }

  Future<void> deleteUserInputData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('betNumbers', []);
    await prefs.setString('betAmount', '');
    return;
  }

}