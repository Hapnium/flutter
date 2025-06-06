import 'package:zap/src/definitions.dart';

import 'http_headers.dart';
import 'redirect_info.dart';

/// This interface is used to represent a response from a server.
/// 
/// It extends [BodyBytes] to provide a stream of bytes which is the response body.
abstract interface class HttpClientResponse implements BodyBytes {
  /// Returns the status code.
  ///
  /// The status code must be set before the body is written
  /// to. Setting the status code after writing to the body will throw
  /// a `StateError`.
  int get statusCode;

  /// Returns the reason phrase associated with the status code.
  ///
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body will throw
  /// a `StateError`.
  String get reasonPhrase;

  /// Returns the content length of the response body. Returns -1 if the size of
  /// the response body is not known in advance.
  ///
  /// If the content length needs to be set, it must be set before the
  /// body is written to. Setting the content length after writing to the body
  /// will throw a `StateError`.
  int get contentLength;

  // /// The compression state of the response.
  // ///
  // /// This specifies whether the response bytes were compressed when they were
  // /// received across the wire and whether callers will receive compressed
  // /// or uncompressed bytes when they listed to this response's byte stream.
  // @Since("2.4")
  // HttpClientResponseCompressionState get compressionState;

  /// Gets the persistent connection state returned by the server.
  ///
  /// If the persistent connection state needs to be set, it must be
  /// set before the body is written to. Setting the persistent connection state
  /// after writing to the body will throw a `StateError`.
  bool get persistentConnection;

  /// Returns whether the status code is one of the normal redirect
  /// codes [HttpStatus.movedPermanently], [HttpStatus.found],
  /// [HttpStatus.movedTemporarily], [HttpStatus.seeOther] and
  /// [HttpStatus.temporaryRedirect].
  bool get isRedirect;

  /// Returns the series of redirects this connection has been through. The
  /// list will be empty if no redirects were followed. [redirects] will be
  /// updated both in the case of an automatic and a manual redirect.
  List<RedirectInfo> get redirects;

  /// Redirects this connection to a new URL. The default value for
  /// [method] is the method for the current request. The default value
  /// for [url] is the value of the [HttpHeaders.locationHeader] header of
  /// the current response. All body data must have been read from the
  /// current response before calling [redirect].
  ///
  /// All headers added to the request will be added to the redirection
  /// request. However, any body sent with the request will not be
  /// part of the redirection request.
  ///
  /// If [followLoops] is set to `true`, redirect will follow the redirect,
  /// even if the URL was already visited. The default value is `false`.
  ///
  /// The method will ignore [HttpClientRequest.maxRedirects]
  /// and will always perform the redirect.
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]);

  /// Returns the client response headers.
  ///
  /// The client response headers are immutable.
  HttpHeaders get headers;

  // /// Detach the underlying socket from the HTTP client. When the
  // /// socket is detached the HTTP client will no longer perform any
  // /// operations on it.
  // ///
  // /// This is normally used when a HTTP upgrade is negotiated and the
  // /// communication should continue with a different protocol.
  // Future<Socket> detachSocket();

  // /// Cookies set by the server (from the 'set-cookie' header).
  // List<Cookie> get cookies;

  // /// Returns the certificate of the HTTPS server providing the response.
  // /// Returns null if the connection is not a secure TLS or SSL connection.
  // X509Certificate? get certificate;

  // /// Gets information about the client connection. Returns `null` if the socket
  // /// is not available.
  // HttpConnectionInfo? get connectionInfo;
}