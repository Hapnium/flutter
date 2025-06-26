import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../definitions.dart';
import '../utils/http_content_type.dart';

/// {@template multipart_file}
/// A class to represent a file in a form data with async operations
/// 
/// Args:
///   path: The file path (for file-based construction)
///   filename: The filename of the file
///   contentType: The content type of the file
/// 
/// Example:
/// ```dart
/// final file = MultipartFile('path/to/file', filename: 'image.jpg');
/// ```
/// 
/// {@endtemplate}
class MultipartFile {
  /// The file path (if constructed from file)
  final String? _filePath;

  /// Pre-loaded bytes (if constructed from bytes)
  final BodyBytes? _bytes;

  /// Pre-created stream (if constructed from stream)
  final BodyByteStream? _stream;

  /// The content type of the file (defaults to application/octet-stream)
  final String contentType;

  /// The filename of the file (sent in the request)
  final String filename;

  /// Cached length
  int? _length;

  /// Cached stream
  BodyByteStream? _cachedStream;

  /// {@macro multipart_file}
  MultipartFile(
    String filePath, {
    required this.filename,
    this.contentType = HttpContentType.APPLICATION_OCTET_STREAM,
  })  : _filePath = filePath,
        _bytes = null,
        _stream = null;

  /// Private constructor for internal use
  MultipartFile._({
    String? filePath,
    BodyBytes? bytes,
    BodyByteStream? stream,
    required this.filename,
    required this.contentType,
    int? length,
  })  : _filePath = filePath,
        _bytes = bytes,
        _stream = stream,
        _length = length;

  /// Creates a MultipartFile from a file path (async).
  ///
  /// Example:
  /// ```dart
  /// final file = await MultipartFile.fromFile('/path/to/file.png', filename: 'image.png');
  /// ```
  static Future<MultipartFile> fromFile(
    String path, {
    required String filename,
    String? contentType,
  }) async {
    final file = File(path);
    if (!await file.exists()) {
      throw ArgumentError('File does not exist: $path');
    }

    // Determine content type if not provided
    final finalContentType = contentType ?? _getContentTypeFromExtension(filename);

    return MultipartFile._(
      filePath: path,
      filename: filename,
      contentType: finalContentType,
    );
  }

  /// Creates a MultipartFile from a list of bytes.
  ///
  /// Example:
  /// ```dart
  /// final file = MultipartFile.fromBytes(myByteData, filename: 'image.jpg');
  /// ```
  factory MultipartFile.fromBytes(
    List<int> bytes, {
    required String filename,
    String? contentType,
  }) {
    final finalContentType = contentType ?? _getContentTypeFromExtension(filename);
    
    return MultipartFile._(
      bytes: Uint8List.fromList(bytes),
      filename: filename,
      contentType: finalContentType,
      length: bytes.length,
    );
  }

  /// Creates a MultipartFile from a byte stream and known length.
  ///
  /// Use this when the file is large or streaming from memory/disk/network.
  ///
  /// Example:
  /// ```dart
  /// final stream = myFile.openRead();
  /// final file = MultipartFile.fromStream(stream, length: 12345, filename: 'doc.pdf');
  /// ```
  factory MultipartFile.fromStream(
    BodyByteStream stream, {
    required int length,
    required String filename,
    String? contentType,
  }) {
    final finalContentType = contentType ?? _getContentTypeFromExtension(filename);
    
    return MultipartFile._(
      stream: stream,
      filename: filename,
      contentType: finalContentType,
      length: length,
    );
  }

  /// Get the length of the file (async)
  Future<int> get length async {
    if (_length != null) return _length!;

    if (_bytes != null) {
      _length = _bytes!.length;
      return _length!;
    }

    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        _length = await file.length();
        return _length!;
      }
    }

    return 0;
  }

  /// Get the length synchronously (returns cached value or 0)
  int get lengthSync => _length ?? (_bytes?.length ?? 0);

  /// Get the byte stream of the file (async, non-blocking)
  BodyByteStream? get stream {
    if (_cachedStream != null) return _cachedStream;

    if (_bytes != null) {
      _cachedStream = Stream.value(_bytes!);
      return _cachedStream;
    }

    if (_stream != null) {
      _cachedStream = _stream;
      return _cachedStream;
    }

    if (_filePath != null) {
      final file = File(_filePath!);
      _cachedStream = file.openRead().cast<List<int>>();
      return _cachedStream;
    }

    return null;
  }

  /// Get the raw bytes (async, only use for small files)
  Future<BodyBytes> get bytes async {
    if (_bytes != null) return _bytes!;

    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        return await file.readAsBytes(); // Async read
      }
    }

    if (_stream != null) {
      final chunks = <int>[];
      await for (final chunk in _stream!) {
        chunks.addAll(chunk);
      }
      return Uint8List.fromList(chunks);
    }

    return Uint8List(0);
  }

  /// Clone for retries
  MultipartFile clone() {
    return MultipartFile._(
      filePath: _filePath,
      bytes: _bytes,
      stream: _stream,
      filename: filename,
      contentType: contentType,
      length: _length,
    );
  }

  /// Determine content type from file extension
  static String _getContentTypeFromExtension(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return HttpContentType.IMAGE_JPEG;
      case 'png':
        return HttpContentType.IMAGE_PNG;
      case 'gif':
        return HttpContentType.IMAGE_GIF;
      case 'pdf':
        return HttpContentType.APPLICATION_PDF;
      case 'mp4':
        return HttpContentType.VIDEO_MP4;
      case 'mp3':
        return HttpContentType.AUDIO_MPEG;
      case 'json':
        return HttpContentType.APPLICATION_JSON;
      case 'xml':
        return HttpContentType.APPLICATION_XML;
      case 'zip':
        return HttpContentType.APPLICATION_ZIP;
      default:
        return HttpContentType.APPLICATION_OCTET_STREAM;
    }
  }
}