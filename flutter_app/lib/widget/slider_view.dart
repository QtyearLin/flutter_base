import 'package:flutter/material.dart';
import 'package:flutter_module/style/app_theme.dart';

class SliderView extends StatefulWidget {
  const SliderView(
      {Key key,
      this.onChangedistValue,
      this.total = 100,
      this.distValue = 50,
      this.divisions = 100,
      this.showTitle = "",
      this.showUnit = ""})
      : super(key: key);

  final Function(double) onChangedistValue;
  final double distValue;
  final double total; //总成
  final String showTitle;
  final int divisions;
  final String showUnit; //默认单位

  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  double distValue = 50.0;
  double unit = 1;

  @override
  void initState() {
    distValue = widget.distValue;
    unit = (widget.total / 100);
    print("uit:$unit");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: distValue.round(),
                child: const SizedBox(),
              ),
              Container(
                width: 170,
                child: Text(
                  widget.showTitle +
                      (distValue * unit).toStringAsFixed(0) +
                      widget.showUnit,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 100 - distValue.round(),
                child: const SizedBox(),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: CustomThumbShape(),
            ),
            child: Slider(
              onChanged: (double value) {
                setState(() {
                  print("Slider:onChanged:$value");
                  distValue = value;
                });
                try {
                  widget.onChangedistValue(distValue);
                } catch (_) {}
              },
              min: 0,
              max: 100,
              activeColor: AppColors.primaryValue,
              inactiveColor: Colors.grey.withOpacity(0.4),
              divisions: widget.divisions,
              value: distValue,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 3.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    Size sizeWithOverflow,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double textScaleFactor,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(
              Offset(thumbCenter.dx + 12, thumbCenter.dy + 12),
              Offset(thumbCenter.dx - 12, thumbCenter.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation);
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 10, cPaint);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
