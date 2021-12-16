import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/apis/user_api.dart';
import 'package:flutter_app/config/app_keys.dart';
import 'package:flutter_app/pages/login/register.dart';
import 'package:flutter_app/provider/global.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:flutter_app/utils/storage.dart';
import 'package:flutter_app/widget/app/like_login_btn.dart';
import 'package:flutter_app/widget/app/logo.dart';
import 'package:flutter_app/widget/base_toast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

import '../home_index.dart';
import 'login_verfy_code.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodePassWord = FocusNode();
  FocusNode _focusNodeUserName = FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userPasswdController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _password = ''; //密码
  String? _username = ''; //用户名
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false;

  bool _showBottom = true; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
    });

    //get auto accout sync
    _username = StorageUtil().getString(AppDataKeys.user_name);
    _password = StorageUtil().getString(AppDataKeys.user_passwd);
    if (null != _username && null != _password) {
      setState(() {
        _userNameController.text = _username!;
        _userPasswdController.text = _password!;
        // _login(auto: true);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  /**
   * 验证用户名
   */
  String? validateUserName(var value) {
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '用户名不能为空!';
    } else if (!exp.hasMatch(value)) {
      return '请输入正确手机号';
    }
    return null;
  }

  /**
   * 验证密码
   */
  String? validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6 || value.trim().length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // logo 图片区域
    Widget logoImageArea = LogoWidget();
    //输入文本框区域
    Widget inputTextArea = Container(
      // height: ScreenUtil().setHeight(40),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (var value) {
                _username = value!;
              },
            ),
            TextFormField(
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
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (var value) {
                _password = value!;
              },
            )
          ],
        ),
      ),
    );
    // 登录按钮区域

    Widget loginButtonArea = AppChipeBtn("登录", onPressed: () {
      //点击登录按钮，解除焦点，回收键盘
      _focusNodePassWord.unfocus();
      _focusNodeUserName.unfocus();

      if (_formKey.currentState!.validate()) {
        //只有输入通过验证，才会执行这里
        _formKey.currentState!.save();
        //todo 登录操作
        print("$_username + $_password");
        _login();
      }
    });

    //第三方登录区域
    Widget thirdLoginArea = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          //  Row(
          //   mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Container(
          //       width: 80,
          //       height: 1.0,
          //       color: Colors.grey,
          //     ),
          //     Text('第三方登录'),
          //     Container(
          //       width: 85,
          //       height: 1.0,
          //       color: Colors.grey,
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 18,
          ),
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: ScreenUtil().setHeight(80),
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.facebook),
                iconSize: ScreenUtil().setHeight(80),
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: ScreenUtil().setHeight(80),
                onPressed: () {},
              )
            ],
          )*/
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
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "快速登录",
                      style: TextStyle(
                        color: AppColors.selected,
                        fontSize: 12.0,
                      ),
                    ),
                    //点击快速注册、执行事件
                    onPressed: () {
                      var name = _userNameController.text;
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
      // resizeToAvoidBottomInset:false,
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
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  // SizedBox(
                  //   height: ScreenUtil().setHeight(100),
                  // ),
                  logoImageArea,
                  SizedBox(
                    height: 30,
                  ),
                  inputTextArea,
                  Container(
                    alignment: Alignment.centerRight,
                    // child:  Row(

                    // )
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            child: Text(
                              "注册",
                              style: TextStyle(
                                color: AppColors.selected,
                                fontSize: 12.0,
                              ),
                            ),
                            //点击快速注册、执行事件
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            }),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
    if (!auto) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
    }
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
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
