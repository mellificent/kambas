import 'BaseRequest.dart';

class RequestOAuth extends BaseRequest {
  String? email;
  String? password;

  String? token;

  // from login screen
  RequestOAuth.newToken({
    required this.email,
    required this.password,
  });

  // requesting via refresh token (if recorded in pref repo)
  RequestOAuth.refresh({
    required this.token,
  });

  @override
  Map<String, String> getData() => (token == null)
      ? {
    "username": email!,
    "password": password!,
          // "grant_type": _grantTypePassword,
          // "client_id": _clientId,
          // "client_secret": _clientSecret,
        }
      : {
    "token": token ?? "",
        };
}
