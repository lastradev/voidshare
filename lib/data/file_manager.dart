import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileManager {
  List<File>? files;
  List<PlatformFile>? filesData;

  final _filePicker = FilePicker.platform;

  Future<void> selectFiles() async {
    final result = await _filePicker.pickFiles(
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
    _filePicker.clearTemporaryFiles();
  }
}
