import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/apis/user_api.dart';
import 'package:flutter_module/bean/user_bean.dart';
import 'package:flutter_module/pages/login/register.dart';
import 'package:flutter_module/pages/home_index.dart';
import 'package:flutter_module/config/app_url.dart';
import 'package:flutter_module/config/app_keys.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/provider/global.dart';
import 'package:flutter_module/provider/user_provider.dart';
import 'package:flutter_module/style/app_theme.dart';
import 'package:flutter_module/utils/storage.dart';
import 'package:flutter_module/widget/base_toast.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//验证码登录
class LoginWithVerfyCodePage extends StatefulWidget {
  final  phone;

  final bool type; //学生 true 老师 false

  @override
  _LoginWithVerfyCodePageState createState() => _LoginWithVerfyCodePageState();

  LoginWithVerfyCodePage({Key key, this.phone, this.type = true})
      : super(key: key);
}

class _LoginWithVerfyCodePageState extends State<LoginWithVerfyCodePage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮
  int _countdownNum = 59;

  Timer _countdownTimer;

  var _codeCountdownStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    // reGetCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      getVerifyCode();
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '${_countdownNum--} 后重新获取';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}重新获取';
          } else {
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    if (null != _countdownTimer)
      // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
      _countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: new Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                new SizedBox(
                  height: ScreenUtil().setHeight(150),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 8),
                  height: ScreenUtil().setHeight(80),
                  alignment: Alignment.centerLeft,
                  child: Text("请输入验证码登录",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20.0,
                      )),
                ),
                new SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10),
                  height: ScreenUtil().setHeight(50),
                  alignment: Alignment.centerLeft,
                  child: Text("验证码已发送至 : " + widget.phone,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 10.0,
                      )),
                ),
                Container(
                  height: ScreenUtil().setHeight(100),
                  child: VerificationBox(
                    count: 6,
                    autoFocus: true,
                    showCursor: true,
                    unfocus: false,
                    cursorWidth: 2,
                    cursorColor: Colors.red,
                    cursorIndent: 10,
                    cursorEndIndent: 10,
                    focusBorderColor: AppColors.primaryValue,
                    type: VerificationBoxItemType.underline,
                    onSubmitted: (value) {
                      _loginWithVCode(value);
                    },
                  ),
                ),
                new SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 8),
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {
                        reGetCountdown();
                      },
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(_codeCountdownStr,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10.0,
                              )))),
                ),
              ],
            ),
          )),
    );
  }

  //获取验证码
  void getVerifyCode() {
    EasyLoading.show(status: "请稍后...");
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

  bool isRequest = false;

  //登录
  void _loginWithVCode(value) {
    if (isRequest) return;
    isRequest = true;
    EasyLoading.show(status: "正在登录...");
    UserApi.loginWithVCode(Global.isLoginAsTeacher, {
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
      UserBean data = new UserBean();
      data.id = 1;
      data.phone= "12312312";
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
}
