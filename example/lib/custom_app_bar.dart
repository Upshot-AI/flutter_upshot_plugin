import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  @override
  final Widget child;
  const CustomAppBar({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
