class ApiSettings {
  static const HOST_LIVE = '';
  static const HOST_DEBUG = 'https://dev.kambasdossortes.com';
  static const EXTENSION = '';
  static const EXTENSION_DEV = '/v2/pos';

  static const ENDPOINT_REGISTER = '/register';
  static const ENDPOINT_LOGIN = '/login';
  static const ENDPOINT_GET_USER_DETAILS = '/user';

  static const HOST = HOST_DEBUG + EXTENSION_DEV;

  static const API_REGISTER = HOST + ENDPOINT_REGISTER;
  static const API_LOGIN = HOST + ENDPOINT_LOGIN;
  static const API_GET_USER_DETAILS = HOST + ENDPOINT_GET_USER_DETAILS;

  static const STORAGE_PATH = HOST;
}
