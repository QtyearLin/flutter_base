import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BaseToast {
  static showToast(var msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12,
    );
  }

  static showErroToast(var msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12,
    );
  }
}
