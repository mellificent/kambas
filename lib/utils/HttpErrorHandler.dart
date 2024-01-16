import 'package:dio/dio.dart';

class HttpErrorHandler {
  int code;
  String? message;
  String Function(DioError)? function;

  HttpErrorHandler.message(this.code, this.message);
  HttpErrorHandler.function(this.code, this.function);
}
