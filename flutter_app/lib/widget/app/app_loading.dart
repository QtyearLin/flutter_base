import 'package:flutter/material.dart';

class AppLoadingWidget extends StatefulWidget {
  final bool sliver;

  const AppLoadingWidget({Key key, this.sliver= false}) : super(key: key);

  @override
  _AppLoadingWidgetState createState() => _AppLoadingWidgetState();
}

class _AppLoadingWidgetState extends State<AppLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return this.widget.sliver
        ? SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
