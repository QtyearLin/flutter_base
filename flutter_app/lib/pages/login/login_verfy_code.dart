import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/apis/app_apis.dart';
import 'package:flutter_app/bean/user_bean.dart';
import 'package:flutter_app/config/app_keys.dart';
import 'package:flutter_app/pages/login/countdown.dart';
import 'package:flutter_app/provider/global.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/utils/storage.dart';
import 'package:logger/logger.dart';
import 'package:flutter_app/widget/base_toast.dart';
import '../../style/app_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:provider/provider.dart';

import '../home_index.dart';

//验证码登录
class LoginWithVerfyCodePage extends StatefulWidget {
  final phone;

  final bool type; //学生 true 老师 false

  @override
  _LoginWithVerfyCodePageState createState() => _LoginWithVerfyCodePageState();

  const LoginWithVerfyCodePage({Key? key, this.phone, this.type = true})
      : super(key: key);
}

class _LoginWithVerfyCodePageState extends State<LoginWithVerfyCodePage>
    with CountDownCallbackMixin {
  final String _password = ''; //密码

  static const _codeCountdownStr = '获取验证码';

  var logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 150,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 80,
                  alignment: Alignment.centerLeft,
                  child: const Text("请输入验证码登录",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 24.0,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text("验证码已发送至 : " + widget.phone,
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 14.0,
                      )),
                ),
                SizedBox(
                  height: 70,
                  child: VerificationBox(
                    count: 6,
                    autoFocus: true,
                    showCursor: true,
                    unfocus: false,
                    cursorWidth: 2,
                    cursorColor: AppColors.primaryValue,
                    cursorIndent: 10,
                    cursorEndIndent: 10,
                    focusBorderColor: AppColors.primaryValue,
                    type: VerificationBoxItemType.underline,
                    onSubmitted: (value) {
                      _loginWithVCode(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  alignment: Alignment.centerLeft,
                  child: CountDownWidget(
                      title: _codeCountdownStr, callbackMixin: this),
                ),
              ],
            ),
          )),
    );
  }

  //获取验证码

  bool isRequest = false;

  //登录
  void _loginWithVCode(value) {
    if (isRequest) return;
    isRequest = true;
    EasyLoading.show(status: "正在登录...", dismissOnTap: true);
    UserApi.loginWithVCode({
      'phone': widget.phone,
      'verify_code': value,
      'client_agent': AppDataKeys.clientAgent,
      'client_type': AppDataKeys.clientType,
      'company_code': Global.xx,
    }, (data) {
      EasyLoading.dismiss(animation: true);
      BaseToast.showToast("登录成功");
      //save data
      Provider.of<UserProvider>(context, listen: false).saveUser(data);
      StorageUtil().setString(AppDataKeys.user_name, widget.phone);
      StorageUtil().setString(AppDataKeys.user_passwd, _password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeIndex()),
          (route) => route == null);
    }, (code, message) {
      // EasyLoading.dismiss(animation: true);
      // BaseToast.showErroToast("登录失败");
      // isRequest = false;

      EasyLoading.dismiss(animation: true);
      BaseToast.showToast("登录成功");
      //save data
      UserBean data = UserBean();
      data.id = 1;
      data.phone = "12312312";
      data.name = "XXX";
      Provider.of<UserProvider>(context, listen: false).saveUser(data);
      StorageUtil().setString(AppDataKeys.user_name, widget.phone);
      StorageUtil().setString(AppDataKeys.user_passwd, _password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeIndex()),
          (route) => route == null);
    });
  }

  @override
  void  getVerifyCode() {
    EasyLoading.show(status: "请稍后...", dismissOnTap: true);
    UserApi.getVerifyCode({
      'phone': widget.phone,
    }, (data) {
      EasyLoading.dismiss(animation: true);
      BaseToast.showToast("验证码获取成功，请查收短信新");
      FocusScope.of(context).unfocus();
      //save data
    }, (code, message) {
      EasyLoading.dismiss(animation: true);
      BaseToast.showErroToast("验证码获失败,$message");
    });
  }
}
