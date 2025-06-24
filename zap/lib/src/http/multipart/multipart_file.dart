import '../../definitions.dart';
import '../stub/stub_file_decoder.dart'
    if (dart.library.js_interop) '../html/html_file_decoder.dart'
    if (dart.library.io) '../io/io_file_decoder.dart';

import '../request/request.dart';
import '../utils/http_content_type.dart';

/// {@template multipart_file}
/// A class to represent a file in a form data
/// 
/// Args:
///   data: The file data
///   filename: The filename of the file
///   contentType: The content type of the file
/// 
/// Example:
/// ```dart
/// final file = MultipartFile.fromFile('path/to/file');
/// ```
/// 
/// {@endtemplate}
class MultipartFile {
  /// {@macro multipart_file}
  MultipartFile(dynamic data, {
    required this.filename,
    this.contentType = HttpContentType.APPLICATION_OCTET_STREAM,
  }) : _bytes = fileToBytes(data) {
    _length = _bytes.length;
    _stream = _bytes.toStream();
  }

  /// The file content as a list of bytes
  final BodyBytes _bytes;

  /// The content type of the file
  final String contentType;

  /// This stream will emit the file content of File.
  BodyByteStream? _stream;

  int? _length;

  BodyByteStream? get stream => _stream;

  /// The length of the file content
  int? get length => _length;

  /// The filename of the file
  final String filename;
}