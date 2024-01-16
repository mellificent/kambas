import 'dart:ui';

class TransactionRowItemData {
  final int transactionId;
  final String date;
  final String trackingNo;
  final String customerName;
  final String total;
  final String paymentMethod;
  final String merchantName;
  final String marketplace;
  final String orderStatus;
  final Color? orderStatusColor;

  TransactionRowItemData(this.transactionId, {
    required this.date,
    required this.trackingNo,
    required this.customerName,
    required this.total,
    required this.paymentMethod,
    required this.merchantName,
    required this.marketplace,
    required this.orderStatus,
    this.orderStatusColor,
  });
}
