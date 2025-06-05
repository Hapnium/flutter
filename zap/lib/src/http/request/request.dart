// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:zap/src/definitions.dart';

import '../client/zap_client.dart' show ResponseInterceptor;
import '../multipart/form_data.dart';

/// The request to send to server
/// 
/// This handles all the request data and send it to server
class ZapRequest<T> {
  /// Headers attach to this [ZapRequest]
  final Map<String, String> headers;

  /// The [Uri] from request
  final Uri url;

  /// The decoder to decode the response body
  final ResponseDecoder<T>? decoder;

  /// The response interceptor to intercept the response
  final ResponseInterceptor<T>? responseInterceptor;

  /// The Http Method from this [ZapRequest]
  /// ex: `GET`,`POST`,`PUT`,`DELETE`
  final String method;

  /// The content length of body from this [ZapRequest]
  final int? contentLength;

  /// The BodyBytesStream of body from this [ZapRequest]
  final Stream<List<int>> bodyBytes;

  /// When true, the client will follow redirects to resolves this [ZapRequest]
  final bool followRedirects;

  /// The maximum number of redirects if [followRedirects] is true.
  final int maxRedirects;

  /// When true, the client will keep the connection open after the request is sent
  final bool persistentConnection;

  /// The files to send with this [ZapRequest]
  final FormData? files;

  const ZapRequest._({
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

  /// Create a [ZapRequest]
  /// 
  /// Args:
  ///   url: The url to send the request to
  ///   method: The http method to use
  ///   headers: The headers of the request
  ///   bodyBytes: The body of the request
  ///   followRedirects: When true, the client will follow redirects to resolves this [ZapRequest]
  ///   maxRedirects: The maximum number of redirects if [followRedirects] is true.
  ///   contentLength: The content length of body from this [ZapRequest]
  ///   files: The files to send with this [ZapRequest]
  ///   persistentConnection: When true, the client will keep the connection open after the request is sent
  ///   decoder: The decoder to decode the response body
  ///   responseInterceptor: The response interceptor to intercept the response
  factory ZapRequest({
    required Uri url,
    required String method,
    required Map<String, String> headers,
    Stream<List<int>>? bodyBytes,
    bool followRedirects = true,
    int maxRedirects = 4,
    int? contentLength,
    FormData? files,
    bool persistentConnection = true,
    ResponseDecoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    if (followRedirects) {
      assert(maxRedirects > 0);
    }
    return ZapRequest._(
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
      responseInterceptor: responseInterceptor);
  }

  /// Returns a new [ZapRequest] object with overridden values.
  ///
  /// If [appendHeader] is `true`, the original headers will be merged with [headers].
  ZapRequest<T> copyWith({
    Uri? url,
    String? method,
    Map<String, String>? headers,
    Stream<List<int>>? bodyBytes,
    bool? followRedirects,
    int? maxRedirects,
    int? contentLength,
    FormData? files,
    bool? persistentConnection,
    ResponseDecoder<T>? decoder,
    bool appendHeader = true,
    ResponseInterceptor<T>? responseInterceptor,
  }) {
    // If appendHeader is set to true, we will merge origin headers with that
    if (appendHeader && headers != null) {
      headers.addAll(this.headers);
    }

    return ZapRequest<T>._(
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
      responseInterceptor: responseInterceptor ?? this.responseInterceptor);
  }
}

/// Extension on List<int> to convert it to a Stream<List<int>>.
extension StreamExt on List<int> {
  Stream<List<int>> toStream() => Stream.value(this).asBroadcastStream();
}

/// Extension on Stream<List<int>> for byte and string utilities.
extension BodyBytesStream on Stream<List<int>> {
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