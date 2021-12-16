import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:flutter_app/utils/interceptors/log.dart';

class BaseErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  BaseErrorPage(this.errorMessage, this.details);

  @override
  BaseErrorPageState createState() => BaseErrorPageState();
}

class BaseErrorPageState extends State<BaseErrorPage> {
  static List<Map<String, dynamic>> sErrorStack = [];
  static List<String> sErrorName = [];

  final TextEditingController textEditingController =
      new TextEditingController();

  addError(FlutterErrorDetails details) {
    try {
      var map = Map<String, dynamic>();
      map["error"] = details.toString();
      LogsInterceptors.addLogic(
          sErrorName, details.exception.runtimeType.toString());
      LogsInterceptors.addLogic(sErrorStack, map);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width =
        MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;
    return Container(
      color: AppColors.primaryValue,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          decoration:  BoxDecoration(
            color: Colors.white.withAlpha(30),
            gradient:
                RadialGradient(tileMode: TileMode.mirror, radius: 0.1, colors: [
              Colors.white.withAlpha(10),
              AppColors.primaryValue.withAlpha(100),
            ]),
            borderRadius: BorderRadius.all(Radius.circular(width / 2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: new AssetImage(AppICons.DEFAULT_APP_LOGO),
                  width: 90.0,
                  height: 90.0),
              const SizedBox(
                height: 11,
              ),
              Material(
                child: Text(
                  "Error Occur",
                  style: new TextStyle(fontSize: 24, color: Colors.white),
                ),
                color: AppColors.primaryValue,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   FlatButton(
                      color: AppColors.white.withAlpha(100),
                      onPressed: () {
                        String content = widget.errorMessage;
                        textEditingController.text = content;
                        //todo
                      },
                      child: Text("Report")),
                   SizedBox(
                    width: 40,
                  ),
                   FlatButton(
                      color: AppColors.white.withAlpha(100),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Back"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
