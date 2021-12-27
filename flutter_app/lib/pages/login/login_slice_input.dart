import 'package:flutter/material.dart';

class LoginSliceInput extends StatefulWidget {
  final String? username;
  final String? password;
  final LoginMinx loginMinx;

  const LoginSliceInput(
      {Key? key,
      required this.username,
      required this.password,
      required this.loginMinx})
      : super(key: key);

  @override
  LoginSliceInputState createState() => LoginSliceInputState();
}

class LoginSliceInputState extends State<LoginSliceInput> {
  //焦点
  final FocusNode _focusNodePassWord = FocusNode();
  final FocusNode _focusNodeUserName = FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  final TextEditingController _userPasswdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  var _isShowClear = false;
  var _isShowPwd = false; //是否显示密码

  //表单状态
  //local key(value,object,unique)  glocal key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void unfocus() {
    _focusNodePassWord.unfocus();
    _focusNodeUserName.unfocus();
  }

  @override
  void initState() {
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.isNotEmpty) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
    });
  }

  @override
  void dispose() {
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return //输入文本框区域
        Container(
      // height: ScreenUtil().setHeight(40),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: const BoxDecoration(
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
                this.widget.loginMinx.onGetUserName(value as String);
              },
            ),
            const SizedBox(
              height: 20,
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
                this.widget.loginMinx.onGetUserPassword(value as String);
              },
            )
          ],
        ),
      ),
    );
    // 登录按钮区域
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

  void valiate() {
    if (_formKey.currentState!.validate()) {
      //只有输入通过验证，才会执行这里
      _formKey.currentState!.save();
      //todo 登录操作
      widget.loginMinx.onValiate(true);
    } else {
      widget.loginMinx.onValiate(false);
    }
  }

  String getCurrentInputName() {
    return _userNameController.text;
  }
}

mixin LoginMinx {
  void onGetUserName(String name);
  void onGetUserPassword(String password);
  void onValiate(bool success);
}
