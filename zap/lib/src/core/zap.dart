import '../exceptions/zap_exception.dart';
import '../http/client/zap_client.dart';
import '../http/request/request.dart';
import '../http/response/graphql_response.dart';
import '../http/response/response.dart';
import '../models/cancel_token.dart';
import '../models/zap_config.dart';
import 'zap_socket.dart';
import 'zap_interface.dart';
import '../definitions.dart';

/// Core configuration class for the Zap network client with cancellation support.
///
/// This class extends [ZapInterface] and acts as the base implementation for
/// HTTP and WebSocket operations in a unified, customizable way. It encapsulates
/// all client-level configuration settings like timeouts, certificate validation,
/// redirect policies, default headers, and request cancellation capabilities.
/// 
/// Key features:
/// - HTTP operations (GET, POST, PUT, PATCH, DELETE)
/// - WebSocket support
/// - GraphQL operations
/// - Request cancellation support
/// - Client lifecycle management
/// - Configuration management
/// 
/// Example usage:
/// ```dart
/// final zap = Zap(config: ZapConfig(baseUrl: 'https://api.example.com'));
/// 
/// // Simple request
/// final response = await zap.get<String>('/users');
/// 
/// // Request with cancellation
/// final cancelToken = CancelToken();
/// final future = zap.post<User>('/users', {'name': 'John'}, cancelToken: cancelToken);
/// 
/// // Cancel if needed
/// cancelToken.cancel('Operation aborted');
/// ```
class Zap extends ZapInterface {
  /// Creates a new instance of the Zap network client with optional configuration.
  ///
  /// - [config] contains all configuration options for the client including
  ///   timeouts, authentication, SSL settings, and base URL configuration.
  Zap({super.zapConfig, super.zapClient, super.zapSockets});

  /// Set of active cancel tokens for tracking ongoing requests
  final Set<CancelToken> _activeTokens = <CancelToken>{};

  @override
  List<ZapSocket> get sockets => zapSockets ??= <ZapSocket>[];

  @override
  Set<CancelToken> get activeTokens => _activeTokens;

  @override
  ZapConfig get config => zapConfig ?? ZapConfig();

  @override
  ZapClient get client => zapClient ??= ZapClient(
    userAgent: config.userAgent,
    sendUserAgent: config.sendUserAgent,
    timeout: config.timeout,
    followRedirects: config.followRedirects,
    maxRedirects: config.maxRedirects,
    maxAuthRetries: config.maxAuthRetries,
    allowAutoSignedCert: config.allowAutoSignedCert,
    baseUrl: config.baseUrl,
    trustedCertificates: config.trustedCertificates,
    withCredentials: config.withCredentials,
    findProxy: config.findProxy,
    errorSafety: config.errorSafety,
  );

  /// Registers a cancel token as active and sets up cleanup when cancelled.
  void _registerCancelToken(CancelToken? token) {
    if (token != null && !token.isCancelled) {
      _activeTokens.add(token);
      
      // Remove token from active set when it's cancelled
      token.future.then((_) {
        _activeTokens.remove(token);
      }).catchError((_) {
        _activeTokens.remove(token);
      });
    }
  }

  @override
  void cancelAllRequests([String reason = 'All requests cancelled']) {
    for (final token in _activeTokens) {
      token.cancel(reason);
    }
    _activeTokens.clear();
  }

  /// Executes a request with cancellation support.
  /// 
  /// This method wraps the actual request execution and handles cancellation
  /// at various stages of the request lifecycle.
  Future<Response<T>> _execute<T>(Future<Response<T>> Function() handler, CancelToken? token) async {
    _checkIfDisposed();
    
    // Register cancel token for tracking
    _registerCancelToken(token);
    
    // Check if cancelled before starting
    token?.throwIfCancelled();

    try {
      // Execute the request
      final response = await handler();
      
      // Check if cancelled after completion
      token?.throwIfCancelled();
      
      return response;
    } on ZapException {
      // Re-throw ZapExceptions (including cancellation exceptions)
      rethrow;
    } catch (_) {
      // Check if cancelled during error handling
      token?.throwIfCancelled();
      rethrow;
    }
  }

  @override
  Future<Response<T>> get<T>(String url, {
    Headers? headers,
    String? contentType,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.get<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> post<T>(String? url, RequestBody body, {
    String? contentType,
    Headers? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.post<T>(
        url,
        body: body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> put<T>(String url, RequestBody body, {
    String? contentType,
    Headers? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.put<T>(
        url,
        body: body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> patch<T>(String url, RequestBody body, {
    String? contentType,
    Headers? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.patch<T>(
        url,
        body: body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> request<T>(String url, String method, {
    RequestBody body,
    String? contentType,
    Headers? headers,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.request<T>(
        url,
        method,
        body: body,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> delete<T>(String url, {
    Headers? headers,
    String? contentType,
    RequestParam? query,
    ResponseDecoder<T>? decoder,
    CancelToken? cancelToken,
  }) {
    return _execute<T>(
      () => client.delete(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      ),
      cancelToken,
    );
  }

  @override
  Future<Response<T>> send<T>(Request<T> request, {CancelToken? cancelToken}) {
    return _execute<T>(() => client.send(request), cancelToken);
  }

  @override
  ZapSocket socket(String url, { Duration ping = const Duration(seconds: 5)}) {
    _checkIfDisposed(isHttp: false);

    final newSocket = ZapSocket(_concatUrl(url)!, ping: ping);
    sockets.add(newSocket);
    return newSocket;
  }

  String? _concatUrl(String? url) {
    if (url == null) {
      return config.baseUrl;
    }

    return config.baseUrl == null ? url : config.baseUrl! + url;
  }

  @override
  Future<GraphQLResponse<T>> query<T>(String query, {
    String? url,
    RequestParam? variables,
    Headers? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await post(
        url,
        {'query': query, 'variables': variables},
        headers: headers,
        cancelToken: cancelToken,
      );

      return GraphQLResponse.fromDynamic(res);
    } on Exception catch (err) {
      return GraphQLResponse.fromException(err);
    }
  }

  @override
  Future<GraphQLResponse<T>> mutation<T>(String mutation, {
    String? url,
    RequestParam? variables,
    Headers? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await post(
        url,
        {'query': mutation, 'variables': variables},
        headers: headers,
        cancelToken: cancelToken,
      );

      return GraphQLResponse.fromDynamic(res);
    } on Exception catch (err) {
      return GraphQLResponse.fromException(err);
    }
  }

  bool _isDisposed = false;

  @override
  bool get isDisposed => _isDisposed;

  void _checkIfDisposed({bool isHttp = true}) {
    if (_isDisposed) {
      throw ZapException('Can not emit events to disposed clients');
    }
  }

  @override
  void dispose() {
    // Cancel all active requests before disposal
    cancelAllRequests('Zap client disposed');
    
    if (zapSockets != null) {
      for (var socket in zapSockets!) {
        socket.close();
      }
      zapSockets!.clear();
      zapSockets = null;
    }

    if (zapClient != null) {
      zapClient!.close();
      zapClient = null;
    }

    zapConfig = null;
    _isDisposed = true;

    client.close();
    sockets.clear();
  }
}