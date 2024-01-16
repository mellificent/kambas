import 'dart:convert';

ResponseErrorGeneric responseErrorOAuthFromJson(String str) =>
    ResponseErrorGeneric.fromJson(json.decode(str));

String responseErrorOAuthToJson(ResponseErrorGeneric data) =>
    json.encode(data.toJson());

class ResponseErrorGeneric {
  ResponseErrorGeneric({
    this.error,
    this.errorDescription,
    this.hint,
    this.message,
  });

  String? error;
  String? errorDescription;
  String? hint;
  String? message;

  factory ResponseErrorGeneric.fromJson(Map<String, dynamic> json) =>
      ResponseErrorGeneric(
        error: json["error"],
        errorDescription: json["error_description"],
        hint: json["hint"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "error_description": errorDescription,
        "hint": hint,
        "message": message,
      };
}
