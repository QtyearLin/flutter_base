import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/apis/user_api.dart';
import 'package:flutter_app/config/app_keys.dart';
import 'package:flutter_app/pages/login/login_slice_input.dart';
import 'package:flutter_app/pages/login/register.dart';
import 'package:flutter_app/provider/global.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:flutter_app/utils/storage.dart';
import 'package:flutter_app/utils/validator.dart';
import 'package:flutter_app/widget/app/like_login_btn.dart';
import 'package:flutter_app/widget/app/logo.dart';
import 'package:flutter_app/widget/base_toast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../home_index.dart';
import 'login_verfy_code.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with LoginMinx {
  String? _password = ''; //密码
  String? _username = ''; //用户名

  final bool _showBottom = true; //是否显示输入框尾部的清除按钮

  final GlobalKey<LoginSliceInputState> _loginSlice =
      GlobalKey<LoginSliceInputState>();

  @override
  void initState() {
    //get auto accout sync
    _username = StorageUtil().getString(AppDataKeys.user_name);
    _password = StorageUtil().getString(AppDataKeys.user_passwd);

    if (null != _username && null != _password) {
      _login(auto: true);
    }
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
    // logo 图片区域
    Widget logoImageArea = LogoWidget();

    LoginSliceInput inputSlice = LoginSliceInput(
        key: _loginSlice,
        username: _username,
        password: _password,
        loginMinx: this);
    Widget loginButtonArea =
        AppChipeBtn("登录", colorTitle: Colors.white, onPressed: () {
      _loginSlice.currentState?.valiate();
    });
    const double imageSize = 56;
    //第三方登录区域
    Widget thirdLoginArea = Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
              const Text('第三方登录'),
              Container(
                width: 85,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: const Icon(FontAwesomeIcons.weixin),
                iconSize: imageSize,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.facebook),
                iconSize: imageSize,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: imageSize,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );

    //忘记密码  立即注册
    Widget bottomArea = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: _showBottom,
        child: Column(
          children: <Widget>[
            thirdLoginArea,
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: const Text(
                      "快速登录",
                      style: TextStyle(
                        color: AppColors.selected,
                        fontSize: 12.0,
                      ),
                    ),
                    //点击快速注册、执行事件
                    onPressed: () {
                      var name =
                          _loginSlice.currentState?.getCurrentInputName();
                      if (validateUserName(name) == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginWithVerfyCodePage(
                                    phone: name, type: false)));
                      } else {
                        BaseToast.showToast("请输入正确的手机号");
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text('登录'),
        centerTitle: true,
        leading: null,
      ),
//       backgroundColor: Color(0xff274641),
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: GestureDetector(
          onTap: () {
            // 点击空白区域，回收键盘
            print("点击了空白区域");
            _loginSlice.currentState?.unfocus();
          },
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  // SizedBox(
                  //   height: ScreenUtil().setHeight(100),
                  // ),
                  logoImageArea,
                  const SizedBox(
                    height: 70,
                  ),
                  inputSlice,
                  Container(
                    alignment: Alignment.centerRight,
                    // child:  Row(

                    // )
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            child: const Text(
                              "注册",
                              style: TextStyle(
                                color: AppColors.selected,
                                fontSize: 14.0,
                              ),
                            ),
                            //点击快速注册、执行事件
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            }),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  loginButtonArea,
                ],
              ),
              bottomArea,
            ],
          )),
    );
  }

  _login({bool auto = false}) async {
    EasyLoading.show(status: "正在加载中...");
    var userName = _username;
    var userPasswd = _generateMd5(_password);
    UserApi.login(Global.isLoginAsTeacher, {
      'username': userName,
      'password': userPasswd,
      'client_agent': AppDataKeys.clientAgent,
      'client_type': AppDataKeys.clientType
    }, (data) {
      EasyLoading.dismiss(animation: true);
      BaseToast.showToast("登录成功");
      //save data
      context.read<UserProvider>().saveUser(data);

      StorageUtil().setString(AppDataKeys.user_name, _username);
      StorageUtil().setString(AppDataKeys.user_passwd, _password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeIndex()),
          (route) => route == null);
    }, (code, message) {
      EasyLoading.dismiss(animation: true);
      BaseToast.showErroToast("登录失败");
    });
  }

// md5 加密
  _generateMd5(var data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  @override
  void onGetUserName(String name) {
    _username = name;
  }

  @override
  void onGetUserPassword(String password) {
    _password = password;
  }

  @override
  void onValiate(bool success) {
    if (success) {
      _login(auto: false);
    }
  }
}
