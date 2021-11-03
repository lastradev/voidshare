import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

class FileUploader with ChangeNotifier {
  int uploadPercentage = 0;

  Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    if (platformFiles.length > 1) {
      final zipFile = await _compressFiles(platformFiles);
      final url = await _fileUploadMultipart(
        file: File(zipFile.path!),
        onUploadProgress: (sentBytes, totalBytes) {
          uploadPercentage = (sentBytes * 100 / totalBytes).floor();
          notifyListeners();
        },
      );
      return url;
    }

    final url = await _fileUploadMultipart(
      file: File(platformFiles.first.path!),
      onUploadProgress: (sentBytes, totalBytes) {
        uploadPercentage = (sentBytes * 100 / totalBytes).floor();
        notifyListeners();
      },
    );
    return url;
  }

  Future<PlatformFile> _compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final encoder = ZipFileEncoder();

    encoder.create('$tempPath/out.zip');

    for (var file in platformFiles) {
      await Future(() {
        encoder.addFile(File(file.path!));
      });
    }

    final zipPath = encoder.zip_path;
    encoder.close();

    final zipPlatformFile = await _toPlatformFile(File(zipPath));
    return zipPlatformFile;
  }

  Future<PlatformFile> _toPlatformFile(File file) async {
    return PlatformFile(
      path: file.path,
      name: p.basename(file.path),
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
    final uri = Uri.https('0x0.st', '/');

    final httpClient = HttpClient();

    final request = await httpClient.postUrl(uri);

    int byteCount = 0;

    var multipart = await http.MultipartFile.fromPath('file', file.path);

    var requestMultipart = http.MultipartRequest('POST', uri);

    requestMultipart.files.add(multipart);

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader]!,
    );

    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;

          onUploadProgress(byteCount, totalByteLength);
          // CALL STATUS CALLBACK;
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    var statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw Exception(
        'Error uploading file, Status code: ${httpResponse.statusCode}',
      );
    } else {
      return httpResponse.transform(const Utf8Decoder()).join();
    }
  }
}
