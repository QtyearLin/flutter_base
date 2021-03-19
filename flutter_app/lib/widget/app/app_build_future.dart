import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import '../base_empty_shower.dart';
import 'app_loading.dart';

class AppBuildFuture extends StatefulWidget {
  final Future futureBuilderFuture;
  final AsyncWidgetBuilder asyncWidgetBuilder;

  final bool sliver;

  const AppBuildFuture(
      {Key key,
      this.futureBuilderFuture,
      this.sliver = false,
      this.asyncWidgetBuilder})
      : super(key: key);

  @override
  _AppBuildFutureState createState() => _AppBuildFutureState();
}

class _AppBuildFutureState extends State<AppBuildFuture> {
  var _tag;
  var _futureBuilderFuture;

  @override
  void initState() {
    _tag = this.widget.runtimeType.toString();
    _futureBuilderFuture = this.widget.futureBuilderFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: _buildFuture,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    LogUtil.v("_buildFuture:" + snapshot.connectionState.toString(), tag: _tag);
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        LogUtil.v("还没有开始网络请求", tag: _tag);
        return BaseEmptyPage(
          onPress: _futureBuilderFuture,
          sliver: this.widget.sliver,
        );
      case ConnectionState.active:
        LogUtil.v("active", tag: _tag);
        return BaseEmptyPage(
          sliver: this.widget.sliver,
          onPress: _futureBuilderFuture,
        );
      case ConnectionState.waiting:
        LogUtil.v("waiting", tag: _tag);
        return AppLoadingWidget(
          sliver: this.widget.sliver,
        );
      case ConnectionState.done:
        LogUtil.v("done", tag: _tag);
        if (snapshot.hasError) {
          return BaseEmptyPage(
            sliver: this.widget.sliver,
            onPress: _futureBuilderFuture,
          );
        }
        return this.widget.asyncWidgetBuilder(context, snapshot);
      default:
        return AppLoadingWidget(
          sliver: this.widget.sliver,
        );
    }
  }
}
