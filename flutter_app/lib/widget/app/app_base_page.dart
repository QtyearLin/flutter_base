import 'package:flutter/material.dart';

class AppBasePage extends StatefulWidget {
  final Widget child;

  AppBasePage({Key? key, required this.child}) : super(key: key);

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
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AppBasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @protected
  @override
  void dispose() {
    super.dispose();
  }

  @protected
  @override
  void deactivate() {
    super.deactivate();
  }

  @protected
  @override
  void initState() {
    super.initState();
  }
}
