import 'dart:io';

import '../../exceptions/exceptions.dart';

/// Convert a file to bytes
List<int> fileToBytes(dynamic data) {
  if (data is File) {
    return data.readAsBytesSync();
  } else if (data is String) {
    if (File(data).existsSync()) {
      return File(data).readAsBytesSync();
    } else {
      throw ZapException('File $data not exists');
    }
  } else if (data is List<int>) {
    return data;
  } else {
    throw const FormatException('File is not "File" or "String" or "List<int>"');
  }
}

/// Write bytes to a file
void writeOnFile(List<int> bytes) {}