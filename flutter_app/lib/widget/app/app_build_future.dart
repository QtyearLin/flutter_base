import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../base_empty_shower.dart';
import 'app_loading.dart';

class AppBuildFuture extends StatefulWidget {
  
  final Future? futureBuilderFuture;
  final AsyncWidgetBuilder asyncWidgetBuilder;

  final bool sliver;
  const AppBuildFuture(
      {Key? key,
      this.futureBuilderFuture,
      this.sliver = false,
      required this.asyncWidgetBuilder})
      : super(key: key);

  @override
  _AppBuildFutureState createState() => _AppBuildFutureState();
}

class _AppBuildFutureState extends State<AppBuildFuture> {
  var _tag;
  var _futureBuilderFuture;
  final Logger logger  = Logger();

  @override
  void initState() {
    _tag = this.widget.runtimeType.toString();
    _futureBuilderFuture = this.widget.futureBuilderFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: _buildFuture,
      // initialData: ,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    logger.v("_buildFuture:" + snapshot.connectionState.toString(),  _tag);
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        logger.v("还没有开始网络请求",  _tag);
        return BaseEmptyPage(
          onPress: _futureBuilderFuture,
          sliver: this.widget.sliver,
        );
      case ConnectionState.active:
        logger.v("active",  _tag);
        return BaseEmptyPage(
          sliver: this.widget.sliver,
          onPress: _futureBuilderFuture,
        );
      case ConnectionState.waiting:
        logger.v("waiting", _tag);
        return AppLoadingWidget(
          sliver: this.widget.sliver,
        );
      case ConnectionState.done:
        logger.v("done", _tag);
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
