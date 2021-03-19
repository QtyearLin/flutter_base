import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_module/provider/app_provider.dart';
import 'package:flutter_module/widget/base_error_page.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'provider/user_provider.dart';
import 'provider/global.dart';

Future<void> main() {
  DateTime time = new DateTime.now();
  //全局异常捕获
  runZoned(() async {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return BaseErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(),
          details);
    };
    await Global.init();
    runApp(MultiProvider(child: MyApp(), providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AppProvider()),
    ]));
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}
