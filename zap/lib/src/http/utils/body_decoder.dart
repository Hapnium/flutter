import 'dart:convert';

import '../../core/zap_inst.dart';
import '../request/request.dart';
import 'http_content_type.dart';

/// Decodes the body of a request
/// 
/// Args:
///   request: The request
///   stringBody: The body of the request as a string
///   mimeType: The mime type of the body
/// 
/// Returns:
///   The decoded body
T? bodyDecoded<T>(Request<T> request, String stringBody, String? mimeType) {
  T? body;
  dynamic bodyToDecode;

  if (mimeType != null && mimeType.contains(HttpContentType.APPLICATION_JSON)) {
    try {
      bodyToDecode = jsonDecode(stringBody);
    } on FormatException catch (_) {
      Z.log('Cannot decode server response to json');
      bodyToDecode = stringBody;
    }
  } else {
    bodyToDecode = stringBody;
  }

  try {
    if (stringBody == '') {
      body = null;
    } else if (request.decoder == null) {
      body = bodyToDecode as T?;
    } else {
      body = request.decoder!(bodyToDecode);
    }
  } on Exception catch (_) {
    body = stringBody as T;
  }

  return body;
}