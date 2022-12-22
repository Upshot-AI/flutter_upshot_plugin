import 'package:flutter/material.dart';

class ToolTipClipper extends CustomClipper<Path> {
  final bool isUp;
  final Rect rect;
  final bool canShow;
  ToolTipClipper(
      {required this.isUp, required this.rect, required this.canShow});

  @override
  Path getClip(Size size) {
    if (isUp) {
      var path = Path()
        ..moveTo(20, 20)
        ..quadraticBezierTo(0, 20, 0, 40) // ToolTip topLeft borderRadius
        ..lineTo(0, size.height - 20)
        ..quadraticBezierTo(
            0, size.height, 20, size.height) // ToolTip bottomLeft borderRadius
        ..lineTo(size.width - 20, size.height)
        ..quadraticBezierTo(size.width, size.height, size.width,
            size.height - 20) // ToolTip bottomRight borderRadius
        ..lineTo(size.width, 40)
        ..quadraticBezierTo(size.width, 20, size.width - 20,
            20); // ToolTip topRight borderRadius

      // Pointing arrow paths
      if (canShow) {
        path.lineTo(rect.bottomCenter.dx - 5, 20);
        path.lineTo(rect.bottomCenter.dx - 15, 7);
        path.quadraticBezierTo(
            rect.bottomCenter.dx - 20, 0, rect.bottomCenter.dx - 25, 7);
      }

      path.lineTo(rect.bottomCenter.dx - 35, 20);
      return path;
    } else {
      var path = Path()
        ..moveTo(20, 0)
        ..quadraticBezierTo(0, 0, 0, 20) // ToolTip topLeft borderRadius
        ..lineTo(0, size.height - 40)
        ..quadraticBezierTo(0, size.height - 20, 20,
            size.height - 20); // ToolTip bottomLeft borderRadius
      // Pointing arrow paths
      if (canShow) {
        path.lineTo(rect.topCenter.dx - 35,
            size.height - 20); // This is the start point for arrow
        path.lineTo(rect.topCenter.dx - 25, size.height - 7);
        path.quadraticBezierTo(rect.topCenter.dx - 20, size.height,
            rect.topCenter.dx - 15, size.height - 7);
        path.lineTo(rect.topCenter.dx - 5,
            size.height - 20); // This is the end points for arrow
      }

      ///////////////////////
      path.lineTo(size.width - 20, size.height - 20);
      path.quadraticBezierTo(size.width, size.height - 20, size.width,
          size.height - 40); // ToolTip bottomRight borderRadius
      path.lineTo(size.width, 20);
      path.quadraticBezierTo(
          size.width, 0, size.width - 20, 0); // ToolTip topRight borderRadius
      return path;
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
