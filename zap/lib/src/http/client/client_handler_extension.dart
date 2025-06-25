part of 'zap_client.dart';

extension ClientHandlerExtension on ClientHandler {
  ControllerAdvice get _adviser => controllerAdvice ?? ControllerAdvice();

  /// Create a request with body
  /// 
  /// This method is used to create a request with a body, which is useful for
  /// making HTTP requests with a body, such as POST or PUT requests.
  /// 
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [body]: The body payload for the request.
  /// - [method]: HTTP method (e.g., 'GET', 'POST', 'PUT', 'DELETE').
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  /// 
  /// Returns:
  ///   A [Request] of type [T] representing the server's reply.
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
      headers[HttpHeaders.USER_AGENT] = userAgent;
    }

    if (body is FormData) {
      // Process FormData asynchronously to avoid blocking
      bodyBytes = await _processFormDataAsync(body);
      headers[HttpHeaders.CONTENT_LENGTH] = bodyBytes.length.toString();
      headers[HttpHeaders.CONTENT_TYPE] = 
          HttpContentType.MULTIPARET_FORM_DATA_WITH_BOUNDARY(body.boundary);
    } else if (contentType != null && 
               contentType.toLowerCase() == HttpContentType.APPLICATION_X_WWW_FORM_URLENCODED && 
               body is Map) {
      bodyBytes = await _processFormUrlEncodedAsync(body as RequestParam);
      _setContentLength(headers, bodyBytes.length);
      headers[HttpHeaders.CONTENT_TYPE] = contentType;
    } else if (body is Map || body is List) {
      bodyBytes = await _processJsonAsync(body);
      _setContentLength(headers, bodyBytes.length);
      headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
    } else if (body is String) {
      bodyBytes = await _processStringAsync(body);
      _setContentLength(headers, bodyBytes.length);
      headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
    } else if (body == null) {
      _setContentLength(headers, 0);
      headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
    } else {
      if (!errorSafety) {
        throw ZapException.parsing('Request body cannot be ${body.runtimeType}');
      }
    }

    if (bodyBytes != null) {
      bodyStream = _trackProgressAsync(bodyBytes, uploadProgress);
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

  /// Process FormData without blocking UI
  Future<BodyBytes> _processFormDataAsync(FormData formData) async {
    final completer = Completer<BodyBytes>();
    
    // Process in background
    scheduleMicrotask(() async {
      try {
        final result = await formData.toBytes();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });
    
    return completer.future;
  }

  /// Process JSON without blocking UI
  Future<BodyBytes> _processJsonAsync(dynamic body) async {
    final completer = Completer<BodyBytes>();
    
    scheduleMicrotask(() {
      try {
        var jsonString = json.encode(body);
        var result = utf8.encode(jsonString);
        completer.complete(Uint8List.fromList(result));
      } catch (e) {
        completer.completeError(e);
      }
    });
    
    return completer.future;
  }

  /// Process form URL encoded without blocking UI
  Future<BodyBytes> _processFormUrlEncodedAsync(RequestParam body) async {
    final completer = Completer<BodyBytes>();
    
    scheduleMicrotask(() {
      try {
        var parts = <String>[];
        body.forEach((key, value) {
          parts.add('${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}');
        });
        var formData = parts.join('&');
        var result = utf8.encode(formData);
        completer.complete(Uint8List.fromList(result));
      } catch (e) {
        completer.completeError(e);
      }
    });
    
    return completer.future;
  }

  /// Process string without blocking UI
  Future<BodyBytes> _processStringAsync(String body) async {
    final completer = Completer<BodyBytes>();
    
    scheduleMicrotask(() {
      try {
        var result = utf8.encode(body);
        completer.complete(Uint8List.fromList(result));
      } catch (e) {
        completer.completeError(e);
      }
    });
    
    return completer.future;
  }

  /// Track progress without blocking UI
  BodyByteStream _trackProgressAsync(BodyBytes bodyBytes, Progress? uploadProgress) {
    var total = 0;
    var length = bodyBytes.length;
    var lastProgressTime = DateTime.now();

    var byteStream = Stream.fromIterable(bodyBytes.map((i) => [i]))
        .transform<BodyBytes>(
      StreamTransformer.fromHandlers(handleData: (data, sink) {
        total += data.length;
        
        // Throttle progress updates to avoid UI spam
        final now = DateTime.now();
        if (uploadProgress != null && 
            now.difference(lastProgressTime).inMilliseconds > 50) {
          var percent = total / length * 100;
          scheduleMicrotask(() => uploadProgress(percent));
          lastProgressTime = now;
        }
        
        sink.add(data);
      }),
    );

    return byteStream;
  }
  // Future<Request<T>> requestWithBody<T>(
  //   String? url,
  //   String? contentType,
  //   RequestBody body,
  //   String method,
  //   RequestParam? query,
  //   ResponseDecoder<T>? decoder,
  //   ResponseInterceptor<T>? responseInterceptor,
  //   Progress? uploadProgress,
  // ) async {
  //   BodyBytes? bodyBytes;
  //   BodyByteStream? bodyStream;
  //   final Headers headers = {};

  //   if (sendUserAgent) {
  //     headers[HttpHeaders.USER_AGENT] = userAgent;
  //   }

  //   if (body is FormData) {
  //     bodyBytes = await body.toBytes();
  //     headers[HttpHeaders.CONTENT_LENGTH] = bodyBytes.length.toString();
  //     headers[HttpHeaders.CONTENT_TYPE] = HttpContentType.MULTIPARET_FORM_DATA_WITH_BOUNDARY(body.boundary);
  //   } else if (contentType != null && contentType.toLowerCase() == HttpContentType.APPLICATION_X_WWW_FORM_URLENCODED && body is Map) {
  //     var parts = [];
  //     (body as RequestParam).forEach((key, value) {
  //       parts.add('${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}');
  //     });
  //     var formData = parts.join('&');
  //     bodyBytes = utf8.encode(formData);
  //     _setContentLength(headers, bodyBytes.length);
  //     headers[HttpHeaders.CONTENT_TYPE] = contentType;
  //   } else if (body is Map || body is List) {
  //     var jsonString = json.encode(body);
  //     bodyBytes = utf8.encode(jsonString);
  //     _setContentLength(headers, bodyBytes.length);
  //     headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
  //   } else if (body is String) {
  //     bodyBytes = utf8.encode(body);
  //     _setContentLength(headers, bodyBytes.length);

  //     headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
  //   } else if (body == null) {
  //     _setContentLength(headers, 0);
  //     headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
  //   } else {
  //     if (!errorSafety) {
  //       throw ZapException.parsing('Request body cannot be ${body.runtimeType}');
  //     }
  //   }

  //   if (bodyBytes != null) {
  //     bodyStream = _trackProgress(bodyBytes, uploadProgress);
  //   }

  //   final uri = createUri(url, query);
  //   return Request<T>(
  //     method: method,
  //     url: uri,
  //     headers: headers,
  //     bodyBytes: bodyStream,
  //     contentLength: bodyBytes?.length ?? 0,
  //     followRedirects: followRedirects,
  //     maxRedirects: maxRedirects,
  //     decoder: decoder,
  //     responseInterceptor: responseInterceptor
  //   );
  // }

  /// Sets the content length header if sendContentLength is true.
  void _setContentLength(Headers headers, int contentLength) {
    if (sendContentLength) {
      headers[HttpHeaders.CONTENT_LENGTH] = '$contentLength';
    }
  }

  /// Tracks progress of a request.
  // BodyByteStream _trackProgress(BodyBytes bodyBytes, Progress? uploadProgress) {
  //   var total = 0;
  //   var length = bodyBytes.length;

  //   var byteStream = Stream.fromIterable(bodyBytes.map((i) => [i])).transform<BodyBytes>(
  //     StreamTransformer.fromHandlers(handleData: (data, sink) {
  //       total += data.length;
  //       if (uploadProgress != null) {
  //         var percent = total / length * 100;
  //         uploadProgress(percent);
  //       }
  //       sink.add(data);
  //     }),
  //   );

  //   return byteStream;
  // }

  /// Sets simple headers for a request.
  void _setSimpleHeaders(Headers headers, String? contentType) {
    headers[HttpHeaders.CONTENT_TYPE] = contentType ?? defaultContentType;
    if (sendUserAgent) {
      headers[HttpHeaders.USER_AGENT] = userAgent;
    }
  }

  /// Performs a request and returns a response.
  /// 
  /// This method is used to perform a request and returns a response.
  /// 
  /// Parameters:
  /// - [request]: The request to perform.
  /// - [useAuth]: Whether to use authentication.
  /// - [requestNumber]: The number of requests made.
  /// - [headers]: Additional HTTP headers.
  /// 
  /// Returns:
  ///   A [Response] of type [T] representing the server's reply.
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

  /// Returns a response interceptor.
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

  /// Returns a request with body.
  /// 
  /// This method is used to create a request with a body, which is useful for
  /// making HTTP requests with a body, such as POST or PUT requests.
  /// 
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [method]: HTTP method (e.g., 'GET', 'POST', 'PUT', 'DELETE').
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [body]: The body payload for the request.
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [uploadProgress]: Callback for monitoring upload progress.
  /// 
  /// Returns:
  ///   A [Request] of type [T] representing the server's reply.
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

  /// Returns a request without body.
  /// 
  /// This method is used to create a request without a body, which is useful for
  /// making HTTP requests without a body, such as GET or DELETE requests.
  /// 
  /// Parameters:
  /// - [url]: The target endpoint.
  /// - [method]: HTTP method (e.g., 'GET', 'POST', 'PUT', 'DELETE').
  /// - [contentType]: MIME type of the request body (defaults to JSON).
  /// - [query]: Query parameters appended to the URL.
  /// - [decoder]: Optional function to parse the response body.
  /// - [responseInterceptor]: Optional hook for inspecting or altering the response.
  /// - [contentLength]: The length of the request body.
  /// - [followRedirects]: Whether to follow redirects.
  /// - [maxRedirects]: The maximum number of redirects to follow.
  /// 
  /// Returns:
  ///   A [Request] of type [T] representing the server's reply.
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

  /// Handles exceptions and returns appropriate Response objects based on exception type.
  /// 
  /// This method is used to handle exceptions and returns appropriate Response objects based on exception type.
  /// 
  /// Parameters:
  /// - [e]: The exception to handle.
  /// - [request]: The request that caused the exception.
  /// 
  /// Returns:
  ///   A [Response] of type [T] representing the server's reply.
  Future<Response<T>> handleException<T>(Exception e, Request<T> request) async {
    ZapException zapException;
    
    // Convert to ZapException if not already
    if (e is ZapException) {
      zapException = e;
    } else {
      zapException = ZapException(e.toString(), request.url);
    }

    // Always tappy the adviser about the exception
    _adviser.onException(zapException);

    // If errorSafety is disabled, rethrow the exception
    if (!errorSafety) {
      throw zapException;
    }

    // Return appropriate response based on exception type
    return _createResponseForException<T>(zapException, request);
  }

  /// Creates appropriate Response objects based on ZapException type.
  /// 
  /// This method is used to create appropriate Response objects based on ZapException type.
  /// 
  /// Parameters:
  /// - [exception]: The exception to handle.
  /// - [request]: The request that caused the exception.
  /// 
  /// Returns:
  ///   A [Response] of type [T] representing the server's reply.
  Response<T> _createResponseForException<T>(ZapException exception, Request<T> request) {
    switch (exception.type) {
      case ExceptionType.timeout:
        return Response<T>(
          status: HttpStatus.REQUEST_TIMEOUT,
          message: 'Request timed out. Please try again.',
          request: request,
          headers: {
            HttpHeaders.X_ERROR_TYPE: 'timeout'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Request timeout: ${exception.message}',
        );

      case ExceptionType.network:
        return Response<T>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Network connection unavailable. Check your internet connection.',
          request: request,
          headers: {
            HttpHeaders.X_ERROR_TYPE: 'network'
          },
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
            HttpHeaders.X_ERROR_TYPE: 'server',
            HttpHeaders.X_STATUS_CODE: '${exception.statusCode ?? 500}'
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
            HttpHeaders.X_ERROR_TYPE: 'client',
            HttpHeaders.X_STATUS_CODE: '${exception.statusCode ?? 400}'
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
            HttpHeaders.X_ERROR_TYPE: 'auth',
            HttpHeaders.X_AUTH_REQUIRED: 'true'
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
            HttpHeaders.X_ERROR_TYPE: 'ssl',
            HttpHeaders.X_SECURITY_ERROR: 'true'
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
            HttpHeaders.X_ERROR_TYPE: 'connection',
            HttpHeaders.X_RETRY_AFTER: '30'
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
            HttpHeaders.X_ERROR_TYPE: 'dns',
            HttpHeaders.X_DNS_ERROR: 'true'
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
            HttpHeaders.X_ERROR_TYPE: 'parsing',
            HttpHeaders.X_CONTENT_ERROR: 'true'
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
            HttpHeaders.X_ERROR_TYPE: 'cancelled',
            HttpHeaders.X_CANCELLED: 'true'
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
            HttpHeaders.X_ERROR_TYPE: 'unknown',
            HttpHeaders.X_UNEXPECTED_ERROR: 'true'
          },
          body: null,
          bodyBytes: null,
          bodyString: 'Unknown error: ${exception.message}',
        );
    }
  }
}