import 'dart:ui';

class UserItemData {
  final int userId;
  final String userName;
  final String fullName;
  final String email;
  final String contactNo;
  final String? password;
  final String createdAt;
  final String updatedAt;

  UserItemData(this.userId,{
    required this.userName,
    required this.fullName,
    required this.email,
    required this.contactNo,
    this.password,
    required this.createdAt,
    required this.updatedAt,
  });
}
