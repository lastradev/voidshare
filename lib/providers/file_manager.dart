import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

/// Helper for file selecting management.
///
/// Contains files, and has methods to add and remove them.
class FileManager with ChangeNotifier {
  List<PlatformFile> files = [];

  final _filePicker = FilePicker.platform;
  bool isLoadingFiles = false;

  /// Loads files from device into [files] and notify when loading.
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
      files.addAll(result.files);
    }
    notifyListeners();
  }

  /// Removes all selected files from [files] and from cache.
  void removeFiles() {
    files = [];
    if (!isLoadingFiles) {
      _filePicker.clearTemporaryFiles();
    }
    notifyListeners();
  }

  /// Removes selected file, returns its index from the [files] list.
  int removeFile(PlatformFile file) {
    final index = files.indexOf(file);
    files.remove(file);
    notifyListeners();
    if (files.isEmpty && !isLoadingFiles) {
      _filePicker.clearTemporaryFiles();
    }
    return index;
  }

  /// Inserts file into [files] and notifies listeners.
  void addFile(int index, PlatformFile file) {
    files.insert(index, file);
    notifyListeners();
  }
}

extension FileTypeChecker on PlatformFile {
  bool get isImage {
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
    final mimeType = lookupMimeType(path!);
    return imageMimeTypes.contains(mimeType);
  }
}

extension FilesSizeInfo on List<PlatformFile> {
  /// The max file size for 0x0.st
  static const _maxFilesSize = 536870912;

  /// The total size of files in bytes.
  int get totalSize {
    var size = 0;
    for (var file in this) {
      size += file.size;
    }
    return size;
  }

  bool get isExcedingMaxSize {
    return totalSize > _maxFilesSize;
  }
}
