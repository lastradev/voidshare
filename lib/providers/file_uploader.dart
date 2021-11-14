import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../helpers/file_compressor.dart';
import '../models/history_entry.dart';

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);
const String _serverUrl = '0x0.st';
final _fileCompressor = FileCompressor();
final _historyBox = Hive.box<HistoryEntry>('history');

class FileUploader with ChangeNotifier {
  int uploadPercentage = 0;
  bool uploadAborted = false;

  Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    // Reset values when function invoke
    uploadPercentage = 0;
    uploadAborted = false;
    PlatformFile platformFile;
    bool compressFile = platformFiles.length > 1;

    if (compressFile) {
      platformFile = await _fileCompressor.compressFiles(platformFiles);
    } else {
      platformFile = platformFiles.first;
    }

    final url = await _fileUploadMultipart(
      file: File(platformFile.path!),
      onUploadProgress: (sentBytes, totalBytes) =>
          _updateUploadPercentage(sentBytes, totalBytes),
    );

    _historyBox.add(
      HistoryEntry(
        // Url substring gets the name of the zip file https://0x0.st/XXXXX
        name: compressFile ? url.substring(15).trim() : platformFile.name,
        size: platformFile.size,
        url: url,
        uploadDate: DateTime.now(),
      ),
    );

    return url;
  }

  void abortUpload() {
    _fileCompressor.abortCompression();
    uploadAborted = true;
    notifyListeners();
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
          if (uploadAborted) {
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
