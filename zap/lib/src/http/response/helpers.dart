import 'dart:convert';

import '../../definitions.dart';
import '../../http/request/request.dart';
import 'header_value.dart';

/// Convert a [BodyByteStream] to a [String]
/// 
/// Args:
///   bodyBytes: The body bytes to convert
///   headers: The headers of the response
Future<String> bodyBytesToString(BodyByteStream bodyBytes, Headers headers) {
  return bodyBytes.bytesToString(_encodingForHeaders(headers));
}

/// Returns the encoding to use for a response with the given headers.
///
/// Defaults to [utf8] if the headers don't specify a charset or if that
/// charset is unknown.
Encoding _encodingForHeaders(Headers headers) =>
    _encodingForCharset(_contentTypeForHeaders(headers).parameters!['charset']);

/// Returns the [Encoding] that corresponds to [charset].
///
/// Returns [fallback] if [charset] is null or if no [Encoding] was found that
/// corresponds to [charset].
Encoding _encodingForCharset(String? charset, [Encoding fallback = utf8]) {
  if (charset == null) return fallback;
  return Encoding.getByName(charset) ?? fallback;
}

/// Returns the MediaType object for the given headers's content-type.
///
/// Defaults to `application/octet-stream`.
HeaderValue _contentTypeForHeaders(Headers headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return HeaderValue.parse(contentType);
  return HeaderValue('application/octet-stream');
}