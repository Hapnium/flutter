// file_reader_io.dart
import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> readFileBytes(String path) async {
  return await File(path).readAsBytes();
}