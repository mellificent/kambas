import 'package:dio/dio.dart';

abstract class BaseRequest {
  const BaseRequest();

  Map<String, dynamic> getData();

  FormData get formData => FormData.fromMap(getData());

  void insertToMap(Map<String, dynamic> map, String key, String? value) {
    if (value == null) return;
    if (value.isNotEmpty) {
      if (value is String && value == 'null') return;
      map[key] = value;
    }
  }
}
