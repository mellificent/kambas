import 'dart:convert';

ResponseUserDetails responseUserDetailsFromJson(String str) =>
    ResponseUserDetails.fromJson(json.decode(str));

String responseUserDetailsToJson(ResponseUserDetails data) => json.encode(data.toJson());

class ResponseUserDetails {
  ResponseUserDetails({
    this.data,
  });

  UserData? data;

  factory ResponseUserDetails.fromJson(Map<String, dynamic> json) =>
      ResponseUserDetails(
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}

class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.accounts,
  });

  int id;
  String name;
  String email;
  String contactNumber;
  List<UserAccounts>? accounts;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["sf_phone"] ?? "n/a",
    accounts: json["accounts"] == null ? null
        : List<UserAccounts>.from(json["accounts"].map((x) => UserAccounts.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };
}

class UserAccounts {
  UserAccounts({
    required this.name,
    required this.contactNumber,
    required this.userMerchant,
  });

  String? name;
  String? contactNumber;
  UserMerchant? userMerchant;

  factory UserAccounts.fromJson(Map<String, dynamic> json) => UserAccounts(
    name: json["sf_name"] ?? "n/a",
    contactNumber: json["sf_phone"] ?? "n/a",
    userMerchant: UserMerchant.fromJson(json["user_merchants"]),
  );

  Map<String, dynamic> toJson() => {
    "sf_name": name,
    "sf_phone": contactNumber,
    "user_merchants": userMerchant,
  };
}

class UserMerchant {
  UserMerchant({
    required this.id,
    required this.userId,
    required this.merchantId,
    required this.createdDate,
    required this.updatedDate,
  });

  int id;
  String? userId;
  String? merchantId;
  String? createdDate;
  String? updatedDate;

  factory UserMerchant.fromJson(Map<String, dynamic> json) => UserMerchant(
    id: json["id"],
    userId: json["user_id"] ?? "n/a",
    merchantId: json["merchant_id"] ?? "n/a",
    createdDate: json["created_at"] ?? "n/a",
    updatedDate: json["updated_at"] ?? "n/a",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "merchant_id": merchantId,
    "created_at": createdDate,
    "updated_at": updatedDate
  };
}