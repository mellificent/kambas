class ApiSettings {
  static const HOST_LIVE = '';
  static const HOST_DEBUG = 'https://dev.kambasdossortes.com';
  static const EXTENSION = '';
  static const EXTENSION_DEV = '/api/v2';

  static const ENDPOINT_REGISTER = '/';
  static const ENDPOINT_LOGIN = '/auth/authenticate';
  static const ENDPOINT_BETS = '/bets';
  static const ENDPOINT_GET_USER_DETAILS = '/';

  static const HOST = HOST_DEBUG + EXTENSION_DEV;

  static const API_REGISTER = HOST + ENDPOINT_REGISTER;
  static const API_LOGIN = HOST + ENDPOINT_LOGIN;
  static const API_BETS = HOST + ENDPOINT_BETS;

  static const API_GET_USER_DETAILS = HOST + ENDPOINT_GET_USER_DETAILS;

  static const STORAGE_PATH = HOST;
}
