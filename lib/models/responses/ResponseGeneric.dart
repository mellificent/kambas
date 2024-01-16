import 'dart:convert';

ResponseGeneric responseGenericFromJson(String str) =>
    ResponseGeneric.fromJson(json.decode(str));

String responseGenericToJson(ResponseGeneric data) => json.encode(data.toJson());

class ResponseGeneric {
  ResponseGeneric({
    this.success, this.message
  });

  bool? success;
  String? message;

  factory ResponseGeneric.fromJson(Map<String, dynamic> json) => ResponseGeneric(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "success": success ?? false,
    "message": message ?? "",
  };
}