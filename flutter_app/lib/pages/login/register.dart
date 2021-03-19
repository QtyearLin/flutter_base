import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_module/style/app_theme.dart';
import 'package:flutter_module/widget/app/like_login_btn.dart';
import 'package:flutter_module/widget/app/logo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodeCode = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _userPasswdController = new TextEditingController();

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _username = "";
  var _code = "";
  var _password = "";
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  Timer _countdownTimer;
  var _codeCountdownStr = "获取验证码";
  int _countdownNum = 59;

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }

      _codeCountdownStr = "${_countdownNum--}重新获取";
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = "${_countdownNum--}重新获取";
          } else {
            _codeCountdownStr = "获取验证码";
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // logo 图片区域
    Widget logoImageArea = LogoWidget();

    //输入文本框区域
    Widget inputTextArea = new Container(
      // height: ScreenUtil().setHeight(40),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                // suffixIcon: IconButton(
                //   icon: Icon(Icons.clear),
                //   onPressed: () {
                //     // 清空输入框内容
                //     _userNameController.clear();
                //   },
                // )
              ),
              validator: (value) {
                return value.trim().length > 0 ? null : "用户名不能为空！";
              },
              onSaved: (value) {
                _username = value;
              },
            ),
            new Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    controller: _codeController,
                    focusNode: _focusNodeCode,
                    decoration: InputDecoration(
                      labelText: "验证码",
                      hintText: "请输入验证码",
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    validator: (value) {
                      return value.trim().length > 0 ? null : "验证码不能为空！";
                    },
                    onSaved: (value) {
                      _code = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: FlatButton(
                    child: Text(
                      _codeCountdownStr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Theme.of(context).primaryColor,
                    //忘记密码按钮，点击执行事件
                    onPressed: () {
                      reGetCountdown();
                    },
                  ),
                )
              ],
            ),
            new TextFormField(
              controller: _userPasswdController,
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              // //密码验证
              validator: (value) {
                return value.trim().length > 0 ? null : "密码不能为空！";
              },
              onSaved: (value) {
                _password = value;
              },
            )
          ],
        ),
      ),
    );

    Widget confirmButtonArea = AppChipeBtn('注册', onPressed: () {
      //点击登录按钮，解除焦点，回收键盘
      _focusNodePassWord.unfocus();
      _focusNodeCode.unfocus();
      _focusNodeUserName.unfocus();

      if (_formKey.currentState.validate()) {
        print("确定");
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text(''),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          _focusNodePassWord.unfocus();
          _focusNodeCode.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: new Stack(children: <Widget>[
          ListView(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              logoImageArea,
              new SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              inputTextArea,
              new SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              confirmButtonArea
            ],
          )
        ]),
      ),
      backgroundColor: Colors.white,
    );
  }
}
