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
        // ..color = Colors.red
        ..color = ShowTutorialsModel.instance.getColor(color) ?? Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                (widgetDataClass!.xAxis <= 0.0)
                    ? widgetDataClass!.xAxis + strokeWidth
                    : widgetDataClass!.xAxis - strokeWidth,
                (widgetDataClass!.yAxis <= 0.0)
                    ? widgetDataClass!.yAxis + strokeWidth
                    : widgetDataClass!.yAxis - strokeWidth,
                (widgetDataClass!.xAxis + widgetDataClass!.rect.width >=
                        ShowTutorialsModel.instance.screenWidth)
                    ? widgetDataClass!.rect.width - (2 * strokeWidth)
                    : widgetDataClass!.rect.width + 2 * strokeWidth,
                (widgetDataClass!.yAxis + widgetDataClass!.rect.height >=
                        ShowTutorialsModel.instance.screenHeight)
                    ? widgetDataClass!.rect.height
                    : widgetDataClass!.rect.height,
              ),
              Radius.zero),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
