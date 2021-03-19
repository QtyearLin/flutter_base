import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_module/style/app_theme.dart';

class AppChipeBtn extends StatelessWidget {
  final String title;

  final VoidCallback onPressed;
  final bool full = true;
  final double height;

  final double marginLR;
  final double marginTB;

  final double paddingLR;
  final double paddingTB;

  final Color colorBg;
  final Color colorTitle;

  final ShapeBorder borderRadius;

  final double defaultBorderRadiusSize;

  AppChipeBtn(
    this.title, {
    this.onPressed,
    this.height = 44,
    this.marginLR = 20,
    this.marginTB = 10,
    this.paddingLR = 0,
    this.paddingTB = 0,
    this.colorBg,
    this.colorTitle,
    this.borderRadius,
    this.defaultBorderRadiusSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: marginLR, right: marginLR, top: marginTB, bottom: marginTB),
      padding: EdgeInsets.only(
          left: paddingLR, right: paddingLR, top: paddingTB, bottom: paddingTB),
      height: height,
      child: RaisedButton(
        color: colorBg ?? Theme.of(context).primaryColor,
        child: Text(
          title,
          style: colorTitle ?? Theme.of(context).primaryTextTheme.title,
        ),
        // 设置按钮圆角
        shape: borderRadius ??
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadiusSize)),
        onPressed: onPressed,
      ),
    );
  }
}
