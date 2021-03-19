import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_module/bean/user_bean.dart';
import 'package:flutter_module/config/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isLogin;
  bool _loginOut;
  UserBean _userBean;
 //    Consumer
  save(Map user) async {
    UserBean userBean = UserBean.fromMap(user);
    print("userBean:" + userBean.toString());
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString(AppDataKeys.user, user.toString());
    _userBean = userBean;
    notifyListeners();
  }

  saveUser(UserBean userBean) async {
    print("userBean:" + userBean.toString());
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString(AppDataKeys.user, json.encode(userBean));
    _userBean = userBean;
    notifyListeners();
  }

  clearUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString(AppDataKeys.user, null);
    _userBean = null;
    notifyListeners();
  }

  getFromDisk() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var user = prefs.getString(AppDataKeys.user);
      if(user==null)
        return null;
    print("read local user: $user");
    _userBean = UserBean.fromMap(json.decode(user));
    print("read local user bean: $_userBean");
    return _userBean;
  }

  UserBean get() {
    return _userBean;
  }

  login() {
    _isLogin = true;
    notifyListeners();
  }

  logOut() {
    _loginOut = true;
    _isLogin = false;
    clearUser();
  }
}
