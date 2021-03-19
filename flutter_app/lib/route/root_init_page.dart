import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_module/apis/user_api.dart';
import 'package:flutter_module/config/app_keys.dart';
import 'package:flutter_module/pages/login/login.dart';
import 'package:flutter_module/pages/splash/welcom_page.dart';
import 'package:flutter_module/utils/storage.dart';
import 'package:flutter_screenutil/screenutil.dart';

class RootPageInit extends StatefulWidget {
  @override
  _RootPageInitState createState() => _RootPageInitState();
}

class _RootPageInitState extends State<RootPageInit> {
  bool firstLaunch =
      StorageUtil().getBoolDefault(AppDataKeys.is_first_key_guide, true);

  @override
  Widget build(BuildContext context) {
    print("initState:firstLaunch:" + firstLaunch.toString());
    ScreenUtil.init(
      context,
      width: 720,
      height: 1334 - 44 - 34,
      allowFontScaling: true,
    );

    return firstLaunch ? WelcomPage() : LoginPage();
  }

  @override
  void initState() {
    super.initState();


  }
}
