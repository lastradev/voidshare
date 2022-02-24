import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../helpers/file_compressor.dart';
import '../models/history_entry.dart';

typedef _OnUploadProgressCallback = void Function(
  int sentBytes,
  int totalBytes,
);
const String _serverUrl = 'voidshare.xyz';
final _fileCompressor = FileCompressor();
final _historyBox = Hive.box<HistoryEntry>('history');

/// Handles upload operations to the server
class FileUploader with ChangeNotifier {
  int uploadPercentage = 0;
  bool isUploadAborted = false;
  bool _isCompressOperation = false;

  /// Uploads file / files(as Zip) to the server.
  ///
  /// Files are compressed if there's more than one.
  /// If upload is successful, operation details will be stored in Hive database.
  ///
  /// Returns the file url.
  Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    /// Reset values when function invoke.
    uploadPercentage = 0;
    isUploadAborted = false;

    PlatformFile platformFile;
    _isCompressOperation = platformFiles.length > 1;

    if (_isCompressOperation) {
      platformFile = await _fileCompressor.compressFiles(platformFiles);
    } else {
      platformFile = platformFiles.first;
    }

    final url = await _fileUploadMultipart(
      file: File(platformFile.path!),
      onUploadProgress: (sentBytes, totalBytes) =>
          _updateUploadPercentage(sentBytes, totalBytes),
    );

    /// Store upload details in Hive database.
    _historyBox.add(
      HistoryEntry(
        /// Url substring gets the name of the zip file
        /// https://voidshare.xyz/file.zip would throw file.zip
        name: _isCompressOperation
            ? url.substring(url.lastIndexOf('/') + 1).trim()
            : platformFile.name,
        size: platformFile.size,
        url: url,
        uploadDate: DateTime.now(),
      ),
    );

    return url;
  }

  /// Stops the upload.
  ///
  /// Stops file compression.
  /// Notifies listeners to reflect abort operation on UI.
  void abortUpload() {
    if (_isCompressOperation) {
      _fileCompressor.abortCompression();
    }
    isUploadAborted = true;
    notifyListeners();
  }

  /// Starts an [http.MultipartRequest] to upload a file.
  ///
  /// based on salk52's function
  /// https://github.com/salk52/Flutter-File-Upload-Download/blob/master/upload_download_app/lib/services/file_service.dart
  ///
  /// Uploads and listens to byte stream for upload percentage.
  /// Returns the http response.
  Future<String> _fileUploadMultipart({
    required File file,
    required _OnUploadProgressCallback onUploadProgress,
  }) async {
    final httpClient = HttpClient();
    final uri = Uri.http(_serverUrl, '/');
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
          if (isUploadAborted) {
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
      throw HttpException(
        await _decodeHttpResponse(httpResponse),
      );
    } else {
      return await _decodeHttpResponse(httpResponse);
    }
  }

  /// Decodes a streamed http request response.
  Future<String> _decodeHttpResponse(
    HttpClientResponse httpResponse,
  ) async {
    return await httpResponse.transform(const Utf8Decoder()).join();
  }

  /// Updates file upload percentage on UI.
  void _updateUploadPercentage(sentBytes, totalBytes) {
    uploadPercentage = (sentBytes * 100 / totalBytes).floor();
    notifyListeners();
  }
}
