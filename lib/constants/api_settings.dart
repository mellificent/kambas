class ApiSettings {
  static const HOST_LIVE = '';
  static const HOST_DEBUG = 'https://dev.kambasdossortes.com';
  static const EXTENSION = '';
  static const EXTENSION_DEV = '/api/v2';

  static const ENDPOINT_REGISTER = '/';
  static const ENDPOINT_LOGIN = '/auth/authenticate';
  static const ENDPOINT_REFRESH = '/auth/refresh-token';
  static const ENDPOINT_ADD_BETS = '/bets/addbet';
  static const ENDPOINT_GET_BETS = '/bets/details';
  static const ENDPOINT_GET_USER_DETAILS = '/';

  static const HOST = HOST_DEBUG + EXTENSION_DEV;

  static const API_REGISTER = HOST + ENDPOINT_REGISTER;
  static const API_LOGIN = HOST + ENDPOINT_LOGIN;
  static const API_REFRESH_LOGIN = HOST + ENDPOINT_REFRESH;
  static const API_ADD_BETS = HOST + ENDPOINT_ADD_BETS;
  static const API_GET_BETS = HOST + ENDPOINT_GET_BETS;

  static const API_GET_USER_DETAILS = HOST + ENDPOINT_GET_USER_DETAILS;

  static const STORAGE_PATH = HOST;
}
