import 'package:flutter/material.dart';
import 'package:flutter_module/style/app_theme.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
      child: Column(
        children: <Widget>[
          Image.asset(
            AppICons.DEFAULT_APP_LOGO,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        ],
      ),
      ),
    );
  }
}
