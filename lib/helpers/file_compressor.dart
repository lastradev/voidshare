import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path_utils;
import 'package:path_provider/path_provider.dart';

import 'isolate_helpers.dart';

/// An object that holds methods to compress into zip files and
/// abort the compress operation in an [Isolate].
class FileCompressor {
  late ReceivePort _receivePort;
  late SendPort _sendPort;

  /// Begins compression and expect a zip data file in return.
  Future<PlatformFile> compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    _receivePort = ReceivePort();

    final compressorIsolateParams = CompressorIsolateParams(
      sendPort: _receivePort.sendPort,
      platformFiles: platformFiles,
      cachePath: await _getCachePath(),
    );

    /// Compress files in a separate isolate.
    await Isolate.spawn(_compressInIsolate, compressorIsolateParams);

    /// Starts communication between isolates.
    _sendPort = await _receivePort.first;

    final zipPath = await sendReceive(_sendPort, 'zipPath');

    final zipPlatformFile = await _toPlatformFile(File(zipPath));
    return zipPlatformFile;
  }

  /// Sends a message to the compressor isolate to stop compressing.
  void abortCompression() {
    // Abort button pressed.
    sendReceive(_sendPort, 'abort');
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
    );
  }

  /// Runs the compression computation inside the [Isolate].
  ///
  /// It should send a String through a [SendPort] with the zip path whether
  /// the compression was successful or not.
  static void _compressInIsolate(CompressorIsolateParams params) async {
    final zipPath = '${params.cachePath}/out.zip';
    /// Open the ReceivePort for incoming messages.
    final port = ReceivePort();
    bool abort = false;
    late SendPort zipPathPort;

    /// Notify any other isolates what port this isolate listens to.
    params.sendPort.send(port.sendPort);

    // Create zip file.
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    port.listen((msg) {
      /// Listen for an abort message to stop compressing.
      if (msg[0] == 'abort') {
        abort = true;
      }
      /// Listen for the message requesting the zipPath.
      ///
      /// The zipPath should be sent after the compression finishes,
      /// that's why it is being assigned to a late variable.
      if (msg[0] == 'zipPath') {
        zipPathPort = msg[1];
      }
    });

    for (var file in params.platformFiles) {
      if (abort) {
        break;
      }
      /// Future allows the port to listen while compressing.
      // Note: look for a better way to do this...
      await Future(() {
        encoder.addFile(File(file.path!));
      });
    }

    encoder.close();
    zipPathPort.send(zipPath);
  }
}
