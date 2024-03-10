import 'dart:convert';

ResponseOAuth responseOAuthFromJson(String str) =>
    ResponseOAuth.fromJson(json.decode(str));

String responseOAuthToJson(ResponseOAuth data) => json.encode(data.toJson());


class ResponseOAuth {
  ResponseOAuth({
    this.message,
    required this.status,
    required this.accessToken,
    this.refreshToken,
  });

  String? message;
  String status;
  String accessToken;
  String? refreshToken;

  factory ResponseOAuth.fromJson(Map<String, dynamic> json) => ResponseOAuth(
    message: json["message"],
    status: json["Status"],
    accessToken: json["Token"],
    refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": accessToken,
    "refresh_token": refreshToken,
  };
}
