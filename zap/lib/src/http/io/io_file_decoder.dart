import 'dart:io';

import '../../definitions.dart';
import '../../exceptions/exceptions.dart';

/// Convert a file to bytes
BodyBytes fileToBytes(dynamic data) {
  if (data is File) {
    return data.readAsBytesSync();
  } else if (data is String) {
    if (File(data).existsSync()) {
      return File(data).readAsBytesSync();
    } else {
      throw ZapException('File $data not exists');
    }
  } else if (data is BodyBytes) {
    return data;
  } else {
    throw const FormatException('File is not "File" or "String" or "BodyBytes"');
  }
}

/// Write bytes to a file
void writeOnFile(BodyBytes bytes) {}