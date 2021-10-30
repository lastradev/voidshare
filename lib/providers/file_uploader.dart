import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FileUploader {
  static void uploadFile(PlatformFile file) async {
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

    print(await response.stream.transform(const Utf8Decoder()).join());
  }
}
