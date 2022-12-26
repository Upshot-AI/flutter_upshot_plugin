import 'package:flutter/material.dart';
import 'package:flutter_upshot_plugin/show_tutorial/services/widget_data_class.dart';

import '../show_tutorials_viewmodel.dart';

class CustomBorderPaint extends CustomPainter {
  final String? color;
  final WidgetDataClass? widgetDataClass;
  final bool canShow;
  final double strokeWidth = 1;

  const CustomBorderPaint(
      {required this.widgetDataClass, this.color, required this.canShow});
  @override
  void paint(Canvas canvas, Size size) {
    if (canShow && widgetDataClass != null) {
      final Paint paint = Paint()
        ..color = ShowTutorialsModel.instance.getColor(color) ?? Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  widgetDataClass!.xAxis - strokeWidth,
                  widgetDataClass!.yAxis - strokeWidth,
                  widgetDataClass!.rect.width + 2 * strokeWidth,
                  widgetDataClass!.rect.height + 2 * strokeWidth),
              Radius.zero),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
