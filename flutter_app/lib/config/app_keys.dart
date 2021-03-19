import 'dart:io';

class AppDataKeys {
  static const String prefix = "flutter";

  static const String user = prefix + "user";

  static const String user_name = prefix + "user_name";

  static const String user_passwd = prefix + "user_passwd";

  static const String is_first_opened = prefix + 'device_already_open';

  static const String is_first_key_guide = prefix + 'is_first_key_guide';
  static const String key_splash_model = 'key_splash_models';

  static String clientType = getClientType();
  static String clientAgent = getClientAgent();
}

String getClientType() {
  if (Platform.isAndroid) {
    return "1";
  } else {
    return "2";
  }
}

String getClientAgent() {
  if (Platform.isAndroid) {
    return "android";
  } else {
    return "ios";
  }
}
