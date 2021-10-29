import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileManager with ChangeNotifier {
  List<PlatformFile> filesData = [];

  final _filePicker = FilePicker.platform;

  Future<void> selectFiles() async {
    final result = await _filePicker.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      filesData = result.files;
      notifyListeners();
    }
  }

  void removeFiles() {
    filesData = [];
    _filePicker.clearTemporaryFiles();
    notifyListeners();
  }

  int removeFile(PlatformFile fileData) {
    final index = filesData.indexOf(fileData);
    filesData.remove(fileData);
    if (filesData.isEmpty) {
      notifyListeners();
      _filePicker.clearTemporaryFiles();
    }
    return index;
  }

  void addFile(int index, PlatformFile fileData) {
    filesData.insert(index, fileData);
    notifyListeners();
  }
}
