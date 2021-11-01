import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(
    BuildContext context,
    String title, {
    SnackBarAction? action,
    Duration? duration,
    bool noAction = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(seconds: 2),
        elevation: 6,
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        content: Text(title),
        action: noAction
            ? null
            : action ??
                SnackBarAction(
                  label: 'Ok',
                  onPressed: () {},
                ),
      ),
    );
  }
}
