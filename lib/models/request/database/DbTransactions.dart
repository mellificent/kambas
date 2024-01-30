import 'dart:convert';

DBTransactions responseDBTransactionsContentFromJson(String str) =>
    DBTransactions.fromJson(json.decode(str));

String responseDBTransactionsContentToJson(DBTransactions data) =>
    json.encode(data.toJson());

class DBTransactions {
  static const DB_CREATED_DATE = 'created_datetime';
  static const DB_DRAW_TIME = 'cut_off';
  static const DB_STALL_NAME = 'stall_name';
  static const DB_AGENT_NAME = 'agent_name';
  static const DB_LOCATION = 'location';
  static const DB_TICKET_NO = 'ticket_number';
  static const DB_BET_NO_1 = 'bet_number1';
  static const DB_BET_NO_2 = 'bet_number2';
  static const DB_BET_AMOUNT = 'bet_amount';
  static const DB_BET_PRIZE = 'bet_prize';
  static const DB_USERNAME = 'encoded_by_username';

  final String datePlaced;
  final String drawTime;
  final String stallName;
  final String agentName;
  final String location;
  final String ticketNo;
  final String betNumber1;
  final String betNumber2;
  final String betAmount;
  final String betPrize;
  final String userName;

  const DBTransactions({
    required this.datePlaced,
    required this.drawTime,
    required this.stallName,
    required this.agentName,
    required this.location,
    required this.ticketNo,
    required this.betNumber1,
    required this.betNumber2,
    required this.betAmount,
    required this.betPrize,
    required this.userName,
  });

  Map<String, String> getData() => {
        DB_CREATED_DATE: datePlaced,
        DB_DRAW_TIME: drawTime,
        DB_STALL_NAME: stallName,
        DB_AGENT_NAME: agentName,
        DB_LOCATION: location,
        DB_TICKET_NO: ticketNo,
        DB_BET_NO_1: betNumber1,
        DB_BET_NO_2: betNumber2,
        DB_BET_AMOUNT: betAmount,
        DB_BET_PRIZE: betPrize,
        DB_USERNAME: userName,
      };

  factory DBTransactions.fromJson(Map<String, dynamic> json) => DBTransactions(
        datePlaced: json[DB_CREATED_DATE] ?? DateTime.now().toString(),
        drawTime: json[DB_DRAW_TIME] ?? "n/a",
        stallName: json[DB_STALL_NAME] ?? "n/a",
        agentName: json[DB_AGENT_NAME] ?? "n/a",
        location: json[DB_LOCATION] ?? "n/a",
        ticketNo: json[DB_TICKET_NO] ?? "n/a",
        betNumber1: json[DB_BET_NO_1] ?? "n/a",
        betNumber2: json[DB_BET_NO_2] ?? "n/a",
        betAmount: json[DB_BET_AMOUNT] ?? "n/a",
        betPrize: json[DB_BET_PRIZE] ?? "n/a",
        userName: json[DB_USERNAME] ?? "n/a",
      );

  Map<String, dynamic> toJson() => {
        DB_CREATED_DATE: datePlaced,
        DB_DRAW_TIME: drawTime,
        DB_STALL_NAME: stallName,
        DB_AGENT_NAME: agentName,
        DB_LOCATION: location,
        DB_TICKET_NO: ticketNo,
        DB_BET_NO_1: betNumber1,
        DB_BET_NO_2: betNumber2,
        DB_BET_AMOUNT: betAmount,
        DB_BET_PRIZE: betPrize,
        DB_USERNAME: userName,
      };
}
