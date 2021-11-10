import 'dart:isolate';

import 'package:file_picker/file_picker.dart';

/// sends a message on a port, receives the response,
/// and returns the message
Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

/// Arguments passed to isolate for file compression
class CompressorIsolateParams {
  CompressorIsolateParams({
    required this.sendPort,
    required this.platformFiles,
    required this.cachePath,
  });

  SendPort sendPort;
  List<PlatformFile> platformFiles;
  String cachePath;
}
