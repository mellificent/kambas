import 'dart:ui';


// todo: update to response
class TransactionFilter {
  String name;
  List<TransactionTypeSelected> data;

  TransactionFilter({
    required this.name,
    required this.data,
  });
}

class TransactionTypeSelected {
  int id;
  String content;
  bool isSelected;

  TransactionTypeSelected({
    required this.id,
    required this.content,
    required this.isSelected,
  });
}
