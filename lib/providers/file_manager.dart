import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class FileManager with ChangeNotifier {
  List<PlatformFile> filesData = [];

  final _filePicker = FilePicker.platform;
  bool isLoadingFiles = false;

  Future<void> selectFiles() async {
    final result = await _filePicker.pickFiles(
      allowMultiple: true,
      withReadStream: true,
      onFileLoading: (status) {
        if (status == FilePickerStatus.picking) {
          isLoadingFiles = true;
          notifyListeners();
        }
      },
    );

    isLoadingFiles = false;
    if (result != null) {
      filesData = result.files;
    }
    notifyListeners();
  }

  void removeFiles() {
    filesData = [];
    _filePicker.clearTemporaryFiles();
    notifyListeners();
  }

  int removeFile(PlatformFile fileData) {
    final index = filesData.indexOf(fileData);
    filesData.remove(fileData);
    notifyListeners();
    if (filesData.isEmpty) {
      _filePicker.clearTemporaryFiles();
    }
    return index;
  }

  void addFile(int index, PlatformFile fileData) {
    filesData.insert(index, fileData);
    notifyListeners();
  }

  int get totalSize {
    var size = 0;
    for (var fileData in filesData) {
      size += fileData.size;
    }
    return size;
  }

  bool isImage(PlatformFile fileData) {
    final mimeType = lookupMimeType(fileData.path!);
    return mimeType!.startsWith('image/');
  }
}
