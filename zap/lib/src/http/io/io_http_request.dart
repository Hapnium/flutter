import 'dart:async';
import 'dart:io' as io;

import '../../definitions.dart';
import '../../enums/exception_type.dart';
import '../../enums/zap_provider.dart';
import '../../exceptions/zap_exception.dart';
import '../certificates/certificates.dart';
import '../interface/http_request_interface.dart';
import '../request/request.dart';
import '../response/helpers.dart';
import '../response/response.dart';
import '../utils/body_decoder.dart';
import '../utils/http_status.dart';
import 'io_http_response.dart';

/// A `dart:io` implementation of [HttpRequestInterface] with comprehensive error handling.
class HttpRequestImplementation extends HttpRequestInterface {
  io.HttpClient? _httpClient;
  io.SecurityContext? _securityContext;

  HttpRequestImplementation({
    bool allowAutoSignedCert = true,
    List<ZapTrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    ProxyFinder? findProxy,
  }) {
    _httpClient = io.HttpClient();
    if (trustedCertificates != null) {
      _securityContext = io.SecurityContext();
      for (final trustedCertificate in trustedCertificates) {
        _securityContext!.setTrustedCertificatesBytes(List.from(trustedCertificate.bytes));
      }
    }

    _httpClient = io.HttpClient(context: _securityContext);
    _httpClient!.badCertificateCallback = (_, __, ___) => allowAutoSignedCert;
    _httpClient!.findProxy = findProxy;
  }

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    var stream = request.bodyBytes.asBroadcastStream();
    io.HttpClientRequest? ioRequest;

    try {
      _httpClient!.connectionTimeout = timeout;
      ioRequest = (await _httpClient!.openUrl(request.method, request.url))
        ..followRedirects = request.followRedirects
        ..persistentConnection = request.persistentConnection
        ..maxRedirects = request.maxRedirects
        ..contentLength = request.contentLength ?? -1;
      request.headers.forEach(ioRequest.headers.set);

      var response = timeout == null
          ? await stream.pipe(ioRequest) as io.HttpClientResponse
          : await stream.pipe(ioRequest).timeout(timeout!) as io.HttpClientResponse;

      var headers = <String, String>{};
      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });

      final bodyBytes = (response);

      final interceptionResponse = await request.responseInterceptor?.call(request, T, IOHttpResponse(response: response));
      if (interceptionResponse != null) return interceptionResponse;

      final stringBody = await bodyBytesToString(bodyBytes, headers);

      final body = bodyDecoded<T>(
        request,
        stringBody,
        response.headers.contentType?.mimeType,
        HttpStatus.fromCode(response.statusCode)
      );

      return Response(
        headers: headers,
        request: request,
        status: HttpStatus.fromCode(response.statusCode),
        message: response.reasonPhrase,
        bodyBytes: bodyBytes,
        body: body,
        bodyString: stringBody,
        provider: ZapProvider.io,
      );
    } on TimeoutException catch (_) {
      ioRequest?.abort();
      throw ZapException.timeout(
        'Request timed out after ${timeout?.inMilliseconds ?? 'unknown'}ms',
        request.url,
        {'timeoutMs': timeout?.inMilliseconds}
      );
    } on io.SocketException catch (e) {
      throw _handleSocketException(e, request.url);
    } on io.HttpException catch (e) {
      throw _handleHttpException(e, request.url);
    } on io.HandshakeException catch (e) {
      throw ZapException.ssl('SSL handshake failed: ${e.message}', request.url);
    } on io.CertificateException catch (e) {
      throw ZapException.ssl('Certificate error: ${e.message}', request.url);
    } on FormatException catch (e) {
      throw ZapException.parsing('Invalid URL or data format: ${e.message}', request.url);
    } catch (e, stackTrace) {
      throw ZapException(
        'Unexpected error: $e',
        request.url,
        ExceptionType.unknown,
        null,
        {'originalError': e.toString()},
        e is Exception ? e : null,
        stackTrace,
      );
    }
  }

  Exception _handleSocketException(io.SocketException e, Uri? uri) {
    Map<String, dynamic> details = {
      'osError': e.osError?.toString(),
      'address': e.address?.toString(),
      'port': e.port,
    };

    switch (e.osError?.errorCode) {
      case 61: // Connection refused (macOS/Linux)
      case 10061: // Connection refused (Windows)
        return ZapException.connection('Connection refused - server may be down', uri, details);
      case 64: // Host is down (macOS/Linux)
      case 10064: // Host is down (Windows)
        return ZapException.network('Host is unreachable or down', uri, details);
      case 65: // No route to host (macOS/Linux)
      case 10065: // No route to host (Windows)
        return ZapException.network('No route to host', uri, details);
      case 8: // Name resolution failed (macOS/Linux)
      case 11001: // Host not found (Windows)
        return ZapException.dns('DNS resolution failed - host not found', uri, details);
      case 60: // Operation timed out (macOS/Linux)
      case 10060: // Connection timed out (Windows)
        return ZapException.timeout('Connection timed out', uri, details);
      default:
        return ZapException.network('Network error: ${e.message}', uri, details);
    }
  }

  Exception _handleHttpException(io.HttpException e, Uri? uri) {
    Map<String, dynamic> details = {'originalMessage': e.message};
    
    if (e.message.contains('Connection closed')) {
      return ZapException.connection('Connection closed by server', uri, details);
    } else if (e.message.contains('redirect')) {
      return ZapException.client('Too many redirects or redirect loop', 0, uri, details);
    } else {
      return ZapException.network('HTTP protocol error: ${e.message}', uri, details);
    }
  }

  /// Closes the HttpClient.
  @override
  void close() {
    if (_httpClient != null) {
      _httpClient!.close(force: true);
      _httpClient = null;
    }
  }
}