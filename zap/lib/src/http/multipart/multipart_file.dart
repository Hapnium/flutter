import '../stub/stub_file_decoder.dart'
    if (dart.library.js_interop) '../html/html_file_decoder.dart'
    if (dart.library.io) '../io/io_file_decoder.dart';

import '../request/request.dart';

/// A class to represent a file in a form data
/// 
/// Args:
///   data: The file data
///   filename: The filename of the file
///   contentType: The content type of the file
class MultipartFile {
  MultipartFile(
    dynamic data, {
    required this.filename,
    this.contentType = 'application/octet-stream',
  }) : _bytes = fileToBytes(data) {
    _length = _bytes.length;
    _stream = _bytes.toStream();
  }

  /// The file content as a list of bytes
  final List<int> _bytes;

  /// The content type of the file
  final String contentType;

  /// This stream will emit the file content of File.
  Stream<List<int>>? _stream;

  int? _length;

  Stream<List<int>>? get stream => _stream;

  /// The length of the file content
  int? get length => _length;

  /// The filename of the file
  final String filename;
}