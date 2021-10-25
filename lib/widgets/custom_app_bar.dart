import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.actions = const [],
  }) : super(key: key);

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.lightBlue,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
