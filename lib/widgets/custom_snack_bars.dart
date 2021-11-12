import 'package:flutter/material.dart';

class CustomSnackBars {
  static void showFileRemoveSnackBar(
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

  static void showErrorSnackBar(
    BuildContext context,
    String title,
  ) {
    _showNotificationSnackBar(
      context,
      Icon(Icons.cancel_outlined, color: Colors.red.shade500),
      title,
    );
  }

  static void showClipboardSnackBar(
    BuildContext context,
    String title,
  ) {
    _showNotificationSnackBar(
      context,
      Icon(Icons.check, color: Theme.of(context).primaryColor),
      title,
    );
  }

  static void _showNotificationSnackBar(
    BuildContext context,
    Icon icon,
    String title,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        width: 250,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.all(15),
      ),
    );
  }
}
