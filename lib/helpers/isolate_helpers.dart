/// Helpers for the [Isolate] in [FileCompressor].

import 'dart:isolate';

import 'package:file_picker/file_picker.dart';

/// Sends a message on a port and returns the response.
Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

/// Arguments passed to isolate for file compression.
///
/// Isolates can't have more than one parameter and also need to be static,
/// everything that is given must be in a single argument. Therefor, this
/// class acts as a wrapper for all the objects the Isolate needs.
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
