class ApiSettings {
  static const HOST_LIVE = 'https://sample.com';
  static const HOST_TEST_STAGING = 'https://sample.com';
  static const HOST_DEBUG = 'https://sample.com';
  static const EXTENSION = '';
  static const EXTENSION_DEV = '';

  static const ENDPOINT_REGISTER = '/register';
  static const ENDPOINT_LOGIN = '/auth/login';
  static const ENDPOINT_GET_USER_DETAILS = '/user';

  static const HOST = HOST_LIVE + EXTENSION;

  static const API_REGISTER = HOST + ENDPOINT_REGISTER;
  static const API_LOGIN = HOST + ENDPOINT_LOGIN;
  static const API_GET_USER_DETAILS = HOST + ENDPOINT_GET_USER_DETAILS;

  static const STORAGE_PATH = HOST;
}
