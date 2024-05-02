import 'dart:convert';

ResponseOAuth responseOAuthFromJson(String str) =>
    ResponseOAuth.fromJson(json.decode(str));

String responseOAuthToJson(ResponseOAuth data) => json.encode(data.toJson());

class ResponseOAuth {
  ResponseOAuth({
    this.message,
    required this.status,
    required this.accessToken,
    this.token,
  });

  String? message;
  String? status;
  String accessToken;
  String? token;

  factory ResponseOAuth.fromJson(Map<String, dynamic> json) => ResponseOAuth(
    message: json["message"] ?? "",
    status: json["Status"] ?? "",
    accessToken: json["accessToken"],
    token: json["token"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "accessToken": accessToken,
    "token": token,
  };
}
