import 'dart:convert';

ResponseOAuth responseOAuthFromJson(String str) =>
    ResponseOAuth.fromJson(json.decode(str));

String responseOAuthToJson(ResponseOAuth data) => json.encode(data.toJson());


class ResponseOAuth {
  ResponseOAuth({
    required this.message,
    required this.accessToken,
    this.refreshToken,
  });

  String message;
  String accessToken;
  String? refreshToken;

  factory ResponseOAuth.fromJson(Map<String, dynamic> json) => ResponseOAuth(
    message: json["message"],
    accessToken: json["token"],
    refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": accessToken,
    "refresh_token": refreshToken,
  };
}
