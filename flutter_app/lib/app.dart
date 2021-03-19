import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_module/provider/app_provider.dart';
import 'package:flutter_module/route/routes.dart';
import 'package:flutter_module/style/app_theme.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'localization/app_localizations_delegate.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const TAG = "App";
  static const MethodChannel _methodChannel =
      MethodChannel(AppConfig.methodChannel);

  @override
  Widget build(BuildContext context) {
    // _initContext(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationsDelegate.delegate
      ],
      supportedLocales: AppLocalizationsDelegate.delegate.supportedLocales,
      localeResolutionCallback: AppLocalizationsDelegate.delegate.resolution(),
      locale: Provider.of<AppProvider>(context).locale,
      //内部切换
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        textTheme: AppConstant.textTheme,
        platform: TargetPlatform.android,
      ),
      builder: (BuildContext context, Widget child) {
        /// make sure that loading can be displayed in front of all other widgets
        return FlutterEasyLoading(
          child: child,
        );
      },
      initialRoute: '/',
      //初始化的时候加载的路由
      onGenerateRoute: onGenerateRoute,
    );
  }

  @override
  void initState() {
    _init();
  }

  Function _init() {
    ///register page widget builders,the key is pageName
  }

  void _initContext(BuildContext context) {
    //platform
    _methodChannel.invokeMethod(AppConfig.getPlatformVersion).then((value) {
      print("getPlatformVersion:" + value.toString());
      Provider.of<AppProvider>(context, listen: false).platForm = value;
    }, onError: (e) {
      print("getPlatformVersion:$e");
    });
  }
}
