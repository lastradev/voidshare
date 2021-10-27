import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileSelector {
  List<File>? files;
  List<PlatformFile>? filesData;

  Future<void> selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      filesData = result.files;
    }
  }

  void removeFiles() {
    files = null;
    filesData = null;
  }
}
