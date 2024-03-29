import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    this.color,
    this.fabLocation,
    this.shape,
    required this.rowContents,
  });

  final Color? color;
  final FloatingActionButtonLocation? fabLocation;
  final NotchedShape? shape;
  final List<Widget> rowContents;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      child: Row(children: rowContents),
      shape: shape,
    );
  }
}
