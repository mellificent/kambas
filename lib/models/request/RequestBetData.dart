import 'dart:ffi';

import 'BaseRequest.dart';

class RequestBetData extends BaseRequest {
  static const KEY_NAME_BET_ID = 'betId';
  static const KEY_NAME_TICKET_NO = 'ticketNumber';
  static const KEY_NAME_CUT_OFF = 'cutOff';
  static const KEY_NAME_STALLNAME = 'stallName';
  static const KEY_NAME_LOCATION = 'location';
  static const KEY_NAME_BET_1 = 'betNumber1';
  static const KEY_NAME_BET_2 = 'betNumber2';
  static const KEY_NAME_DATETIME_CREATED = 'dateTimePlaced';
  static const KEY_NAME_AMOUNT = 'betAmount';
  static const KEY_NAME_PRIZE = 'betPrize';
  static const KEY_NAME_USERNAME = 'encodedByUserName';

  final int betID;
  final String ticketNumber;
  final String cutOff;
  final String stallName;
  final String location;
  final int betNumber1;
  final int betNumber2;
  final String dateTimePlaced;
  final double betAmount;
  final double betPrize;
  final String encodedByUserName;

  const RequestBetData({
    required this.betID,
    required this.ticketNumber,
    required this.cutOff,
    required this.stallName,
    required this.location,
    required this.betNumber1,
    required this.betNumber2,
    required this.dateTimePlaced,
    required this.betAmount,
    required this.betPrize,
    required this.encodedByUserName,
  });

  @override
  Map<String, String> getData() => {
        KEY_NAME_BET_ID: betID.toString(),
        KEY_NAME_TICKET_NO: ticketNumber,
        KEY_NAME_CUT_OFF: cutOff,
        KEY_NAME_STALLNAME: stallName,
        KEY_NAME_LOCATION: location,
        KEY_NAME_BET_1: betNumber1.toString(),
        KEY_NAME_BET_2: betNumber2.toString(),
        KEY_NAME_DATETIME_CREATED: dateTimePlaced,
        KEY_NAME_AMOUNT: betAmount.toString(),
        KEY_NAME_PRIZE: betPrize.toString(),
        KEY_NAME_USERNAME: encodedByUserName,
      };
}
