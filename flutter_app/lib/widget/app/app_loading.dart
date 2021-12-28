import 'package:flutter/material.dart';

class AppLoadingWidget extends StatefulWidget {
  final bool sliver;

  const AppLoadingWidget({Key? key, this.sliver = false}) : super(key: key);

  @override
  _AppLoadingWidgetState createState() => _AppLoadingWidgetState();
}

class _AppLoadingWidgetState extends State<AppLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.sliver
        ? const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
