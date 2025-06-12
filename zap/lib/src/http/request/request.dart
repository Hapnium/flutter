// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import "../../definitions.dart";
import '../client/zap_client.dart' show ResponseInterceptor;
import '../multipart/form_data.dart';

/// Represents a network request sent through the Zap client.
///
/// This class holds all configuration and data associated with an HTTP request,
/// such as method, headers, body, redirect behavior, files, and more. It also
/// supports response decoding and intercepting for flexible response handling.
class Request<T> {
  /// The HTTP headers attached to this request.
  ///
  /// Example: `{'Content-Type': 'application/json', 'Authorization': 'Bearer ...'}`
  final Headers headers;

  /// The URI (Uniform Resource Identifier) to which the request is sent.
  ///
  /// Example: `Uri.parse("https://api.example.com/v1/data")`
  final Uri url;

  /// A custom decoder to convert the raw response body into a typed object [T].
  ///
  /// This allows structured deserialization of the response into models.
  final ResponseDecoder<T>? decoder;

  /// An optional interceptor to inspect or modify the response before it's returned.
  ///
  /// This is useful for adding logging, error handling, or transforming the response.
  final ResponseInterceptor<T>? responseInterceptor;

  /// The HTTP method of the request.
  ///
  /// Common methods include: `'GET'`, `'POST'`, `'PUT'`, `'DELETE'`, etc.
  final String method;

  /// The length in bytes of the request body, if known.
  ///
  /// This is often used for setting the `Content-Length` header explicitly.
  final int? contentLength;

  /// The body of the request represented as a byte stream.
  ///
  /// Useful for sending raw data, files, or streaming content.
  final BodyByteStream bodyBytes;

  /// Whether this request should follow HTTP redirects automatically.
  ///
  /// If `true`, the client will attempt to follow redirects like 301, 302.
  final bool followRedirects;

  /// The maximum number of redirects the client should follow, if [followRedirects] is `true`.
  ///
  /// Must be greater than zero if redirects are enabled.
  final int maxRedirects;

  /// Whether the client should keep the TCP connection alive for reuse.
  ///
  /// This is useful for performance when making multiple requests to the same host.
  final bool persistentConnection;

  /// Optional form data (e.g., files) to be included in the request body.
  ///
  /// Used for `multipart/form-data` uploads.
  final FormData? files;

  /// Internal constructor for initializing a [Request].
  ///
  /// Use the factory constructor for external instantiation.
  const Request._({
    required this.method,
    required this.bodyBytes,
    required this.url,
    required this.headers,
    required this.contentLength,
    required this.followRedirects,
    required this.maxRedirects,
    required this.files,
    required this.persistentConnection,
    required this.decoder,
    this.responseInterceptor,
  });

  /// Creates a new instance of [Request].
  ///
  /// This factory constructor simplifies request creation with default behavior and
  /// allows configuration of redirection, persistent connections, file uploads, etc.
  ///
  /// ---
  /// Parameters:
  /// - [url]: The destination URI of the request.
  /// - [method]: The HTTP method to use (e.g., `'GET'`, `'POST'`).
  /// - [headers]: HTTP headers to send with the request.
  /// - [bodyBytes]: The request body as a byte stream (optional).
  /// - [followRedirects]: Whether to automatically follow redirects (default: `true`).
  /// - [maxRedirects]: The maximum redirects to follow (default: `4`).
  /// - [contentLength]: Explicit content length for the request body (optional).
  /// - [files]: Optional files to upload with the request (optional).
  /// - [persistentConnection]: Whether to reuse TCP connection (default: `true`).
  /// - [decoder]: A custom response decoder to parse the response into [T].
  /// - [responseInterceptor]: Optional interceptor to modify/inspect the response.
  factory Request({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    BodyByteStream? bodyBytes,
    bool followRedirects = true,
    int maxRedirects = 4,
    int? contentLength,
    FormData? files,
    bool persistentConnection = true,
    ResponseDecoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    if (followRedirects) {
      assert(maxRedirects > 0, "maxRedirects must be > 0 when followRedirects is true.");
    }
    return Request._(
      url: url,
      method: method,
      bodyBytes: bodyBytes ??= <int>[].toStream(),
      headers: Map.from(headers),
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      contentLength: contentLength,
      files: files,
      persistentConnection: persistentConnection,
      decoder: decoder,
      responseInterceptor: responseInterceptor,
    );
  }

  /// Creates a copy of this [Request] with modified fields.
  ///
  /// You can override any field. If [appendHeader] is `true`, the new [headers]
  /// will be merged with the existing headers.
  ///
  /// ---
  /// Parameters:
  /// - [url]: Override for the request URL.
  /// - [method]: Override for the HTTP method.
  /// - [headers]: New headers to replace or merge.
  /// - [bodyBytes]: New byte stream for the request body.
  /// - [followRedirects]: Override for redirect behavior.
  /// - [maxRedirects]: Override for max redirects.
  /// - [contentLength]: Override for body content length.
  /// - [files]: Override for file data.
  /// - [persistentConnection]: Override for connection behavior.
  /// - [decoder]: Override for response decoder.
  /// - [responseInterceptor]: Override for response interceptor.
  /// - [appendHeader]: If `true`, new headers are merged into the original headers.
  Request<T> copyWith({
    Uri? url,
    String? method,
    Map<String, String>? headers,
    BodyByteStream? bodyBytes,
    bool? followRedirects,
    int? maxRedirects,
    int? contentLength,
    FormData? files,
    bool? persistentConnection,
    ResponseDecoder<T>? decoder,
    bool appendHeader = true,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    // Merge headers if required
    if (appendHeader && headers != null) {
      headers.addAll(this.headers);
    }

    return Request<T>._(
      url: url ?? this.url,
      method: method ?? this.method,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      headers: headers == null ? this.headers : Map.from(headers),
      followRedirects: followRedirects ?? this.followRedirects,
      maxRedirects: maxRedirects ?? this.maxRedirects,
      contentLength: contentLength ?? this.contentLength,
      files: files ?? this.files,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      decoder: decoder ?? this.decoder,
      responseInterceptor: responseInterceptor ?? this.responseInterceptor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url.toString(),
      'method': method,
      'bodyBytes': bodyBytes,
      'headers': headers,
      'followRedirects': followRedirects,
      'maxRedirects': maxRedirects,
      'contentLength': contentLength,
      'files': files,
      'persistentConnection': persistentConnection,
      'decoder': decoder,
      'responseInterceptor': responseInterceptor,
    };
  }
}

/// Extension on BodyBytes to convert it to a BodyByteStream.
extension StreamExt on BodyBytes {
  BodyByteStream toStream() => Stream.value(this).asBroadcastStream();
}

/// Extension on BodyByteStream for byte and string utilities.
extension BodyByteStreamStream on BodyByteStream {
  /// Collects all emitted chunks into a single byte array.
  Future<Uint8List> toBytes() {
    var completer = Completer<Uint8List>();
    var sink = ByteConversionSink.withCallback(
      (bytes) => completer.complete(Uint8List.fromList(bytes)),
    );
    listen(sink.add, onError: completer.completeError, onDone: sink.close, cancelOnError: true);
    return completer.future;
  }

  /// Converts the byte stream to a string using UTF-8 or the given [encoding].
  Future<String> bytesToString([Encoding encoding = utf8]) => encoding.decodeStream(this);
}