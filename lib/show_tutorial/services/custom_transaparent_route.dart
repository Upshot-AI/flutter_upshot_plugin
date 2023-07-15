import 'package:flutter/material.dart';

class TransparentRoute extends PageRoute {
  final WidgetBuilder widgetBuilder;

  TransparentRoute({required this.widgetBuilder});

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return widgetBuilder(context);
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1);
}
