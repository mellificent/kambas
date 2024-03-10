import 'BaseRequest.dart';

class RequestOAuth extends BaseRequest {

  // todo: add value for client id and secret
  static const _clientId = '';
  static const _clientSecret = '';

  static const _grantTypePassword = 'password';
  static const _grantTypeRefreshToken = 'refresh_token';

  String? email;
  String? password;
  String? refresh;

  // from login screen
  RequestOAuth.newToken({
    required this.email,
    required this.password,
  });

  // requesting via refresh token (if recorded in pref repo)
  RequestOAuth.refresh({
    required this.email,
    required this.refresh,
  });

  @override
  Map<String, String> getData() => (refresh == null)
      ? {
    "username": email!,
    "password": password!,
          // "grant_type": _grantTypePassword,
          // "client_id": _clientId,
          // "client_secret": _clientSecret,
        }
      : {
    "username": email!,
    "refresh_token": refresh ?? '',
          // "grant_type": _grantTypeRefreshToken,
          // "client_id": _clientId,
          // "client_secret": _clientSecret,
        };
}
