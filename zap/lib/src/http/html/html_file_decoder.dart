// import 'dart:html' as html;

import '../../definitions.dart';

/// Converts a file to bytes
BodyBytes fileToBytes(dynamic data) {
  if (data is BodyBytes) {
    return data;
  } else {
    throw FormatException('File is not "File" or "String" or "BodyBytes"');
  }
}

// void writeOnFile(BodyBytes bytes) {
//   var blob = html.Blob(["data"], 'text/plain', 'native');
//   var anchorElement = html.AnchorElement(
//     href: html.Url.createObjectUrlFromBlob(blob).toString(),
//   )
//     ..setAttribute("download", "data.txt")
//     ..click();
// }