import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';

import '../models/database/dbmodel.dart';

class DatabaseRepository {
  var isDbInitialized = false;

  Future<bool> initDatabase() async {
    return isDbInitialized = await KambasDB().initializeDB();
  }

  Future<bool> clearDatabase() async {
    if (!isDbInitialized) return false;

    await UserAccount().select().id.greaterThan(0).delete();
    await KambasTransaction().select().id.greaterThan(0).delete();
    return true;
  }

  Future<bool> storeUserData(UserItemData data) async {
    if (!isDbInitialized) return false;

    await UserAccount.withFields(data.userId, data.userName, data.fullName, data.email, data.contactNo, data.password, DateTime.parse(data.createdAt), DateTime.parse(data.updatedAt), false).save();

    ///(print results)
    var dataStored = await UserAccount().select().toList();
    dataStored.forEach((element) async {
      if (kDebugMode) {
        print("DATABASE ID : ${element.id!}\nresponse : \n${element.userId ?? ""}\n${element.userName ?? ""}\n${element.password ?? ""}\n--------------\n");
      }
    });

    return true;
  }

  Future<List<UserItemData>> getDBUsers() async {
    if (!isDbInitialized) return [];

    List<UserItemData> list = [];

    var storedList = await UserAccount()
        .select()
        .and
        .orderBy("id")
        .toList();

    for (var e in storedList) {
      list.add(UserItemData(e.userId!, userName: e.userName!, fullName: e.fullName!,  email: e.email!, contactNo: e.contactNo!, password: e.password ?? "", createdAt: e.createdAt!.toString(), updatedAt: e.updatedAt!.toString()));
    }

    return list.reversed.toList();
  }

  Future<bool> storeTransactionData(DBTransactions data) async {
    if (!isDbInitialized) return false;

    await KambasTransaction.withFields(DateTime.parse(data.createdDate), data.userName, true, jsonEncode(data), false).save();

    ///(print results)
    var dataStored = await KambasTransaction().select().toList();
    dataStored.forEach((element) async {
      if (kDebugMode) {
        print("DATABASE ID : ${element.id!}\nresponse : \n${element.jsonResponse ?? ""}\n--------------\n");
      }
    });

    return true;
  }

  Future<List<DBTransactions>> getStoredTransactions() async {
    if (!isDbInitialized) return [];

    List<DBTransactions> readContents = [];

    var storedModule = await KambasTransaction()
        .select()
        .and
        .orderBy("id")
        .toList();

    for (var e in storedModule) {
      var rawData = json.decode(e.jsonResponse!);
      readContents.add(DBTransactions.fromJson(rawData));
    }

    return readContents;
  }

  Future<List<DBTransactions>> getFilteredTransactions(DateTime selectedDatetime) async {
    if (!isDbInitialized) return [];

    List<DBTransactions> readContents = [];

    var storedModule = await KambasTransaction()
        .select()
        .createdAt
        .equals(selectedDatetime)
        .and
        .orderBy("id")
        .toList();

    for (var e in storedModule) {
      var rawData = json.decode(e.jsonResponse!);
      readContents.add(DBTransactions.fromJson(rawData));
    }

    return readContents;
  }

}