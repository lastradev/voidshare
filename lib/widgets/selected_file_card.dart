import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/formatters.dart';
import '../providers/file_manager.dart';
import 'custom_snack_bar.dart';

class SelectedFileCard extends StatelessWidget {
  const SelectedFileCard({
    required this.fileData,
    Key? key,
  }) : super(key: key);

  final PlatformFile fileData;

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
        child: Card(
          elevation: 3,
          shadowColor: Colors.grey.shade50.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: fileManager.isImage(fileData)
                        ? FadeInImage(
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            image: FileImage(
                              File(fileData.path!),
                            ),
                            placeholder: const AssetImage(
                              'assets/images/file-icon.webp',
                            ),
                          )
                        : Container(
                            color: Colors.lightBlue.shade50,
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.file_copy_rounded,
                              size: 30,
                              color: Colors.lightBlue.shade300,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileData.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(Formatters.formatBytes(fileData.size, 1)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onDismissed: (_) {
        final index = fileManager.removeFile(fileData);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        CustomSnackBar.showSnackBar(
          context,
          'File removed',
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () => fileManager.addFile(index, fileData),
          ),
        );
      },
    );
  }
}
