import 'dart:io';

import '../../definitions.dart';
import '../../exceptions/zap_exception.dart';

/// Convert a file to bytes
BodyBytes fileToBytes(dynamic data) {
  if (data is File) {
    return data.readAsBytesSync();
  } else if (data is String) {
    if (File(data).existsSync()) {
      return File(data).readAsBytesSync();
    } else {
      throw ZapException.parsing('File $data not exists');
    }
  } else if (data is BodyBytes) {
    return data;
  } else {
    throw ZapException.parsing('File is not "File" or "String" or "BodyBytes"');
  }
}

/// Write bytes to a file
void writeOnFile(BodyBytes bytes) {}