import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data' show Uint8List;

import '../../definitions.dart';
import '../../exceptions/zap_exception.dart';
import '../utils/http_content_type.dart';
import '../utils/http_headers.dart';
import '../utils/utils.dart';
import 'multipart_file.dart';

const _secureRandomSeedBound = 4294967296;
final _random = Random();

/// Improved FormData class with full async support
class FormData {
  FormData({
    this.camelCaseContentDisposition = false,
  }) {
    _init();
  }

  /// Create [FormData] from a [Map].
  FormData.fromMap(
    Map<String, dynamic> map, {
    this.camelCaseContentDisposition = false,
  }) {
    _init(fromMap: map);
  }

  /// Whether the 'content-disposition' header can be 'Content-Disposition'.
  final bool camelCaseContentDisposition;

  void _init({Map<String, dynamic>? fromMap}) {
    // Use your existing GET_BOUNDARY
    final randomSuffix = _random.nextInt(_secureRandomSeedBound).toString();
    _boundary = '$GET_BOUNDARY$randomSuffix';
    
    if (fromMap != null) {
      fromMap.forEach((key, value) {
        if (value == null) return;
        
        if (value is MultipartFile) {
          files.add(MapEntry(key, value));
        } else if (value is List<MultipartFile>) {
          for (var file in value) {
            files.add(MapEntry(key, file));
          }
        } else if (value is List) {
          for (var item in value) {
            fields.add(MapEntry(key, item.toString()));
          }
        } else {
          fields.add(MapEntry(key, value.toString()));
        }
      });
    }
  }

  /// The boundary used in the multipart request
  String get boundary => _boundary;
  late String _boundary;

  /// The form fields to send for this request.
  final fields = <MapEntry<String, String>>[];

  /// The files to send for this request
  final files = <MapEntry<String, MultipartFile>>[];

  /// Whether [finalize] has been called.
  bool get isFinalized => _isFinalized;
  bool _isFinalized = false;

  String get _contentDispositionKey => camelCaseContentDisposition
      ? HttpHeaders.CONTENT_DISPOSITION.toUpperCase().split('-').map((word) => 
          word[0].toUpperCase() + word.substring(1)).join('-')
      : HttpHeaders.CONTENT_DISPOSITION;

  /// Returns the header string for a field
  String _headerForField(String name, String value) {
    var header = '$_contentDispositionKey: ${HttpContentType.FORM_DATA}; name="${browserEncode(name)}"';
    
    if (!isPlainAscii(value)) {
      header = '$header\r\n'
        '${HttpHeaders.CONTENT_TYPE}: ${HttpContentType.TEXT_PLAIN}; ${HttpContentType.CHARSET_UTF_8}\r\n'
        '${HttpHeaders.CONTENT_TRANSFER_ENCODING}: ${HttpContentType.BINARY}';
    }
    return '$header\r\n\r\n';
  }

  /// Returns the header string for a file
  String _headerForFile(MapEntry<String, MultipartFile> entry) {
    final file = entry.value;
    String header = '$_contentDispositionKey: ${HttpContentType.FORM_DATA}; name="${browserEncode(entry.key)}"';
    
    if (file.filename.isNotEmpty) {
      header = '$header; filename="${browserEncode(file.filename)}"';
    }
    
    header = '$header\r\n'
      '${HttpHeaders.CONTENT_TYPE}: ${file.contentType}\r\n\r\n';
    return header;
  }

  /// Get total length asynchronously (non-blocking)
  Future<int> get lengthAsync async {
    int length = 0;
    
    for (final entry in fields) {
      length += '--'.length +
          _boundary.length +
          '\r\n'.length +
          utf8.encode(_headerForField(entry.key, entry.value)).length +
          utf8.encode(entry.value).length +
          '\r\n'.length;
    }

    for (final file in files) {
      final fileLength = await file.value.length;
      length += '--'.length +
          _boundary.length +
          '\r\n'.length +
          utf8.encode(_headerForFile(file)).length +
          fileLength +
          '\r\n'.length;
    }

    return length + '--'.length + _boundary.length + '--\r\n'.length;
  }

  /// Synchronous length (uses cached values, may be inaccurate)
  int get length {
    int length = 0;
    
    for (final entry in fields) {
      length += '--'.length +
          _boundary.length +
          '\r\n'.length +
          utf8.encode(_headerForField(entry.key, entry.value)).length +
          utf8.encode(entry.value).length +
          '\r\n'.length;
    }

    for (final file in files) {
      length += '--'.length +
          _boundary.length +
          '\r\n'.length +
          utf8.encode(_headerForFile(file)).length +
          file.value.lengthSync +
          '\r\n'.length;
    }

    return length + '--'.length + _boundary.length + '--\r\n'.length;
  }

  /// Finalize the FormData into a stream (fully async, non-blocking)
  Stream<Uint8List> finalize() {
    if (isFinalized) {
      throw ZapException(
        'The FormData has already been finalized. '
        'This typically means you are using the same FormData in repeated requests.',
      );
    }
    _isFinalized = true;

    final controller = StreamController<Uint8List>(sync: false);
    final rnU8 = Uint8List.fromList([13, 10]);

    void writeLine() => controller.add(rnU8);
    void writeUtf8(String s) => controller.add(_effectiveU8Encoding(utf8.encode(s)));

    // Process everything asynchronously
    _processFormDataAsync(controller, writeUtf8, writeLine);

    return controller.stream;
  }

  Future<void> _processFormDataAsync(
    StreamController<Uint8List> controller,
    void Function(String) writeUtf8,
    void Function() writeLine,
  ) async {
    try {
      // Write fields first
      for (final entry in fields) {
        writeUtf8('--$boundary\r\n');
        writeUtf8(_headerForField(entry.key, entry.value));
        writeUtf8(entry.value);
        writeLine();
        
        // Yield control to prevent blocking
        await Future.delayed(Duration.zero);
      }

      // Write files with streaming
      for (final file in files) {
        writeUtf8('--$boundary\r\n');
        writeUtf8(_headerForFile(file));
        
        final fileStream = file.value.stream;
        if (fileStream != null) {
          await for (final chunk in fileStream) {
            controller.add(_effectiveU8Encoding(chunk));
            // Yield control periodically to keep UI responsive
            await Future.delayed(Duration.zero);
          }
        }
        writeLine();
      }
      
      writeUtf8('--$boundary--\r\n');
    } catch (e) {
      controller.addError(e);
    } finally {
      controller.close();
    }
  }

  /// Transform the entire FormData contents as bytes (async)
  Future<Uint8List> readAsBytes() {
    return finalize().fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    ).then((bytes) => Uint8List.fromList(bytes));
  }

  /// Returns the request body as a list of bytes (compatible with existing code)
  Future<BodyBytes> toBytes() async {
    return await readAsBytes();
  }

  /// Clone the FormData for retries
  FormData clone() {
    final clone = FormData(
      camelCaseContentDisposition: camelCaseContentDisposition,
    );
    clone._boundary = _boundary;
    clone.fields.addAll(fields);
    
    for (final file in files) {
      clone.files.add(MapEntry(file.key, file.value.clone()));
    }
    return clone;
  }
}

Uint8List _effectiveU8Encoding(List<int> encoded) {
  return encoded is Uint8List ? encoded : Uint8List.fromList(encoded);
}