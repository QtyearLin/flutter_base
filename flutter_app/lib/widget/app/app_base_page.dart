import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class AppBasePage extends StatefulWidget {
  final Widget child;

  AppBasePage({Key key, this.child}) : super(key: key);

  @override
  _AppBaseScaffoldState createState() => _AppBaseScaffoldState();
}

class _AppBaseScaffoldState extends State<AppBasePage> {
  var _tag;

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }

  @override
  void didChangeDependencies() {
    _tag = this.widget.runtimeType.toString();
    LogUtil.v("didChangeDependencies", tag: _tag);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AppBasePage oldWidget) {
    LogUtil.v("didUpdateWidget", tag: _tag);
    super.didUpdateWidget(oldWidget);
  }

  @protected
  @override
  void dispose() {
    LogUtil.v("dispose", tag: _tag);
    super.dispose();
  }

  @protected
  @override
  void deactivate() {
    LogUtil.v("deactivate", tag: _tag);
    super.deactivate();
  }

  @protected
  @override
  void initState() {
    LogUtil.v("initState", tag: _tag);
    super.initState();
  }
}

