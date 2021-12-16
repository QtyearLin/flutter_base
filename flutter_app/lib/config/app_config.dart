class AppConfig {
  static const PAGE_SIZE = 20;
  static const DEBUG = true;
  static const NET_CACHE_ENABLE = true;
  static const USE_NATIVE_WEBVIEW = true;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  static const TOKEN_KEY = "token";
  static const USER_NAME_KEY = "user-name";
  static const PW_KEY = "user-pw";
  static const USER_INFO = "user-info";
  static const LANGUAGE_SELECT = "language-select";
  static const LANGUAGE_SELECT_NAME = "language-select-name";
  static const REFRESH_LANGUAGE = "refreshLanguageApp";
  static const THEME_COLOR = "theme-color";
  static const LOCALE = "locale";

  // 缓存的最长时间，单位（秒）
  static const CACHE_MAXAGE = 30;
// 最大缓存数
  static const CACHE_MAXCOUNT = 100;

  // 是否启用代理
  static const PROXY_ENABLE = false;

  /// 代理服务IP
// const PROXY_IP = '192.168.1.105';
  static const PROXY_IP = '172.16.43.74';

  /// 代理服务端口
  static const PROXY_PORT = 8866;

  static const CONNEC_TOUT = 60 * 1000;
  static const RECEIVE_TOUT = 5 * 1000;

  static const methodChannel = "com.app.pack/plugin.method.";
  static const eventChannel = "com.app.pack/plugin.event.";
  static const getPlatformVersion = "getPlatformVersion";
}
