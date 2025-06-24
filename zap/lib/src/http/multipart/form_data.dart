import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../definitions.dart';
import '../request/request.dart';
import '../utils/http_content_type.dart';
import '../utils/http_headers.dart';
import '../utils/utils.dart';
import 'multipart_file.dart';

/// {@template form_data}
/// A class to build a form data for a request
/// 
/// Args:
///   map: The map of the form data
/// 
/// Example:
/// ```dart
/// final formData = FormData({
///   'name': 'John Doe',
///   'age': 30,
///   'file': MultipartFile.fromFile('path/to/file'),
/// });
/// ```
/// 
/// {@endtemplate}
class FormData {
  /// {@macro form_data}
  /// 
  /// This class is used to build a form data for a request
  /// 
  /// Args:
  ///   map: The map of the form data
  ///   applyKeyToFile: Whether to apply the key to the file
  FormData(Map<String, dynamic> map, {
    bool applyKeyToFile = true,
  }) : boundary = _getBoundary() {
    map.forEach((key, value) {
      if (value == null) return;
      if (value is MultipartFile) {
        files.add(MapEntry(key, value));
      } else if (value is List<MultipartFile>) {
        if(applyKeyToFile) {
          files.addAll(value.map((e) => MapEntry(key, e)));
        } else {
          multipleFiles.add(MapEntry(key, value));
        }
      } else if (value is List) {
        fields.addAll(value.map((e) => MapEntry(key, e.toString())));
      } else {
        fields.add(MapEntry(key, value.toString()));
      }
    });
  }

  static const int _maxBoundaryLength = 70;

  static String _getBoundary() {
    final newRandom = Random();
    var list = BodyBytes.generate(_maxBoundaryLength - GET_BOUNDARY.length,
        (_) => boundaryCharacters[newRandom.nextInt(boundaryCharacters.length)],
        growable: false
    );
    return '$GET_BOUNDARY${String.fromCharCodes(list)}';
  }

  /// The boundary string used to separate different parts of the form data.
  final String boundary;

  /// The form fields to send for this request.
  final fields = <MapEntry<String, String>>[];

  /// The files to send for this request
  final files = <MapEntry<String, MultipartFile>>[];

  /// The multiple files to send for this request
  final multipleFiles = <MapEntry<String, List<MultipartFile>>>[];

  /// Returns the header string for a field. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fieldHeader(String name, String value) {
    var header = '${HttpHeaders.CONTENT_DISPOSITION}: ${HttpContentType.FORM_DATA}; name="${browserEncode(name)}"';
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
        '${HttpHeaders.CONTENT_TYPE}: ${HttpContentType.TEXT_PLAIN}; ${HttpContentType.CHARSET_UTF_8}\r\n'
        '${HttpHeaders.CONTENT_TRANSFER_ENCODING}: ${HttpContentType.BINARY}';
    }
    return '$header\r\n\r\n';
  }

  /// Returns the header string for a file. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fileHeader(MapEntry<String, MultipartFile> file) {
    var header = '${HttpHeaders.CONTENT_DISPOSITION}: ${HttpContentType.FORM_DATA}; name="${browserEncode(file.key)}"';
    header = '$header; filename="${browserEncode(file.value.filename)}"';
    header = '$header\r\n'
      '${HttpHeaders.CONTENT_TYPE}: ${file.value.contentType}';
    return '$header\r\n\r\n';
  }

  /// The length of the request body from this [FormData]
  int get length {
    var length = 0;

    for (final item in fields) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fieldHeader(item.key, item.value)).length +
          utf8.encode(item.value).length +
          '\r\n'.length;
    }

    for (var file in files) {
      length += '--'.length +
          _maxBoundaryLength +
          '\r\n'.length +
          utf8.encode(_fileHeader(file)).length +
          file.value.length! +
          '\r\n'.length;
    }

    for (var file in multipleFiles) {
      for (var f in file.value) {
        length += '--'.length +
            _maxBoundaryLength +
            '\r\n'.length +
            utf8.encode(_fileHeader(MapEntry(file.key, f))).length +
            f.length! +
            '\r\n'.length;
      }
    }

    return length + '--'.length + _maxBoundaryLength + '--\r\n'.length;
  }

  /// Returns the request body as a list of bytes
  Future<BodyBytes> toBytes() {
    return BodyByteStreamStream(_encode()).toBytes();
  }

  /// Returns the request body as a stream of bytes
  BodyByteStream _encode() async* {
    const line = [13, 10];
    final separator = utf8.encode('--$boundary\r\n');
    final close = utf8.encode('--$boundary--\r\n');

    for (var field in fields) {
      yield separator;
      yield utf8.encode(_fieldHeader(field.key, field.value));
      yield utf8.encode(field.value);
      yield line;
    }

    for (final file in files) {
      yield separator;
      yield utf8.encode(_fileHeader(file));
      yield* file.value.stream!;
      yield line;
    }

    for (var file in multipleFiles) {
      for (var f in file.value) {
        yield separator;
        yield utf8.encode(_fileHeader(MapEntry(file.key, f)));
        yield* f.stream!;
        yield line;
      }
    }
    yield close;
  }
}