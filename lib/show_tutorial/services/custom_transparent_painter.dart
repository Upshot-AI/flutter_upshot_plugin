import 'dart:ui';
import 'package:flutter/material.dart';
import 'widget_data_class.dart';

class TransaprentCustomPainter extends CustomPainter {
  final GlobalKey toolTipGlobalKey;
  final WidgetDataClass? widgetDataClass;
  final double opacity = 0.5;
  final bool canShow;

  TransaprentCustomPainter(
      {required this.toolTipGlobalKey,
      required this.widgetDataClass,
      required this.canShow});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canShow && widgetDataClass != null
        ? canvas.clipRect(
            Rect.fromLTWH(widgetDataClass!.xAxis, widgetDataClass!.yAxis,
                widgetDataClass!.rect.width, widgetDataClass!.rect.height),
            doAntiAlias: true,
            clipOp: ClipOp.difference)
        : null;
    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
