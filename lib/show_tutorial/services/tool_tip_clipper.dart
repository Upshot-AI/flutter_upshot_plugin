import 'package:flutter/material.dart';

class ToolTipClipper extends CustomClipper<Path> {
  final bool isUp;
  final Rect? rect;
  final bool canShow;
  ToolTipClipper({required this.isUp, this.rect, required this.canShow});

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
        ..lineTo(size.width, 40);
      if (!canShow) {
        path.quadraticBezierTo(size.width, 20, size.width - 20,
            20); // ToolTip topRight borderRadius
      }

      // Pointing arrow paths
      if (canShow) {
        if (rect!.bottomCenter.dx >= size.width) {
          path.lineTo(size.width, 5);
          path.lineTo(size.width - 15, 20);
        } else {
          path.quadraticBezierTo(size.width, 20, size.width - 20,
              20); // ToolTip topRight borderRadius
          if (rect!.bottomCenter.dx - 35 <= 0) {
            path.lineTo(rect!.bottomCenter.dx, 20);
            path.lineTo(rect!.bottomCenter.dx - 15, 0);
            // path.quadraticBezierTo(
            //     rect!.bottomCenter.dx - 30, 0, rect!.bottomCenter.dx - 25, 7);
          } else {
            path.lineTo(rect!.bottomCenter.dx - 5, 20);
            path.lineTo(rect!.bottomCenter.dx - 15, 7);
            path.quadraticBezierTo(
                rect!.bottomCenter.dx - 20, 0, rect!.bottomCenter.dx - 25, 7);
          }
        }
        if (rect!.bottomCenter.dx - 35 < 20) {
          // path.lineTo(20, 20);
          path.lineTo(0, 40);
        } else {
          path.lineTo(rect!.bottomCenter.dx - 35, 20);
        }
      }

      return path;
    } else {
      var path = Path()
        ..moveTo(20, 0)
        ..quadraticBezierTo(0, 0, 0, 20); // ToolTip topLeft borderRadius
      if (canShow && (rect!.topCenter.dx - 35 <= 0)) {
        path.lineTo(0, size.height);
      } else if (canShow && (rect!.topCenter.dx - 35 <= 10)) {
        if (rect!.topCenter.dx - 35 >= 5) {
          path.lineTo(0, size.height - 40);
        } else {
          path.lineTo(0, size.height - 20);
        }
        path.quadraticBezierTo(0, size.height - 20, rect!.topCenter.dx - 35,
            size.height - 20); // ToolTip bottomLeft borderRadius
      } else {
        path.lineTo(0, size.height - 40);
        path.quadraticBezierTo(0, size.height - 20, 20,
            size.height - 20); // ToolTip bottomLeft borderRadius
      }

      // Pointing arrow paths
      if (canShow) {
        path.lineTo(rect!.topCenter.dx - 35,
            size.height - 20); // This is the start point for arrow
        if (rect!.topCenter.dx - 35 <= 0) {
          path.lineTo(0, size.height);
          path.lineTo(rect!.topCenter.dx - 30, size.height);
        } else if (rect!.topCenter.dx >= size.width) {
          path.lineTo(size.width, size.height);
        } else {
          path.lineTo(rect!.topCenter.dx - 25, size.height - 7);

          path.quadraticBezierTo(rect!.topCenter.dx - 20, size.height,
              rect!.topCenter.dx - 15, size.height - 7);
        }
        path.lineTo(rect!.topCenter.dx - 5,
            size.height - 20); // This is the end points for arrow
      }

      ///////////////////////
      if (canShow && rect!.topCenter.dx >= size.width) {
        path.lineTo(size.width, size.height - 20);
      } else {
        path.lineTo(size.width - 20, size.height - 20);
      }

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
