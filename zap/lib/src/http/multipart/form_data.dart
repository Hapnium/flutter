import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../definitions.dart';
import '../request/request.dart';
import '../utils/utils.dart';
import 'multipart_file.dart';

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
class FormData {
  FormData(Map<String, dynamic> map) : boundary = _getBoundary() {
    map.forEach((key, value) {
      if (value == null) return;
      if (value is MultipartFile) {
        files.add(MapEntry(key, value));
      } else if (value is List<MultipartFile>) {
        files.addAll(value.map((e) => MapEntry(key, e)));
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

  /// Returns the header string for a field. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fieldHeader(String name, String value) {
    var header = 'content-disposition: form-data; name="${browserEncode(name)}"';
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
        'content-type: text/plain; charset=utf-8\r\n'
        'content-transfer-encoding: binary';
    }
    return '$header\r\n\r\n';
  }

  /// Returns the header string for a file. The return value is guaranteed to
  /// contain only ASCII characters.
  String _fileHeader(MapEntry<String, MultipartFile> file) {
    var header = 'content-disposition: form-data; name="${browserEncode(file.key)}"';
    header = '$header; filename="${browserEncode(file.value.filename)}"';
    header = '$header\r\n'
      'content-type: ${file.value.contentType}';
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
    yield close;
  }
}