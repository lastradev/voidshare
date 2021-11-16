import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/formatters.dart';
import '../providers/file_manager.dart';

/// Widget containing selected files total size and clear files action.
class FileClearer extends StatelessWidget {
  const FileClearer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);

    return Visibility(
      visible: fileManager.files.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                'Selected files - ${Formatters.formatBytes(fileManager.files.totalSize, 2)}',
              ),
            ),
            TextButton(
              onPressed: () {
                // Avoids UNDO action after clearing cached image
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                fileManager.removeFiles();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}
