import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_index.dart';
import 'package:flutter_app/pages/login/login.dart';
import 'package:flutter_app/pages/tabs/index_activity.dart';
import 'package:flutter_app/route/root_init_page.dart';
import 'package:flutter_app/route/route_util.dart';

//配置路由
final routes = {
//      '/':(context)=>Tabs(),
  RouteUtils.PAGE_ROOT: (context) => RootPageInit(),
  RouteUtils.PAGE_MAIN: (context) => HomeIndex(),
  RouteUtils.PAGE_LOGIN: (context) => LoginPage(),
  RouteUtils.PAGE_ACTIVITY: (context, {arguments}) => IndexActivityPage(),
};

/**
 * 路由解析
 */
var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  var name = settings.name;
  Object? arguments = settings.arguments;
  //外部传入 initRoute
  if (name!.contains("?")) {
    name = _getPageName(settings.name);
    var argumentsStr = _getPageParamJsonStr(settings.name);
    arguments = json.decode(argumentsStr);
//    arguments = new Map<var,Object>.from(json.decode(argumentsStr));
  }
  final Function? pageContentBuilder = routes[name!];
  if (pageContentBuilder != null) {
    if (arguments != null) {
      print("onGenerateRoute:name:" + name);
      print("onGenerateRoute:arguments" + arguments.toString());
      print("arguments-type:" + arguments.runtimeType.toString());
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
//init route 外部传入解析
_getPageName(var s) {
  if (s.indexOf("?") == -1) {
    return s;
  } else {
    return s.subvar(0, s.indexOf("?"));
  }
}

_getPageParamJsonStr(var s) {
  if (s.indexOf("?") == -1) {
    return "{}";
  } else {
    return s.subvar(s.indexOf("?") + 1);
  }
}
