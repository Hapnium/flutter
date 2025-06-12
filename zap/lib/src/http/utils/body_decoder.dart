import 'dart:convert';

import 'package:tracing/tracing.dart';

import '../request/request.dart';
import 'http_status.dart';

T? bodyDecoded<T>(Request<T> request, String stringBody, String? mimeType, HttpStatus status) {
  T? body;
  dynamic bodyToDecode;

  if (mimeType != null && mimeType.contains('application/json')) {
    try {
      bodyToDecode = jsonDecode(stringBody);
    } on FormatException catch (_) {
      console.log('Cannot decode server response to json');
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
      body = request.decoder!(status, bodyToDecode);
    }
  } on Exception catch (_) {
    body = stringBody as T;
  }

  return body;
}