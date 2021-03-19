import 'package:flutter/material.dart';

class BaseEmptyPage extends StatelessWidget {
  final message;
  final VoidCallback onPress;
  final bool sliver;

  BaseEmptyPage({
    Key key,
    this.message = "数据为空,点击刷新试试",
    this.onPress,
    this.sliver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;

    return sliver
        ? SliverToBoxAdapter(
            child: Center(
                child: Container(
            alignment: FractionalOffset.center,
            child: GestureDetector(
              onTap: onPress,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.style, color: color, size: 120.0),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          )))
        : Center(
            child: Container(
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onTap: onPress,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.style, color: color, size: 120.0),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
