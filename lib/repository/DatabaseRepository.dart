import 'dart:convert';

import 'package:flutter/foundation.dart';
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

}