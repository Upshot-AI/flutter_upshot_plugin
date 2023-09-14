import 'package:flutter/cupertino.dart';

class WidgetDataClass {
  double xAxis;
  double yAxis;
  final Rect rect;
  final Element child;
  double get maxYAxis => yAxis + rect.height;
  double get maxXAxis => xAxis + rect.width;

  WidgetDataClass(
      {required this.xAxis,
      required this.yAxis,
      required this.rect,
      required this.child});
}
