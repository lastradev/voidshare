import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUploader {
  static Future<String> uploadFiles(List<PlatformFile> platformFiles) async {
    if (platformFiles.length > 1) {
      final zipFile = await _compressFiles(platformFiles);
      final url = await _uploadFile(zipFile);
      return url;
    }
    final url = await _uploadFile(platformFiles.first);
    return url;
  }

  static Future<PlatformFile> _compressFiles(
    List<PlatformFile> platformFiles,
  ) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final encoder = ZipFileEncoder();

    encoder.create('$tempPath/out.zip');

    for (var file in platformFiles) {
      encoder.addFile(File(file.path!));
    }

    final zipPath = encoder.zip_path;
    encoder.close();

    final zipPlatformFile = _toPlatformFile(File(zipPath));
    return zipPlatformFile;
  }

  static Future<PlatformFile> _toPlatformFile(File file) async {
    return PlatformFile(
      path: file.path,
      name: p.basename(file.path),
      size: await file.length(),
      readStream: file.openRead(),
    );
  }

  static Future<String> _uploadFile(PlatformFile file) async {
    final uri = Uri.https('0x0.st', '/');
    final stream = http.ByteStream(file.readStream!);
    final request = http.MultipartRequest('POST', uri);
    final mimeType = lookupMimeType(file.path ?? '');

    final multiPartFile = http.MultipartFile(
      'file',
      stream,
      file.size,
      filename: file.name,
      contentType: mimeType == null ? null : MediaType.parse(mimeType),
    );

    request.files.add(multiPartFile);

    final httpClient = http.Client();
    final response = await httpClient.send(request);

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final body = await response.stream.transform(const Utf8Decoder()).join();
    return body;
  }
}
