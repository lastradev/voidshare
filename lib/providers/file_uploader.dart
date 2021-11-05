import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path_utils;
import 'package:path_provider/path_provider.dart';

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);
const String _serverUrl = '0x0.st';

class FileUploader with ChangeNotifier {
  int uploadPercentage = 0;
  bool _uploadAborted = false;

  Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    uploadPercentage = 0;
    _uploadAborted = false;

    if (platformFiles.length > 1) {
      final zipFile = await _compressFiles(platformFiles);
      final url = await _fileUploadMultipart(
        file: File(zipFile.path!),
        onUploadProgress: (sentBytes, totalBytes) =>
            _updateUploadPercentage(sentBytes, totalBytes),
      );
      return url;
    }

    final url = await _fileUploadMultipart(
      file: File(platformFiles.first.path!),
      onUploadProgress: (sentBytes, totalBytes) =>
          _updateUploadPercentage(sentBytes, totalBytes),
    );
    return url;
  }

  Future<PlatformFile> _compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    final receivePort = ReceivePort();
    final compressorIsolateParams = _CompressorIsolateParams(
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

  Future<PlatformFile> _toPlatformFile(File file) async {
    return PlatformFile(
      path: file.path,
      name: path_utils.basename(file.path),
      size: await file.length(),
      readStream: file.openRead(),
    );
  }

  // based on salk52's function
  // https://github.com/salk52/Flutter-File-Upload-Download/blob/master/upload_download_app/lib/services/file_service.dart
  Future<String> _fileUploadMultipart({
    required File file,
    required OnUploadProgressCallback onUploadProgress,
  }) async {
    final httpClient = HttpClient();
    final uri = Uri.https(_serverUrl, '/');
    final request = await httpClient.postUrl(uri);

    int byteCount = 0;

    final multipartFile = await http.MultipartFile.fromPath('file', file.path);
    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.files.add(multipartFile);
    final msStream = multipartRequest.finalize();
    final totalByteLength = multipartRequest.contentLength;
    request.contentLength = totalByteLength;

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      multipartRequest.headers[HttpHeaders.contentTypeHeader]!,
    );

    Stream<List<int>> uploadStream = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (_uploadAborted) {
            request.abort();
            return;
          }

          sink.add(data);
          byteCount += data.length;
          onUploadProgress(byteCount, totalByteLength);
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    await request.addStream(uploadStream);
    final httpResponse = await request.close();
    final statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw const HttpException(
        'Error uploading file, please try again',
      );
    } else {
      return await _transformAndJoinHttpResponse(httpResponse);
    }
  }

  void abortUpload() {
    _uploadAborted = true;
  }

  Future<String> _transformAndJoinHttpResponse(
    HttpClientResponse httpResponse,
  ) async {
    return await httpResponse.transform(const Utf8Decoder()).join();
  }

  void _updateUploadPercentage(sentBytes, totalBytes) {
    uploadPercentage = (sentBytes * 100 / totalBytes).floor();
    notifyListeners();
  }

  static Future<String> _getCachePath() async {
    Directory cacheDir = await getTemporaryDirectory();
    return cacheDir.path;
  }

  static void _compressInIsolate(_CompressorIsolateParams params) async {
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

/// sends a message on a port, receives the response,
/// and returns the message
Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

/// Arguments passed to isolate for file compression
class _CompressorIsolateParams {
  _CompressorIsolateParams({
    required this.sendPort,
    required this.platformFiles,
    required this.cachePath,
  });

  SendPort sendPort;
  List<PlatformFile> platformFiles;
  String cachePath;
}
