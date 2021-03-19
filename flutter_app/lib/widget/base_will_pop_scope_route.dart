import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'base_toast.dart';  //提示插件

class BaseWillPopScopeRoute extends StatefulWidget {
  final Widget child;
  BaseWillPopScopeRoute({Key key, this.child}) : super(key: key);
  @override
  BaseWillPopScopeRouteState createState() {
    return new BaseWillPopScopeRouteState();
  }
}
class BaseWillPopScopeRouteState extends State<BaseWillPopScopeRoute> {
  DateTime _lastPressedAt; //上次点击时间
  var status = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){return status=true;},
      child: WillPopScope(
        child: widget.child,
        onWillPop: () async {
          if (_lastPressedAt == null) {
            BaseToast.showToast("双击退出程序...");
          }
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
      ),
    );
  }
}