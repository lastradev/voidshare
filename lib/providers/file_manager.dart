import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

/// Helper for file selecting management.
///
/// Contains files, and has methods to add and remove them.
class FileManager with ChangeNotifier {
  List<PlatformFile> filesData = [];

  final _filePicker = FilePicker.platform;
  bool isLoadingFiles = false;

  /// Loads files from device into [filesData] and notify when loading.
  Future<void> selectFiles() async {
    final result = await _filePicker.pickFiles(
      allowMultiple: true,
      onFileLoading: (status) {
        if (status == FilePickerStatus.picking) {
          isLoadingFiles = true;
          notifyListeners();
        }
      },
    );

    isLoadingFiles = false;
    if (result != null) {
      filesData.addAll(result.files);
    }
    notifyListeners();
  }

  /// Removes all selected files from [filesData] and from cache.
  void removeFiles() {
    filesData = [];
    if (!isLoadingFiles) {
      _filePicker.clearTemporaryFiles();
    }
    notifyListeners();
  }

  /// Removes selected file, returns its index from the [filesData] list.
  int removeFile(PlatformFile fileData) {
    final index = filesData.indexOf(fileData);
    filesData.remove(fileData);
    notifyListeners();
    if (filesData.isEmpty && !isLoadingFiles) {
      _filePicker.clearTemporaryFiles();
    }
    return index;
  }

  /// Inserts file into [filesData] and notifies listeners.
  void addFile(int index, PlatformFile fileData) {
    filesData.insert(index, fileData);
    notifyListeners();
  }

  /// The total size of selected files in bytes.
  int get totalSize {
    var size = 0;
    for (var fileData in filesData) {
      size += fileData.size;
    }
    return size;
  }

  /// Checks if the file is a valid image for Flutter's [Image].
  bool isImage(PlatformFile fileData) {
    final imageMimeTypes = [
      'image/png',
      'image/jpeg',
      'image/gif',
      'image/x-icon',
      'image/bmp',
      'image/wbmp',
      'image/vnd.wap.wbmp',
      'image/webp',
    ];
    final mimeType = lookupMimeType(fileData.path!);
    return imageMimeTypes.contains(mimeType);
  }
}
