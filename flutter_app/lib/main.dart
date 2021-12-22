import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'provider/app_provider.dart';
import 'provider/user_provider.dart';
import 'widget/base_error_page.dart';

Future<void> main() async {
  //全局异常捕获
  runZoned(() async {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      return BaseErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(),
          details);
    };
    runApp(MultiProvider(child: MyApp(), providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AppProvider()),
    ]));
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}
