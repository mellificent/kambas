import 'dart:ui';

class TransactionRowItemData {
  final int betId;
  final String ticketNumber;
  final String cutOff;
  final String stallName;
  final String location;
  final String betNumber1;
  final String betNumber2;
  final String dateTimePlaced;
  final String betAmount;
  final String betPrize;
  final String encodedByUserName;

  TransactionRowItemData(
    this.betId, {
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
}
