import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_utils;
import 'package:path_provider/path_provider.dart';

import 'isolate_helpers.dart';

class FileCompressor {
  Future<PlatformFile> compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    final receivePort = ReceivePort();
    final compressorIsolateParams = CompressorIsolateParams(
      sendPort: receivePort.sendPort,
      platformFiles: platformFiles,
      cachePath: await _getCachePath(),
    );

    // Compress files in a separate isolate
    await Isolate.spawn(_compressInIsolate, compressorIsolateParams);

    final sendPort = await receivePort.first;
    final zipPath = await sendReceive(sendPort, 'zipPath');

    final zipPlatformFile = await _toPlatformFile(File(zipPath));
    return zipPlatformFile;
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
    // Open the ReceivePort for incoming messages.
    final port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    params.sendPort.send(port.sendPort);

    final encoder = ZipFileEncoder();
    encoder.create('${params.cachePath}/out.zip');

    for (var file in params.platformFiles) {
      encoder.addFile(File(file.path!));
    }

    final zipPath = encoder.zip_path;
    encoder.close();

    await for (var msg in port) {
      SendPort replyTo = msg[1];
      replyTo.send(zipPath);
    }
  }
}
