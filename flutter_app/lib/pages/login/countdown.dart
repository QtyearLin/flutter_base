import 'dart:async';

import 'package:flutter/material.dart';

class CountDownWidget extends StatefulWidget {
  final String? title;
  final CountDownCallbackMixin? callbackMixin;

  const CountDownWidget(
      {Key? key, required this.title, required this.callbackMixin})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  String? _codeCountdownStr;
  int _countdownNum = 60;

  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _codeCountdownStr = widget.title;
  }

  @override
  void dispose() {
    _cancelTimer();
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = 'S后重新获取';
          } else {
            _countdownNum = 59;
            _codeCountdownStr = widget.title!;
            _countdownTimer?.cancel();
            _countdownTimer = null;
          }
        });
      });
      _codeCountdownStr = 'S后重新获取';
      widget.callbackMixin?.getVerifyCode();
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    if (null != _countdownTimer) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        reGetCountdown();
      },
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: (_countdownNum >=60 || _countdownNum == 0)
                      ? ""
                      : '${_countdownNum--}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  )),
              TextSpan(
                  text: ' ${_codeCountdownStr}',
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14.0,
                  )),
            ]),
          )),
    );
  }
}

mixin CountDownCallbackMixin {
  void getVerifyCode();
}
