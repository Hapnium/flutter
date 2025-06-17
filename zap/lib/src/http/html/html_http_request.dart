import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:tracing/tracing.dart' show console;
import 'package:web/web.dart' show XMLHttpRequest, Event;

import '../../definitions.dart';
import '../../enums/exception_type.dart';
import '../../enums/zap_provider.dart';
import '../../exceptions/zap_exception.dart';
import '../certificates/certificates.dart';
import '../request/request.dart';
import '../response/helpers.dart';
import '../response/response.dart';
import '../interface/http_request_interface.dart';
import '../utils/body_decoder.dart';
import '../utils/http_status.dart';

/// A `dart:web` implementation of [HttpRequestInterface] with comprehensive error handling.
class HttpRequestImplementation implements HttpRequestInterface {
  /// Creates a [HttpRequestImplementation]
  HttpRequestImplementation({
    bool allowAutoSignedCert = true,
    List<ZapTrustedCertificate>? trustedCertificates,
    this.withCredentials = false,
    ProxyFinder? findProxy,
  });

  final _xhrs = <XMLHttpRequest>{};
  final bool withCredentials;

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    if (_isClosed) {
      throw ZapException.connection('HTTP request failed. Client is already closed.', request.url);
    }

    var bytes = await request.bodyBytes.toBytes();
    XMLHttpRequest xhr = XMLHttpRequest();

    xhr.timeout = (timeout ?? Duration.zero).inMilliseconds;
    
    try {
      xhr.open(request.method, '${request.url}', true);
    } catch (e) {
      throw ZapException.network('Failed to open connection: $e', request.url);
    }

    _xhrs.add(xhr);

    xhr.responseType = 'arraybuffer';
    xhr.withCredentials = withCredentials;

    // Set headers with comprehensive error handling
    request.headers.forEach((key, value) {
      try {
        xhr.setRequestHeader(key, value);
      } catch (e) {
        // Some headers might be restricted by CORS or browser security
        console.log('Warning: Could not set header $key: $e');
      }
    });

    var completer = Completer<Response<T>>();

    // Handle successful response
    xhr.onload = (Event event) {
      _handleResponse(xhr, request, completer);
    }.toJS;

    // Handle network errors
    xhr.onerror = (Event event) {
      if (!completer.isCompleted) {
        _handleError(xhr, request, completer);
      }
    }.toJS;

    // Handle timeout
    xhr.ontimeout = (Event event) {
      if (!completer.isCompleted) {
        final timeoutDuration = timeout?.inMilliseconds ?? xhr.timeout;
        completer.completeError(
          ZapException.timeout(
            'Request timeout after ${timeoutDuration}ms',
            request.url,
            {'timeoutMs': timeoutDuration}
          ),
          StackTrace.current,
        );
      }
    }.toJS;

    // Handle abort
    xhr.onabort = (Event event) {
      if (!completer.isCompleted) {
        completer.completeError(
          ZapException.cancelled('Request aborted', request.url),
          StackTrace.current,
        );
      }
    }.toJS;

    // Send the request with error handling
    try {
      if (bytes.isNotEmpty) {
        xhr.send(bytes.toJS);
      } else {
        xhr.send();
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(
          ZapException.network('Failed to send request: $e', request.url),
          StackTrace.current,
        );
      }
    }

    try {
      return await completer.future;
    } finally {
      _xhrs.remove(xhr);
    }
  }

  void _handleError(XMLHttpRequest xhr, Request request, Completer completer) {
    String errorMessage;
    ExceptionType errorType;
    Map<String, dynamic> details = {
      'readyState': xhr.readyState,
      'status': xhr.status,
      'statusText': xhr.statusText,
    };

    if (xhr.status == 0) {
      // Status 0 usually indicates network issues or CORS problems
      if (xhr.readyState == 4) {
        // Request completed but with network error
        errorMessage = 'Network error - unable to connect to server';
        errorType = ExceptionType.network;
      } else {
        // CORS or other browser security restriction
        errorMessage = 'CORS error or network connectivity issue';
        errorType = ExceptionType.network;
        details['corsIssue'] = true;
      }
    } else if (xhr.status >= 400 && xhr.status < 500) {
      // Client errors
      errorMessage = 'Client error ${xhr.status}: ${xhr.statusText}';
      errorType = xhr.status == 401 || xhr.status == 403 
          ? ExceptionType.auth 
          : ExceptionType.client;
    } else if (xhr.status >= 500) {
      // Server errors
      errorMessage = 'Server error ${xhr.status}: ${xhr.statusText}';
      errorType = ExceptionType.server;
    } else {
      // Unknown error
      errorMessage = 'Unknown XMLHttpRequest error';
      errorType = ExceptionType.unknown;
    }

    completer.completeError(
      ZapException(errorMessage, request.url, errorType, xhr.status, details),
      StackTrace.current,
    );
  }

  void _handleResponse<T>(XMLHttpRequest xhr, Request<T> request, Completer<Response<T>> completer) async {
    try {
      // Check for HTTP error status codes even in onload
      if (xhr.status >= 400) {
        _handleError(xhr, request, completer);
        return;
      }

      // Handle response data
      Uint8List bodyBytes;
      if (xhr.response != null) {
        if (xhr.responseType == 'arraybuffer') {
          try {
            final jsArrayBuffer = xhr.response as JSArrayBuffer;
            bodyBytes = jsArrayBuffer.toDart.asUint8List();
          } catch (e) {
            throw ZapException.parsing('Failed to parse arraybuffer response: $e', request.url);
          }
        } else {
          // Fallback to responseText
          try {
            final responseText = xhr.responseText;
            bodyBytes = Uint8List.fromList(responseText.codeUnits);
          } catch (e) {
            throw ZapException.parsing('Failed to parse text response: $e', request.url);
          }
        }
      } else {
        bodyBytes = Uint8List(0);
      }

      final bodyStream = Stream.fromIterable([bodyBytes]);

      if (request.responseInterceptor != null) {
        throw ZapException('Response interception not implemented for web yet!', request.url);
      }

      final responseHeaders = _parseResponseHeaders(xhr);
      final stringBody = await bodyBytesToString(bodyStream, responseHeaders);
      final contentType = responseHeaders['content-type'] ?? 'application/json';

      final body = bodyDecoded<T>(
        request, 
        stringBody, 
        contentType, 
        HttpStatus.fromCode(xhr.status)
      );

      final response = Response<T>(
        bodyBytes: bodyStream,
        status: HttpStatus.fromCode(xhr.status),
        message: xhr.statusText,
        request: request,
        headers: responseHeaders,
        body: body,
        bodyString: stringBody,
        provider: ZapProvider.web,
      );

      if (!completer.isCompleted) {
        completer.complete(response);
      }
    } catch (e, stackTrace) {
      if (!completer.isCompleted) {
        if (e is ZapException) {
          completer.completeError(e, stackTrace);
        } else {
          completer.completeError(
            ZapException.parsing('Error processing response: $e', request.url),
            stackTrace,
          );
        }
      }
    }
  }

  Headers _parseResponseHeaders(XMLHttpRequest xhr) {
    var headers = <String, String>{};
    try {
      var headersString = xhr.getAllResponseHeaders();
      if (headersString.isNotEmpty) {
        var headersList = headersString.split('\r\n');
        for (var header in headersList) {
          if (header.isEmpty) continue;

          var splitIdx = header.indexOf(': ');
          if (splitIdx == -1) continue;

          var key = header.substring(0, splitIdx).toLowerCase();
          var value = header.substring(splitIdx + 2);
          if (headers.containsKey(key)) {
            headers[key] = '${headers[key]}, $value';
          } else {
            headers[key] = value;
          }
        }
      }
    } catch (e) {
      console.log('Warning: Could not parse response headers: $e');
    }
    return headers;
  }

  @override
  void close() {
    _isClosed = true;
    for (var xhr in _xhrs) {
      xhr.abort();
    }
    _xhrs.clear();
  }

  @override
  Duration? timeout;
  bool _isClosed = false;
}
