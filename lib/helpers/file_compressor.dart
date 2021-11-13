/// [FileCompressor] class uses an isolate to compress multiple files without
/// freezing the UI. It depends on archive io package.
///
/// call [compressFiles] to begin the compression and expect a zip data file
/// in return.
///
/// Compression can be stopped with [abortCompression] function.

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_utils;
import 'package:path_provider/path_provider.dart';

import 'isolate_helpers.dart';

class FileCompressor {
  late ReceivePort receivePort;
  late SendPort sendPort;

  Future<PlatformFile> compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    _initRecievePort();

    final compressorIsolateParams = CompressorIsolateParams(
      sendPort: receivePort.sendPort,
      platformFiles: platformFiles,
      cachePath: await _getCachePath(),
    );

    // Compress files in a separate isolate
    await Isolate.spawn(_compressInIsolate, compressorIsolateParams);

    await _initSendPort();

    final zipPath = await sendReceive(sendPort, 'zipPath');

    final zipPlatformFile = await _toPlatformFile(File(zipPath));
    return zipPlatformFile;
  }

  void abortCompression() {
    // Abort button pressed
    sendReceive(sendPort, 'abort');
  }

  void _initRecievePort() {
    receivePort = ReceivePort();
  }

  Future<void> _initSendPort() async {
    sendPort = await receivePort.first;
  }

  static Future<String> _getCachePath() async {
    Directory cacheDir = await getTemporaryDirectory();
    return cacheDir.path;
  }

  Future<PlatformFile> _toPlatformFile(File file) async {
    return PlatformFile(
      path: file.path,
      name: path_utils.basename(file.path),
      size: await file.length(),
      readStream: file.openRead(),
    );
  }

  static void _compressInIsolate(CompressorIsolateParams params) async {
    final zipPath = '${params.cachePath}/out.zip';
    // Open the ReceivePort for incoming messages.
    final port = ReceivePort();
    // Notify any other isolates what port this isolate listens to.
    params.sendPort.send(port.sendPort);

    bool abort = false;
    late SendPort zipPathPort;

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    // Listen for an abort message to stop compressing
    port.listen((msg) {
      if (msg[0] == 'abort') {
        abort = true;
      }
      if (msg[0] == 'zipPath') {
        zipPathPort = msg[1];
      }
    });

    for (var file in params.platformFiles) {
      if (abort) {
        break;
      }
      await Future(() {
        encoder.addFile(File(file.path!));
      });
    }

    encoder.close();
    zipPathPort.send(zipPath);
  }
}
