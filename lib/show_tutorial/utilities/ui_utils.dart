import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Color? getColor(String? hexColor, double opacity) {
  if ((hexColor?.isNotEmpty ?? false) && hexColor != "") {
    hexColor = hexColor!.replaceFirst('#', '');

    int alpha = (opacity * 255).round();
    String alphaHex = alpha.toRadixString(16).padLeft(2, '0').toUpperCase();
    if (hexColor.length == 6) {
      return Color(
          int.parse('0x$alphaHex$hexColor')); // Full ARGB (opacity + RGB)
    }
  }
  return null;
}

double getDevicePixelRatio(BuildContext context) {
  try {
    return View.of(context).devicePixelRatio;
  } catch (_) {
    return WidgetsBinding.instance.window.devicePixelRatio;
  }
}

// double getUserTextScaleFactor(BuildContext context) {
//   try {
//     TextScaler a = MediaQuery.textScalerOf(context);
//     return a.scale(fontSize)
//   } catch (_) {
//    return MediaQuery.textScaleFactorOf(context);
//   }
// }
