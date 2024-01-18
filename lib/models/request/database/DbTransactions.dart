

import 'dart:convert';

DBTransactions responseDBTransactionsContentFromJson(String str) =>
    DBTransactions.fromJson(json.decode(str));

String responseDBTransactionsContentToJson(DBTransactions data) =>
    json.encode(data.toJson());

class DBTransactions {
  static const DB_CREATED_DATETIME = 'created_datetime';
  static const DB_STALL_NAME = 'stall_name';
  static const DB_LOCATION = 'location';
  static const DB_TICKET_NO = 'ticket_number';
  static const DB_BET_NO_1 = 'bet_number1';
  static const DB_BET_NO_2 = 'bet_number2';
  static const DB_BET_AMOUNT = 'bet_amount';
  static const DB_BET_PRIZE = 'bet_prize';
  static const DB_USERNAME = 'encoded_by_username';

  final String createdDate;
  final String stallName;
  final String location;
  final String ticketNo;
  final String betNumber1;
  final String betNumber2;
  final String betAmount;
  final String betPrize;
  final String userName;

  const DBTransactions({
    required this.createdDate,
    required this.stallName,
    required this.location,
    required this.ticketNo,
    required this.betNumber1,
    required this.betNumber2,
    required this.betAmount,
    required this.betPrize,
    required this.userName,
  });

  Map<String, String> getData() => {
        DB_CREATED_DATETIME: createdDate,
        DB_STALL_NAME: stallName,
        DB_LOCATION: location,
        DB_TICKET_NO: ticketNo,
        DB_BET_NO_1: betNumber1,
        DB_BET_NO_2: betNumber2,
        DB_BET_AMOUNT: betAmount,
        DB_BET_PRIZE: betPrize,
        DB_USERNAME: userName,
      };

  factory DBTransactions.fromJson(Map<String, dynamic> json) => DBTransactions(
    createdDate: json[DB_CREATED_DATETIME] ?? DateTime.now().toString(),
    stallName: json[DB_STALL_NAME] ?? "n/a",
    location: json[DB_LOCATION] ?? "n/a",
    ticketNo: json[DB_TICKET_NO] ?? "n/a",
    betNumber1: json[DB_BET_NO_1] ?? "n/a",
    betNumber2: json[DB_BET_NO_2] ?? "n/a",
    betAmount: json[DB_BET_AMOUNT] ?? "n/a",
    betPrize: json[DB_BET_PRIZE] ?? "n/a",
    userName: json[DB_USERNAME] ?? "n/a",
  );

  Map<String, dynamic> toJson() => {
    DB_CREATED_DATETIME: createdDate,
    DB_STALL_NAME: stallName,
    DB_LOCATION: location,
    DB_TICKET_NO: ticketNo,
    DB_BET_NO_1: betNumber1,
    DB_BET_NO_2: betNumber2,
    DB_BET_AMOUNT: betAmount,
    DB_BET_PRIZE: betPrize,
    DB_USERNAME: userName,
  };

}
