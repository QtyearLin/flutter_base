import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utils/http.dart';
import 'package:flutter_app/utils/storage.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../config/app_keys.dart';
import 'user_provider.dart';

/// 全局配置
class Global {
  /// 用户配置
  //replace by userProvider

  /// 发布渠道
  static const channel = "xiaomi";

  /// 是否 ios
  static bool isIOS = Platform.isIOS;

  /// android 设备信息
  static late AndroidDeviceInfo androidDeviceInfo;

  /// ios 设备信息
  static late IosDeviceInfo iosDeviceInfo;

  /// 包信息
  static late PackageInfo packageInfo;

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  static var xx = "1231";

  static bool isLoginAsTeacher = false; //老师

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // 读取设备信息
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Global.isIOS) {
      deviceInfoPlugin.iosInfo.then((value) => Global.iosDeviceInfo = value);
    } else {
      deviceInfoPlugin.androidInfo
          .then((value) => Global.androidDeviceInfo = value);
    }
    // 包信息
    PackageInfo.fromPlatform().then((value) {
      Global.packageInfo = value;
    });
    // 工具初始
    await StorageUtil.init();
    isFirstOpen =
        StorageUtil().getBoolDefault(AppDataKeys.is_first_opened, true);
    if (isFirstOpen) {
      StorageUtil().setBool(AppDataKeys.is_first_opened, false);
    }
    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
