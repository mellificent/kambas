import 'dart:ui';

class UserItemData {
  final int userId;
  final String name;
  final String? password;
  final String createdAt;
  final String updatedAt;

  UserItemData(this.userId,{
    required this.name,
    this.password,
    required this.createdAt,
    required this.updatedAt,
  });
}
