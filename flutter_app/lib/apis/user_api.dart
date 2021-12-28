import 'dart:async';

import 'package:flutter_app/bean/user_bean.dart';

import '../utils/http.dart';

import '../config/app_url.dart';

class UserApi {
  static const int PAGE_SIZE = 20;

  static login(
      Map<String, dynamic> params, Function onSuccess, Function onError) {
    HttpUtil().post(AppUrl.Login, data: params, success: (response) {
      // 请求成功返回的数据
      UserBean? userBean = UserBean.fromMap(response);
      userBean?.role = 0;
      onSuccess(userBean);
    }, error: (code, errorMsg) {
      // 请求失败返回的错误信息
      onError(code, errorMsg);
    });
  }

  static loginWithVCode(
      Map<String, dynamic> params, Function onSuccess, Function onError) {
    HttpUtil().post(AppUrl.Login, data: params, success: (response) {
      // 请求成功返回的数据
      UserBean? userBean = UserBean.fromMap(response);
      userBean?.role = 0;
      onSuccess(userBean);
    }, error: (code, errorMsg) {
      // 请求失败返回的错误信息
      onError(code, errorMsg);
    });
  }

  /// 获取验证码
  static getVerifyCode(
      Map<String, dynamic> params, Function onSuccess, Function onError) {
    HttpUtil().post(AppUrl.GetVerifyCode, data: params, success: (response) {
      onSuccess(response);
      // 请求成功返回的数据
    }, error: (code, errorMsg) {
      // 请求失败返回的错误信息
      onError(code, errorMsg);
    });
  }
}
