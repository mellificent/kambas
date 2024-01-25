import 'dart:ui';

class TransactionDetails {
  final String selectedBetNumber;
  final String placedDate;
  final String stallName;
  final String drawTime;
  final String betAmount;
  final String betPrize;

  TransactionDetails({
    required this.selectedBetNumber,
    required this.placedDate,
    required this.stallName,
    required this.drawTime,
    required this.betAmount,
    required this.betPrize,
  });
}
