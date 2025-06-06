import 'dart:async';
import 'dart:convert';

import 'package:zap/src/definitions.dart';

import '../certificates/certificates.dart';
import '../../exceptions/exceptions.dart';
import '../interface/http_client_response.dart';
import '../interface/http_request_interface.dart';
import '../modifier/zap_modifier.dart';
import '../multipart/form_data.dart';
import '../request/http_request.dart';
import '../request/request.dart';
import '../response/response.dart';
import '../utils/http_status.dart';

/// A function that allows interception and modification of the HTTP response before it is returned.
/// 
/// Can be used for custom parsing, logging, or authentication flows.
/// 
/// - [request]: The original request.
/// - [targetType]: The expected type of the response body.
/// - [response]: The raw HTTP response.
typedef ZapResponseInterceptor<T> = Future<ZapResponse<T>?> Function(ZapRequest<T> request, Type targetType, HttpClientResponse response);

/// The core HTTP client used to configure and send HTTP requests.
///
/// [ZapClient] provides a customizable interface for sending HTTP requests
/// with support for default headers, redirects, proxy settings, response
/// interceptors, timeouts, and decoding strategies.
///
/// It's designed to be flexible for various use cases including REST APIs,
/// file downloads, and custom request flows.
///
/// ## Example
/// ```dart
/// final client = ZapClient(
///   baseUrl: 'https://api.example.com',
///   userAgent: 'Zap/1.0',
///   timeout: Duration(seconds: 10),
/// );
/// ```
class ZapClient {
  /// The user agent string to send with each request.
  ///
  /// This identifies the client to the server. If [sendUserAgent] is `false`,
  /// this value is ignored.
  String userAgent;

  /// The base URL to prepend to relative request paths.
  ///
  /// If provided, all relative URLs will be resolved against this base.
  String? baseUrl;

  /// The default content type to include in request headers.
  ///
  /// Typically used for APIs expecting JSON, form-encoded data, etc.
  /// Default is `'application/json; charset=utf-8'`.
  String defaultContentType = 'application/json; charset=utf-8';

  /// Whether the client should automatically follow HTTP redirects.
  ///
  /// Defaults to `true`. If set to `false`, 3xx responses are returned as-is.
  bool followRedirects;

  /// The maximum number of redirects the client should follow.
  ///
  /// Only relevant if [followRedirects] is `true`.
  int maxRedirects;

  /// The maximum number of times to retry authentication challenges (e.g., 401).
  ///
  /// Helps prevent infinite loops during failed auth attempts.
  int maxAuthRetries;

  /// Whether to include the [userAgent] header in requests.
  ///
  /// If `false`, no `User-Agent` header will be sent.
  bool sendUserAgent;

  /// Whether to automatically calculate and include the `Content-Length` header.
  ///
  /// Some servers require this; enabling it helps with compatibility.
  bool sendContentLength;

  /// The default function to decode the response body.
  ///
  /// This is used when no specific decoder is provided per request.
  ResponseDecoder? defaultDecoder;

  /// The default function to intercept and optionally modify HTTP responses.
  ///
  /// Can be used for logging, error handling, or data transformation.
  ZapResponseInterceptor? defaultResponseInterceptor;

  /// The maximum duration to wait before a request times out.
  ///
  /// This applies to connection, sending, and receiving phases.
  Duration timeout;

  /// Whether the client should safely handle errors during request execution.
  ///
  /// If `true`, errors are caught and handled internally. If `false`,
  /// they are allowed to propagate.
  bool errorSafety;

  /// The internal low-level HTTP request interface used by the client.
  ///
  /// This is typically injected and not meant for direct use by consumers.
  final HttpRequestInterface _client;

  /// A modifier used to mutate requests and responses globally.
  ///
  /// Can be used to add headers, transform requests, or log responses.
  final ZapModifier _modifier;

  /// A callback that returns a proxy URL for a given request URL.
  ///
  /// If `null`, no proxy is used. Useful for custom proxy logic.
  ProxyFinder? findProxy;

  /// Creates a new instance of [ZapClient] with customizable networking behavior.
  ///
  /// This constructor allows configuring HTTP settings such as timeouts,
  /// redirection, certificate trust, and proxy handling. It is intended for use
  /// in applications that require fine-grained control over how HTTP requests are
  /// made and how responses are processed.
  ///
  /// ### Parameters:
  /// - [userAgent]: The User-Agent string sent with requests (if [sendUserAgent] is true).
  /// - [timeout]: The maximum duration to wait before a request times out.
  /// - [followRedirects]: Whether the client should automatically follow HTTP 3xx redirects.
  /// - [maxRedirects]: Maximum number of redirects to follow before failing the request.
  /// - [sendUserAgent]: Whether to include the User-Agent header in requests.
  /// - [sendContentLength]: Whether to automatically set the `Content-Length` header.
  /// - [maxAuthRetries]: Maximum number of retries for authentication challenges (e.g., HTTP 401).
  /// - [allowAutoSignedCert]: Whether to allow self-signed certificates. Useful for testing.
  /// - [baseUrl]: Optional base URL that will be prepended to relative request paths.
  /// - [trustedCertificates]: A list of [ZapTrustedCertificate] instances to trust explicitly.
  /// - [withCredentials]: Whether to include credentials (like cookies) in CORS requests.
  /// - [findProxy]: A function to determine the proxy server for a given request URL.
  /// - [customClient]: A custom low-level HTTP implementation to use instead of the default.
  ///
  /// ### Returns:
  /// A new, fully configured instance of [ZapClient].
  ZapClient({
    this.userAgent = 'hapx-client',
    this.timeout = const Duration(seconds: 8),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.sendUserAgent = false,
    this.sendContentLength = true,
    this.maxAuthRetries = 1,
    bool allowAutoSignedCert = false,
    this.baseUrl,
    List<ZapTrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    ProxyFinder? findProxy,
    HttpRequestInterface? customClient,
    this.errorSafety = true,
  })  : _client = customClient ?? createHttp(
      allowAutoSignedCert: allowAutoSignedCert,
      trustedCertificates: trustedCertificates,
      withCredentials: withCredentials,
      findProxy: findProxy,
    ),
    _modifier = ZapModifier();

  /// Adds an authenticator function that modifies requests before sending.
  ///
  /// Authenticator functions are commonly used to inject credentials, tokens,
  /// or headers before a request is dispatched.
  ///
  /// ### Parameters:
  /// - [auth]: A [ZapRequestModifier] function that takes a request and modifies it.
  void addAuthenticator<T>(ZapRequestModifier<T> auth) {
    _modifier.authenticator = auth as ZapRequestModifier;
  }

  /// Adds a request modifier function that intercepts and alters outgoing requests.
  ///
  /// This can be used to inject headers, transform URLs, log request data, etc.
  ///
  /// ### Parameters:
  /// - [interceptor]: A [ZapRequestModifier] that transforms the request before sending.
  void addRequestModifier<T>(ZapRequestModifier<T> interceptor) {
    _modifier.addRequestModifier<T>(interceptor);
  }

  /// Removes a previously added request modifier.
  ///
  /// ### Parameters:
  /// - [interceptor]: The [ZapRequestModifier] to be removed.
  void removeRequestModifier<T>(ZapRequestModifier<T> interceptor) {
    _modifier.removeRequestModifier(interceptor);
  }

  /// Adds a response modifier function that intercepts responses after they are received.
  ///
  /// Useful for tasks like logging, response transformation, or centralized error handling.
  ///
  /// ### Parameters:
  /// - [interceptor]: A [ZapResponseModifier] that operates on the response.
  void addResponseModifier<T>(ZapResponseModifier<T> interceptor) {
    _modifier.addResponseModifier(interceptor);
  }

  /// Removes a previously added response modifier.
  ///
  /// ### Parameters:
  /// - [interceptor]: The [ZapResponseModifier] to remove from the modifier stack.
  void removeResponseModifier<T>(ZapResponseModifier<T> interceptor) {
    _modifier.removeResponseModifier<T>(interceptor);
  }

  /// Builds a fully qualified [Uri] from a path and optional query parameters.
  ///
  /// If [baseUrl] is set, the path will be appended to it. Otherwise,
  /// the path must be a full URL.
  ///
  /// ### Parameters:
  /// - [url]: A relative or absolute URL string.
  /// - [query]: An optional map of query parameters.
  ///
  /// ### Returns:
  Uri createUri(String? url, RequestParam? query) {
    if (baseUrl != null) {
      url = baseUrl! + url!;
    }
    
    final uri = Uri.parse(url!);
    if (query != null) {
      // Convert all query parameter values to strings
      final stringQuery = query.map((key, value) {
        if (value is List) {
          // Convert list to comma-separated string or bracket notation
          return MapEntry(key, value.map((e) => e.toString()).join(','));
          // Alternative bracket notation: return MapEntry(key, '[${value.map((e) => e.toString()).join(',')}]');
        } else {
          return MapEntry(key, value.toString());
        }
      });
      return uri.replace(queryParameters: stringQuery);
    }

    return uri;
  }

  /// Create a request with body
  Future<ZapRequest<T>> _requestWithBody<T>(
    String? url,
    String? contentType,
    RequestBody body,
    String method,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  ) async {
    List<int>? bodyBytes;
    Stream<List<int>>? bodyStream;
    final Headers headers = {};

    if (sendUserAgent) {
      headers['user-agent'] = userAgent;
    }

    if (body is FormData) {
      bodyBytes = await body.toBytes();
      headers['content-length'] = bodyBytes.length.toString();
      headers['content-type'] = 'multipart/form-data; boundary=${body.boundary}';
    } else if (contentType != null && contentType.toLowerCase() == 'application/x-www-form-urlencoded' && body is Map) {
      var parts = [];
      (body as RequestParam).forEach((key, value) {
        parts.add('${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}');
      });
      var formData = parts.join('&');
      bodyBytes = utf8.encode(formData);
      _setContentLength(headers, bodyBytes.length);
      headers['content-type'] = contentType;
    } else if (body is Map || body is List) {
      var jsonString = json.encode(body);
      bodyBytes = utf8.encode(jsonString);
      _setContentLength(headers, bodyBytes.length);
      headers['content-type'] = contentType ?? defaultContentType;
    } else if (body is String) {
      bodyBytes = utf8.encode(body);
      _setContentLength(headers, bodyBytes.length);

      headers['content-type'] = contentType ?? defaultContentType;
    } else if (body == null) {
      _setContentLength(headers, 0);
      headers['content-type'] = contentType ?? defaultContentType;
    } else {
      if (!errorSafety) {
        throw ZapUnexpectedFormat('Request body cannot be ${body.runtimeType}');
      }
    }

    if (bodyBytes != null) {
      bodyStream = _trackProgress(bodyBytes, uploadProgress);
    }

    final uri = createUri(url, query);
    return ZapRequest<T>(
      method: method,
      url: uri,
      headers: headers,
      bodyBytes: bodyStream,
      contentLength: bodyBytes?.length ?? 0,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      decoder: decoder,
      responseInterceptor: responseInterceptor
    );
  }

  void _setContentLength(Map<String, String> headers, int contentLength) {
    if (sendContentLength) {
      headers['content-length'] = '$contentLength';
    }
  }

  Stream<List<int>> _trackProgress(List<int> bodyBytes, Progress? uploadProgress) {
    var total = 0;
    var length = bodyBytes.length;

    var byteStream = Stream.fromIterable(bodyBytes.map((i) => [i])).transform<List<int>>(
      StreamTransformer.fromHandlers(handleData: (data, sink) {
        total += data.length;
        if (uploadProgress != null) {
          var percent = total / length * 100;
          uploadProgress(percent);
        }
        sink.add(data);
      }),
    );

    return byteStream;
  }

  void _setSimpleHeaders(Headers headers, String? contentType) {
    headers['content-type'] = contentType ?? defaultContentType;
    if (sendUserAgent) {
      headers['user-agent'] = userAgent;
    }
  }

  Future<ZapResponse<T>> _handleException<T>(Exception e, ZapRequest<T> request) {
    if (!errorSafety) {
      if(e is ZapException) {
        throw e;
      }

      throw ZapException(e.toString());
    }

    return Future.value(ZapResponse<T>(
      status: HttpStatus.CONNECTION_NOT_REACHABLE,
      message: 'Can not connect to server. Reason: $e',
      request: request,
      headers: null,
      body: null,
      bodyBytes: null,
      bodyString: "$e",
    ));
  }

  Future<ZapResponse<T>> _perform<T>(ZapRequest<T> request, {bool useAuth = false, int requestNumber = 1, Headers? headers}) async {
    headers?.forEach((key, value) {
      request.headers[key] = value;
    });

    if (useAuth) {
      await _modifier.authenticator!(request);
    }

    final req = await _modifier.modifyRequest<T>(request);
    _client.timeout = timeout;

    try {
      var res = await _client.send<T>(req);
      var response = await _modifier.modifyResponse<T>(req, res);

      if (response.status.isUnauthorized && _modifier.authenticator != null && requestNumber <= maxAuthRetries) {
        return _perform<T>(req, useAuth: true, requestNumber: requestNumber + 1, headers: req.headers);
      } else if (response.status.isUnauthorized) {
        if (!errorSafety) {
          throw ZapUnauthorizedException();
        } else {
          return ZapResponse<T>(
            request: req,
            headers: response.headers,
            status: response.status,
            body: response.body,
            bodyBytes: response.bodyBytes,
            bodyString: response.bodyString,
          );
        }
      }

      return response;
    } on Exception catch (err) {
      return _handleException<T>(err, request);
    }
  }

  ZapResponseInterceptor<T>? _responseInterceptor<T>(ZapResponseInterceptor<T>? actual) {
    if (actual != null) return actual;

    if (defaultResponseInterceptor != null) {
      return (request, targetType, response) async {
        final result = await defaultResponseInterceptor!(request, targetType, response);
        return result as ZapResponse<T>?;
      };
    }

    return null;
  }

  Future<ZapRequest<T>> _getRequestWithBody<T>(String? url, String method, {
    String? contentType,
    required RequestBody body,
    required RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) {
    decoder ??= defaultDecoder as ResponseDecoder<T>?;
    responseInterceptor = _responseInterceptor(responseInterceptor);

    return _requestWithBody<T>(url, contentType, body, method, query, decoder, responseInterceptor, uploadProgress);
  }

  /// Sends a custom [ZapRequest] through the client pipeline.
  ///
  /// This method can be used when a prebuilt [ZapRequest] object is available,
  /// offering more control over the request's lifecycle.
  ///
  /// Throws a [ZapException] if the request fails and [errorSafety] is disabled.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the result of the request.
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request) async {
    try {
      var response = await _perform<T>(request);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP PATCH request to the given [url].
  ///
  /// Useful for making partial updates to a resource.
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [body]: Optional body payload for the request.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [headers]: Additional HTTP headers.
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the server's reply.
  Future<ZapResponse<T>> patch<T>(String url, {
    RequestBody body,
    String? contentType,
    Map<String, String>? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
    // List<MultipartFile> files,
  }) async {
    final request = await _getRequestWithBody<T>(
      url,
      'patch',
      contentType: contentType,
      body: body,
      query: query,
      decoder: decoder,
      responseInterceptor: responseInterceptor,
      uploadProgress: uploadProgress,
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP POST request to the given [url].
  ///
  /// Useful for submitting data to a server.
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [body]: Optional body payload for the request.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [headers]: Additional HTTP headers.
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the server's reply.
  Future<ZapResponse<T>> post<T>(String? url, {
    RequestBody body,
    String? contentType,
    Map<String, String>? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
    // List<MultipartFile> files,
  }) async {
    final request = await _getRequestWithBody<T>(
      url,
      'post',
      contentType: contentType,
      body: body,
      query: query,
      decoder: decoder,
      responseInterceptor: responseInterceptor,
      uploadProgress: uploadProgress,
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP request to the given [url] using the specified [method].
  ///
  /// Useful for making custom HTTP requests when the built-in methods are insufficient and you need more control.
  ///
  /// This method supports all HTTP methods (e.g., GET, POST, PUT, PATCH, DELETE).
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [method]: HTTP method (e.g., 'GET', 'POST', 'PUT', 'DELETE').
  /// - [body]: Optional body payload for the request.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [headers]: Additional HTTP headers.
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the server's reply.
  Future<ZapResponse<T>> request<T>(String url, String method, {
    RequestBody body,
    String? contentType,
    Map<String, String>? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) async {
    final request = await _getRequestWithBody<T>(
      url,
      method,
      contentType: contentType,
      body: body,
      query: query,
      decoder: decoder,
      responseInterceptor: responseInterceptor,
      uploadProgress: uploadProgress,
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP PUT request to the given [url].
  ///
  /// Useful for updating resources on the server.
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [body]: Optional body payload for the request.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [headers]: Additional HTTP headers.
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the server's reply.
  Future<ZapResponse<T>> put<T>(String url, {
    RequestBody body,
    String? contentType,
    Map<String, String>? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) async {
    final request = await _getRequestWithBody<T>(
      url,
      'put',
      contentType: contentType,
      query: query,
      body: body,
      decoder: decoder,
      responseInterceptor: responseInterceptor,
      uploadProgress: uploadProgress,
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP GET request to the specified [url].
  ///
  /// Use this to retrieve data from a server without modifying it.
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [headers]: Additional request headers.
  /// - [contentType]: Expected MIME type of the response.
  /// - [query]: Query parameters to append to the request URL.
  /// - [decoder]: Optional function to decode the response body.
  /// - [responseInterceptor]: Optional hook for modifying the received response.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] with the requested resource.
  Future<ZapResponse<T>> get<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
  }) async {
    final Headers headers = {};
    _setSimpleHeaders(headers, contentType);
    final uri = createUri(url, query);

    final request = ZapRequest<T>(
      method: 'get',
      url: uri,
      headers: headers,
      decoder: decoder ?? (defaultDecoder as ResponseDecoder<T>?),
      responseInterceptor: _responseInterceptor(responseInterceptor),
      contentLength: 0,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Sends an HTTP DELETE request to the specified [url].
  ///
  /// Use this to remove resources from a server.
  ///
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [headers]: Additional HTTP headers.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  ///
  /// Returns:
  ///   A [ZapResponse] of type [T] representing the server's reply.
  Future<ZapResponse<T>> delete<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ZapResponseInterceptor<T>? responseInterceptor,
  }) async {
    final Headers headers = {};
    _setSimpleHeaders(headers, contentType);
    final uri = createUri(url, query);

    final request = ZapRequest<T>(
      method: 'delete',
      url: uri,
      headers: headers,
      decoder: decoder ?? (defaultDecoder as ResponseDecoder<T>?),
      responseInterceptor: _responseInterceptor(responseInterceptor),
    );

    try {
      var response = await _perform<T>(request, headers: headers);
      return response;
    } on Exception catch (e) {
      return _handleException<T>(e, request);
    }
  }

  /// Closes the underlying HTTP client and releases resources.
  ///
  /// After calling this method, the [ZapClient] instance should not be used
  /// to make further requests.
  ///
  /// This is especially important for applications that maintain persistent
  /// connections or run in long-lived environments.
  void close() {
    _client.close();
  }
}