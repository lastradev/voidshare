import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/file_manager.dart';
import '../providers/file_uploader.dart';
import '../screens/error_screen.dart';
import '../screens/uploaded_screen.dart';
import '../screens/uploading_screen.dart';
import '../widgets/custom_snack_bars.dart';

bool isUploading = false;

/// Upload loop triggers when upload button is pressed.
void beginUpload(BuildContext context) async {
  final fileManager = Provider.of<FileManager>(context, listen: false);
  final fileUploader = Provider.of<FileUploader>(context, listen: false);

  if (isUploading) return;

  if (fileManager.files.isExcedingMaxSize) {
    CustomSnackBars.showCustomSnackBar(
      context,
      'Files total size must be under 512 MB.',
      action: SnackBarAction(
        label: 'MORE INFO',
        onPressed: () => launch('https://voidshare.xyz/'),
      ),
    );
    return;
  }

  isUploading = true;

  /// Keep retrying until success or abort.
  while (true) {
    try {
      Navigator.of(context).pushNamed(UploadingScreen.routeName);

      final url = await fileUploader.uploadFiles(fileManager.files);

      Navigator.of(context).pushReplacementNamed(
        UploadedScreen.routeName,
        arguments: url.trim(),
      );

      fileManager.removeFiles();

      break;

      /// Catch abort operation.
    } on HttpException {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).clearSnackBars();

      CustomSnackBars.showCustomSnackBar(context, 'Upload canceled.');

      break;

      /// Connection error.
    } on SocketException {
      /// Avoids retry if abort.
      if (fileUploader.isUploadAborted) {
        Navigator.of(context).pop();
        break;
      }

      final retry = await Navigator.of(context).pushReplacementNamed(
        ErrorScreen.routeName,
      );

      if (retry == null) break;

      /// Cache error.
      ///
      /// This could happen if user clear files just before uploading.
    } on FileSystemException {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).clearSnackBars();

      CustomSnackBars.showCustomSnackBar(
        context,
        'Could not retrieve file(s).',
      );

      break;
    }
  }

  isUploading = false;
}
