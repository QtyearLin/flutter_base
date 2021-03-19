import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class RouteUtils {
  static const PAGE_ROOT = '/';
  static const PAGE_LOGIN = '/login';

  static const PAGE_MAIN = '/main';


  static const PAGE_ACTIVITY = '/activity';

  static const PAGE_NATIVE_PREFIX = '#';

  static Future<Object> pushNamed(
      var name, BuildContext context, Object params) {
    Navigator.pushNamed(
      context,
      name,
      arguments: params,
    );
  }


  static Future<Object> pushNamedAndRemoveAll(
      var name, BuildContext context, Object params) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      name,
      (Route<dynamic> route) => false,
      arguments: params,
    );
  }


  static Future<Object> pushAndRemoveUntil(
      Widget widget, BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      new CupertinoPageRoute(
          builder: (context) => pageContainer(widget, context)),
      (Route<dynamic> route) => false,
    );
  }


  static Future<Object> pushNamedAndRemoveUntil(
      var name, var end, BuildContext context, Object params) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      name,
      ModalRoute.withName(end),
      arguments: params,
    );
  }

  /**
   * 替换当前
   */
  static Future<Object> pushReplacementNamed(
      var name, BuildContext context, Object params) {
    Navigator.pushReplacementNamed(
      context,
      name,
      arguments: params,
    );
  }

  ///公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => pageContainer(widget, context)));
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(

        ///不受系统字体缩放影响
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget);
  }

  //首页
  static void goMain(BuildContext context) {
    RouteUtils.pushNamedAndRemoveAll(PAGE_MAIN, context, null);
  }

  //登录
  static void goLogin(BuildContext context) {
    RouteUtils.pushNamedAndRemoveAll(PAGE_LOGIN, context, null);
  }


  static void goPage(BuildContext context, var name, {Map params}) {
    Navigator.pushNamed(context, name, arguments: params);
  }

  static void goPageWithBean(BuildContext context, var name, var params) {
    Navigator.pushNamed(context, name, arguments: params);
  }

  //channel
  static const methodPlatForm =
      const MethodChannel('com.app.pack/plugin.method.');
  static const eventPlatForm =
      const EventChannel('com.app.pack/plugin.event.');

  static Future<Null> jumpToNativeWithValue(var method, {Map map}) async {
    if (null == map) {
      map = {"flutter": "这是一条来自flutter的参数"};
    }
    var result = await methodPlatForm.invokeMethod(method, map);
    print("_jumpToNativeWithValue:params:" + map.toString());
  }

  static void pop<T extends Object>(BuildContext context) {
    Navigator.of(context).pop();
  }
}
