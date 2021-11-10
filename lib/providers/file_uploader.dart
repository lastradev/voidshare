import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../helpers/file_compressor.dart';

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);
const String _serverUrl = '0x0.st';
final _fileCompressor = FileCompressor();

class FileUploader with ChangeNotifier {
  int uploadPercentage = 0;
  bool _uploadAborted = false;

  Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    uploadPercentage = 0;
    _uploadAborted = false;

    if (platformFiles.length > 1) {
      final zipFile = await _fileCompressor.compressFiles(platformFiles);
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
}
