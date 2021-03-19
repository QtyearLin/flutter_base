import 'package:flutter/material.dart';
import 'package:flutter_module/localization/default_localizations.dart';
import 'package:flutter_module/route/route_util.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_module/widget/base_empty_shower.dart';

class IndexActivityPage extends StatefulWidget {
  IndexActivityPage({Key key}) : super(key: key);

  _IndexActivityPageState createState() => _IndexActivityPageState();
}

class _IndexActivityPageState extends State<IndexActivityPage> with AutomaticKeepAliveClientMixin  {
  static const nativeChannel =
      const MethodChannel('com.example.flutter/navtive');
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Center(
        child: BaseEmptyPage(message: "敬请期待",),
      ),
    )
    ;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

Future<void> openNativePage(MethodChannel channel, var str) async {
  Map<dynamic, dynamic> para = {'message': str};
  final int result = await channel.invokeMethod('join', para);
  print(result);
}
