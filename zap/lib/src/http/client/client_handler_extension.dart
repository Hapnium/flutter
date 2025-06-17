part of 'zap_client.dart';

extension ClientHandlerExtension on ClientHandler {
  ControllerAdvice get _adviser => controllerAdvice ?? ControllerAdvice();

  /// Create a request with body
  Future<Request<T>> requestWithBody<T>(
    String? url,
    String? contentType,
    RequestBody body,
    String method,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  ) async {
    BodyBytes? bodyBytes;
    BodyByteStream? bodyStream;
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
        throw ZapException.parsing('Request body cannot be ${body.runtimeType}');
      }
    }

    if (bodyBytes != null) {
      bodyStream = _trackProgress(bodyBytes, uploadProgress);
    }

    final uri = createUri(url, query);
    return Request<T>(
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

  void _setContentLength(Headers headers, int contentLength) {
    if (sendContentLength) {
      headers['content-length'] = '$contentLength';
    }
  }

  BodyByteStream _trackProgress(BodyBytes bodyBytes, Progress? uploadProgress) {
    var total = 0;
    var length = bodyBytes.length;

    var byteStream = Stream.fromIterable(bodyBytes.map((i) => [i])).transform<BodyBytes>(
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

  Future<Response<T>> perform<T>(Request<T> request, {bool useAuth = false, int requestNumber = 1, Headers? headers}) async {
    headers?.forEach((key, value) {
      request.headers[key] = value;
    });

    if (useAuth) {
      await modifier.authenticator!(request);
    }

    final req = await modifier.modifyRequest<T>(request);
    client.timeout = timeout;

    try {
      var res = await client.send<T>(req);
      var response = await modifier.modifyResponse<T>(req, res);

      if (response.status.isUnauthorized && modifier.authenticator != null && requestNumber <= maxAuthRetries) {
        return perform<T>(req, useAuth: true, requestNumber: requestNumber + 1, headers: req.headers);
      } else if (response.status.isUnauthorized) {
        if (!errorSafety) {
          throw ZapException.auth('An authentication error occurred. Please try again.');
        } else {
          return Response<T>(
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
      return handleException<T>(err, request);
    }
  }

  ResponseInterceptor<T>? _responseInterceptor<T>(ResponseInterceptor<T>? actual) {
    if (actual != null) return actual;

    if (defaultResponseInterceptor != null) {
      return (request, targetType, response) async {
        final result = await defaultResponseInterceptor!(request, targetType, response);
        return result as Response<T>?;
      };
    }

    return null;
  }

  Future<Request<T>> getRequestWithBody<T>(String? url, String method, {
    String? contentType,
    required RequestBody body,
    required RequestParam? query,
    ResponseDecoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    Progress? uploadProgress,
  }) {
    decoder ??= defaultDecoder as ResponseDecoder<T>?;
    responseInterceptor = _responseInterceptor(responseInterceptor);

    return requestWithBody<T>(url, contentType, body, method, query, decoder, responseInterceptor, uploadProgress);
  }

  Future<Request<T>> getRequestWithoutBody<T>(String? url, String method, {
    String? contentType,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    ResponseInterceptor<T>? responseInterceptor,
    int contentLength = 0,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    final Headers defHeaders = {};
    _setSimpleHeaders(defHeaders, contentType);
    final uri = createUri(url, query);

    final request = Request<T>(
      method: method,
      url: uri,
      headers: defHeaders,
      decoder: decoder ?? defaultDecoder as ResponseDecoder<T>?,
      responseInterceptor: _responseInterceptor(responseInterceptor),
      contentLength: contentLength,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    );

    return Future.value(request);
  }

  /// Handles exceptions and returns appropriate Response objects based on exception type
  Future<Response<T>> handleException<T>(Exception e, Request<T> request) async {
    ZapException zapException;
    
    // Convert to ZapException if not already
    if (e is ZapException) {
      zapException = e;
    } else {
      zapException = ZapException(e.toString(), request.url);
    }

    // Always notify the adviser about the exception
    _adviser.onException(zapException);

    // If errorSafety is disabled, rethrow the exception
    if (!errorSafety) {
      throw zapException;
    }

    // Return appropriate response based on exception type
    return _createResponseForException<T>(zapException, request);
  }

  /// Creates appropriate Response objects based on ZapException type
  Response<T> _createResponseForException<T>(ZapException exception, Request<T> request) {
    switch (exception.type) {
      case ExceptionType.timeout:
        return Response<T>(
          status: HttpStatus.REQUEST_TIMEOUT,
          message: 'Request timed out. Please try again.',
          request: request,
          headers: {'x-error-type': 'timeout'},
          body: null,
          bodyBytes: null,
          bodyString: 'Request timeout: ${exception.message}',
        );

      case ExceptionType.network:
        return Response<T>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Network connection unavailable. Check your internet connection.',
          request: request,
          headers: {'x-error-type': 'network'},
          body: null,
          bodyBytes: null,
          bodyString: 'Network error: ${exception.message}',
        );

      case ExceptionType.server:
        return Response<T>(
          status: HttpStatus.fromCode(exception.statusCode ?? 500),
          message: 'Server error occurred. Please try again later.',
          request: request,
          headers: {
            'x-error-type': 'server',
            'x-status-code': '${exception.statusCode ?? 500}'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Server error: ${exception.message}',
        );

      case ExceptionType.client:
        return Response<T>(
          status: HttpStatus.fromCode(exception.statusCode ?? 400),
          message: 'Client request error. Please check your request.',
          request: request,
          headers: {
            'x-error-type': 'client',
            'x-status-code': '${exception.statusCode ?? 400}'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Client error: ${exception.message}',
        );

      case ExceptionType.auth:
        return Response<T>(
          status: HttpStatus.UNAUTHORIZED,
          message: 'Authentication required. Please login again.',
          request: request,
          headers: {
            'x-error-type': 'auth',
            'x-auth-required': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Authentication error: ${exception.message}',
        );

      case ExceptionType.ssl:
        return Response<T>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Secure connection failed. Certificate or SSL error.',
          request: request,
          headers: {
            'x-error-type': 'ssl',
            'x-security-error': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'SSL error: ${exception.message}',
        );

      case ExceptionType.connection:
        return Response<T>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Cannot connect to server. Server may be down.',
          request: request,
          headers: {
            'x-error-type': 'connection',
            'x-retry-after': '30'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Connection error: ${exception.message}',
        );

      case ExceptionType.dns:
        return Response<T>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Cannot resolve server address. Check your DNS settings.',
          request: request,
          headers: {
            'x-error-type': 'dns',
            'x-dns-error': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'DNS error: ${exception.message}',
        );

      case ExceptionType.parsing:
        return Response<T>(
          status: HttpStatus.UNPROCESSABLE_ENTITY,
          message: 'Cannot parse server response. Invalid data format.',
          request: request,
          headers: {
            'x-error-type': 'parsing',
            'x-content-error': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Parsing error: ${exception.message}',
        );

      case ExceptionType.cancelled:
        return Response<T>(
          status: HttpStatus.REQUEST_CANCELLED,
          message: 'Request was cancelled.',
          request: request,
          headers: {
            'x-error-type': 'cancelled',
            'x-cancelled': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Request cancelled: ${exception.message}',
        );
      default:
        return Response<T>(
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          message: 'An unexpected error occurred. Please try again.',
          request: request,
          headers: {
            'x-error-type': 'unknown',
            'x-unexpected-error': 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Unknown error: ${exception.message}',
        );
    }
  }
}