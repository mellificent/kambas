import 'package:dio/dio.dart';
import 'package:kambas/constants/app_strings.dart';

import '../utils/HttpErrorHandler.dart';

abstract class BaseProvider {

  String getErrorMessage(Object e,
      {String msgTimeout = AppStrings.error_general_connect_timeout_msg,
        String msgNoInternet = AppStrings.error_general_no_internet_msg,
        String msgGeneral = AppStrings.error_general_throwable_msg,
        List<HttpErrorHandler> httpErrorHandlers = const <HttpErrorHandler>[]}) {
    if (e is DioError) {
      if ((e.type == DioExceptionType.connectionTimeout)) {
        return msgTimeout;
      } else if (e.type == DioExceptionType.unknown) {
        return msgNoInternet;
      } else {
        if (httpErrorHandlers.isNotEmpty) {
          for (var item in httpErrorHandlers) {
            if (e.response?.statusCode == item.code) {
              if (item.message != null) {
                return item.message!;
              }
              if (item.function != null) {
                return item.function!.call(e);
              }
            }
          }
        }

        return msgGeneral;
      }
    }
    return msgGeneral;
  }
}
