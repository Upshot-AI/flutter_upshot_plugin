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

bool isTextScalerSupported() {
  try {
    TextPainter(
      text: const TextSpan(text: 'test'),
      textScaler: TextScaler.linear(1.0),
    );
    return true;
  } catch (_) {
    return false;
  }
}

TextPainter createTextPainter({
  required InlineSpan text,
  required TextAlign textAlign,
  required TextDirection textDirection,
  required double scale,
  int? maxLines,
  Locale? locale,
  StrutStyle? strutStyle,
}) {
  final bool supportsTextScaler = isTextScalerSupported();

  return supportsTextScaler
      ? TextPainter(
          text: text,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: TextScaler.linear(scale),
          maxLines: maxLines,
          locale: locale,
          strutStyle: strutStyle,
        )
      : TextPainter(
          text: text,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: scale,
          maxLines: maxLines,
          locale: locale,
          strutStyle: strutStyle,
        );
}

double getUserTextScaleFactor(BuildContext context, double baseFontSize) {
  try {
    return MediaQuery.of(context).textScaler.scale(baseFontSize);
  } catch (_) {
    return baseFontSize * MediaQuery.textScaleFactorOf(context);
  }
}
