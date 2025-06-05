import 'http/client/zap_client.dart';
import 'exceptions/exceptions.dart';
import 'http/request/request.dart';
import 'http/response/graphql_response.dart';
import 'http/response/response.dart';
import 'models/zap_cancel_token.dart';
import 'models/zap_config.dart';
import 'zap_socket.dart';
import 'zap_interface.dart';
import 'definitions.dart';

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
/// final cancelToken = ZapCancelToken();
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
  Zap({this.config});

  /// The configuration of the [ZapClient] and [Zap]
  ZapConfig? config;

  /// Internal reference to the HTTP client instance.
  ///
  /// Lazily initialized or injected.
  ZapClient? _client;

  /// Internal list of active WebSocket connections.
  ///
  /// Managed internally by the [ZapInterface] implementation.
  List<ZapSocket>? _sockets;

  /// Set of active cancel tokens for tracking ongoing requests
  final Set<ZapCancelToken> _activeTokens = <ZapCancelToken>{};

  @override
  List<ZapSocket> get sockets => _sockets ??= <ZapSocket>[];

  ZapConfig get _config => config ?? ZapConfig();

  @override
  ZapClient get client => _client ??= ZapClient(
    userAgent: _config.userAgent,
    sendUserAgent: _config.sendUserAgent,
    timeout: _config.timeout,
    followRedirects: _config.followRedirects,
    maxRedirects: _config.maxRedirects,
    maxAuthRetries: _config.maxAuthRetries,
    allowAutoSignedCert: _config.allowAutoSignedCert,
    baseUrl: _config.baseUrl,
    trustedCertificates: _config.trustedCertificates,
    withCredentials: _config.withCredentials,
    findProxy: _config.findProxy
  );

  /// Registers a cancel token as active and sets up cleanup when cancelled.
  void _registerCancelToken(ZapCancelToken? token) {
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

  /// Cancels all active requests.
  /// 
  /// This method cancels all ongoing requests with the specified reason.
  /// Useful for scenarios like client shutdown or global request cancellation.
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
  Future<ZapResponse<T>> _executeWithCancellation<T>(Future<ZapResponse<T>> Function() requestExecutor, ZapCancelToken? cancelToken) async {
    // Register cancel token for tracking
    _registerCancelToken(cancelToken);
    
    // Check if cancelled before starting
    cancelToken?.throwIfCancelled();

    try {
      // Execute the request
      final response = await requestExecutor();
      
      // Check if cancelled after completion
      cancelToken?.throwIfCancelled();
      
      return response;
    } on ZapException {
      // Re-throw ZapExceptions (including cancellation exceptions)
      rethrow;
    } catch (_) {
      // Check if cancelled during error handling
      cancelToken?.throwIfCancelled();
      rethrow;
    }
  }

  @override
  Future<ZapResponse<T>> get<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> post<T>(String? url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> put<T>(String url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> patch<T>(String url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> request<T>(String url, String method, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> delete<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    ZapCancelToken? cancelToken,
  }) {
    _checkIfDisposed();
    return _executeWithCancellation<T>(
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
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request, {ZapCancelToken? cancelToken}) {
    return _executeWithCancellation<T>(
      () => client.send(request),
      cancelToken,
    );
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
      return _config.baseUrl;
    }

    return _config.baseUrl == null ? url : _config.baseUrl! + url;
  }

  @override
  Future<GraphQLResponse<T>> query<T>(
    String query, {
    String? url,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    ZapCancelToken? cancelToken,
  }) async {
    try {
      final res = await post(
        url,
        {'query': query, 'variables': variables},
        headers: headers,
        cancelToken: cancelToken,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        return GraphQLResponse<T>(
          graphQLErrors: listError.map((e) => GraphQLError(
            code: (e['extensions'] != null ? e['extensions']['code'] ?? '' : '').toString(),
            message: (e['message'] ?? '').toString(),
          )).toList()
        );
      }
      return GraphQLResponse<T>.fromResponse(res);
    } on Exception catch (err) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          code: null,
          message: err.toString(),
        )
      ]);
    }
  }

  @override
  Future<GraphQLResponse<T>> mutation<T>(
    String mutation, {
    String? url,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    ZapCancelToken? cancelToken,
  }) async {
    try {
      final res = await post(
        url,
        {'query': mutation, 'variables': variables},
        headers: headers,
        cancelToken: cancelToken,
      );

      final listError = res.body['errors'];
      if ((listError is List) && listError.isNotEmpty) {
        return GraphQLResponse<T>(
          graphQLErrors: listError.map((e) => GraphQLError(
            code: e['extensions']['code']?.toString(),
            message: e['message']?.toString(),
          )).toList()
        );
      }
      return GraphQLResponse<T>.fromResponse(res);
    } on Exception catch (err) {
      return GraphQLResponse<T>(graphQLErrors: [
        GraphQLError(
          code: null,
          message: err.toString(),
        )
      ]);
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
    
    if (_sockets != null) {
      for (var socket in sockets) {
        socket.close();
      }
      _sockets?.clear();
      sockets = null;
    }
    if (_client != null) {
      client.close();
      _client = null;
    }
    _isDisposed = true;
  }
}