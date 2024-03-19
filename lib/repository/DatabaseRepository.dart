import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:kambas/models/object/TerminalData.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';
import 'package:uuid/uuid.dart';

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

    await UserAccount.withFields(
            data.userId,
            data.userName,
            data.fullName,
            data.email,
            data.contactNo,
            data.password,
            DateTime.parse(data.createdAt),
            DateTime.parse(data.updatedAt),
            false)
        .save();

    var storedData = await UserAccount().select().userId.equals(data.userId).toSingle();

    return (storedData != null);
  }

  Future<bool> updateUserData(UserItemData data) async {
    if (!isDbInitialized) return false;

    var storedData =
        await UserAccount().select().userId.equals(data.userId).update({
      'userName': data.userName,
      'fullName': data.fullName,
      'email': data.email,
      'contactNo': data.contactNo,
    });

    return storedData.success;
  }

  Future<UserItemData?> getUserDetails(int user_id) async {
    if (!isDbInitialized) return null;

    var storedData =
        await UserAccount().select().userId.equals(user_id).toSingle();

    final userData = UserItemData(
      storedData?.userId ?? user_id,
      userName: storedData?.userName ?? "",
      fullName: storedData?.fullName ?? "",
      email: storedData?.email ?? "",
      contactNo: storedData?.contactNo ?? "",
      password: storedData?.password ?? "",
      createdAt: storedData?.createdAt.toString() ?? "",
      updatedAt: storedData?.updatedAt.toString() ?? "",
    );

    return userData;
  }

  Future<bool> deleteDBUser(int user_id) async {
    final isDeleted =
        await UserAccount().select().userId.equals(user_id).delete();

    return isDeleted.success;
  }

  Future<List<UserItemData>> getDBUsers() async {
    if (!isDbInitialized) return [];

    List<UserItemData> list = [];

    var storedList = await UserAccount().select().and.orderBy("id").toList();

    for (var e in storedList) {
      list.add(UserItemData(e.userId!,
          userName: e.userName!,
          fullName: e.fullName!,
          email: e.email!,
          contactNo: e.contactNo!,
          password: e.password ?? "",
          createdAt: e.createdAt!.toString(),
          updatedAt: e.updatedAt!.toString()));
    }

    return list.reversed.toList();
  }

  Future<TerminalData?> getDBTerminalData() async {
    if (!isDbInitialized) return null;

    var initialTable = await KambasTerminal().select().toSingle();
    if (initialTable == null) {
      await KambasTerminal.withFields(
              "",
              "",
              "",
              "T${Random().nextInt(5000)}${const Uuid().v4().substring(0, 4)}",
              false)
          .save();
    }

    var storedData = await KambasTerminal().select().toSingle();

    final data = TerminalData(
        stallName: storedData?.stallName ?? "",
        location: storedData?.location ?? "",
        agent: storedData?.agent ?? "",
        ticketNumber: storedData?.ticketNumber ?? "");

    return data;
  }

  Future<bool> storeDBTerminalData(TerminalData data) async {
    if (!isDbInitialized) return false;

    var storedData = await KambasTerminal().select().update({
      'stallName': data.stallName,
      'location': data.location,
      'agent': data.agent,
    });

    return storedData.success;
  }

  Future<bool> storeDBTicketSeriesNo(String ticketNumber) async {
    if (!isDbInitialized) return false;

    var storedData = await KambasTerminal().select().update({
      'ticketNumber': ticketNumber,
    });

    return storedData.success;
  }

  Future<bool> storeTransactionData(
      {required DateTime dbCreatedDate, required DBTransactions data,}) async {
    if (!isDbInitialized) return false;

    await KambasTransaction.withFields(dbCreatedDate, data.userName,
            data.ticketNo, false, jsonEncode(data), false)
        .save();

    ///(print results)
    var dataStored = await KambasTransaction().select().toList();
    dataStored.forEach((element) async {
      if (kDebugMode) {
        print(
            "DATABASE ID : ${element.id!}\nresponse : \n${element.jsonResponse ?? ""}\n--------------\n");
      }
    });

    return true;
  }

  Future<List<DBTransactions>> getStoredTransactions() async {
    if (!isDbInitialized) return [];

    List<DBTransactions> readContents = [];

    var storedModule =
        await KambasTransaction().select().and.orderBy("id").toList();

    for (var e in storedModule) {
      var rawData = json.decode(e.jsonResponse!);
      readContents.add(DBTransactions.fromJson(rawData));
      if (kDebugMode) {
        print(
            "DATABASE Stored ID : ${e.id!}\nresponse : \n${e.jsonResponse ?? ""}\n--------------\n");
      }
    }

    return readContents;
  }

  Future<bool> syncStoredTransaction(String ticketSeries,) async {
    if (!isDbInitialized) return false;

    var storedContents = await KambasTransaction()
        .select()
        .ticketSeries
        .equals(ticketSeries)
        .and
        .hasRead
        .equals(0) // only update if hasRead is false
        .toList();

    if (storedContents.isNotEmpty) {
      storedContents.first.hasRead = true;
      storedContents.first.upsert();
    } else {
      print("----- orm db NO UPDATES in storedTransaction -----");
    }

    return true;
  }

  Future<List<DBTransactions>> getFilteredTransactions(
      DateTime selectedDatetime) async {
    if (!isDbInitialized) return [];

    List<DBTransactions> readContents = [];

    var storedModule = await KambasTransaction()
        .select()
        .createdAt
        .between(selectedDatetime.copyWith(hour: selectedDatetime.hour - 7, minute: 0), selectedDatetime.copyWith(minute: 0))
        .and
        .orderBy("id")
        .toList();

    // var storedModule = await KambasTransaction()
    //     .select()
    //     .createdAt
    //     .equals(selectedDatetime)
    //     .and
    //     .orderBy("id")
    //     .toList();

    for (var e in storedModule) {
      var rawData = json.decode(e.jsonResponse!);
      readContents.add(DBTransactions.fromJson(rawData));
    }

    return readContents;
  }

  Future<List<DBTransactions>> getUnsyncDBTransactions() async {
    if (!isDbInitialized) return [];
    List<DBTransactions> unreadContents = [];

    var storedTransactions = await KambasTransaction()
        .select()
        .hasRead
        .equals(0)
        .and
        .orderBy("id")
        .toList();

    for (var e in storedTransactions) {
      var rawData = json.decode(e.jsonResponse!);
      unreadContents.add(DBTransactions.fromJson(rawData));
      if (kDebugMode) {
        print(
            "DATABASE Unsync : ${e.id!}\nresponse : \n${e.jsonResponse ?? ""}\n--------------\n");
      }
    }

    return unreadContents;
  }

  Future<DBTransactions?> getTransactionDetails(String ticketNumber) async {
    if (!isDbInitialized) return null;

    var data = await KambasTransaction()
        .select()
        .ticketSeries
        .equals(ticketNumber)
        .toSingle();

    if (data != null) {
      var rawData = json.decode(data.jsonResponse!);
      return DBTransactions.fromJson(rawData);
    }

    return null;
  }
}
