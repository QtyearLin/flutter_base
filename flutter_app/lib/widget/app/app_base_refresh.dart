import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'app_pull_header.dart';

typedef OnRefreshLoadCallback = Future<void> Function(
    int page, EasyRefreshController controller, bool refresh);

class AppBaseRefreshWidget extends StatefulWidget {
  final List<Widget>? slivers;
  final enableControlFinishRefresh;
  final enableControlFinishLoad;
  final OnRefreshLoadCallback? future;

  const AppBaseRefreshWidget(
      {Key? key,
      this.slivers,
      this.enableControlFinishRefresh = false,
      this.enableControlFinishLoad = false,
      this.future})
      : super(key: key);

  @override
  _AppBaseRefreshWidgetState createState() => _AppBaseRefreshWidgetState();
}

class _AppBaseRefreshWidgetState extends State<AppBaseRefreshWidget> {
  int page = 1;
  late EasyRefreshController controller;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      enableControlFinishRefresh: widget.enableControlFinishLoad,
      enableControlFinishLoad: widget.enableControlFinishLoad,
      controller: controller,
      header: AppPullHeader(),
      footer: ClassicalFooter(),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      slivers: widget.slivers,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = EasyRefreshController();
    controller.callRefresh();
  }

  Future<void> _onRefresh() {
    page = 1;
    return widget.future!(page, controller, false);
  }

  Future<void> _onLoad() {
    page++;
    return widget.future!(page, controller, true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
