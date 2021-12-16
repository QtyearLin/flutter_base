import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_app/apis/user_api.dart';
import 'package:flutter_app/config/app_keys.dart';
import 'package:flutter_app/pages/login/login.dart';
import 'package:flutter_app/pages/splash/welcom_page.dart';
import 'package:flutter_app/utils/storage.dart';

class RootPageInit extends StatefulWidget {
  @override
  _RootPageInitState createState() => _RootPageInitState();
}

class _RootPageInitState extends State<RootPageInit> {
  // bool firstLaunch =
  //     StorageUtil().getBoolDefault(AppDataKeys.is_first_key_guide, true);
  bool firstLaunch = true;


  @override
  Widget build(BuildContext context) {
    print("initState:firstLaunch:" + firstLaunch.toString());


    return firstLaunch ? WelcomPage() : LoginPage();
  }

  @override
  void initState() {
    super.initState();


  }
}
