import 'http/client/zap_client.dart';
import 'http/request/request.dart';
import 'http/response/graphql_response.dart';
import 'http/response/response.dart';
import 'models/zap_cancel_token.dart';
import 'models/zap_config.dart';
import 'zap_socket.dart';
import 'zap_lifecycle.dart';
import 'definitions.dart';

/// Interface defining the contract for Zap HTTP and WebSocket operations with cancellation support.
/// 
/// This interface ensures consistent method signatures across different
/// implementations of the Zap client, including request cancellation capabilities.
///
/// It mixes in [ZapLifecycle] to include lifecycle methods such as `onInit`
/// and `onDispose` if implemented.
abstract class ZapInterface with ZapLifecycle {
  /// The configuration of the [ZapClient] and [ZapImplementation]
  ZapConfig? zapConfig;

  /// Internal reference to the HTTP client instance.
  ///
  /// Lazily initialized or injected.
  ZapClient? zapClient;

  /// Internal list of active WebSocket connections.
  ///
  /// Managed internally by the [ZapInterface] implementation.
  List<ZapSocket>? zapSockets;

  /// A constructor for the [ZapInterface] class.
  ///
  /// - [zapConfig]: The configuration of the [ZapClient] and [ZapImplementation]
  /// - [zapClient]: The HTTP client instance
  /// - [zapSockets]: The list of active WebSocket connections
  ZapInterface({this.zapConfig, this.zapClient, this.zapSockets});

  /// A list of active Socket connections managed by the interface.
  ///
  /// This can be used for tracking or mass-disposal of sockets.
  List<ZapSocket>? sockets;

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
  ZapClient get client;

  /// Set of active cancel tokens for tracking ongoing requests
  /// 
  /// This can be used for canceling all ongoing requests. [ZapCancelToken] 
  /// is used to cancel individual requests.
  Set<ZapCancelToken> get activeTokens;

  /// The configuration of the [ZapClient] and [ZapImplementation]
  ZapConfig get config;

  /// Cancels all active requests.
  /// 
  /// This method cancels all ongoing requests with the specified reason.
  /// Useful for scenarios like client shutdown or global request cancellation.
  void cancelAllRequests([String reason = 'All requests cancelled']);

  /// Performs a GET request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> get<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    ZapCancelToken? cancelToken,
  });

  /// Performs a POST request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [body]: The request body
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [uploadProgress]: Optional upload progress callback
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> post<T>(String? url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  });

  /// Performs a PUT request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [body]: The request body
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [uploadProgress]: Optional upload progress callback
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> put<T>(String url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  });

  /// Performs a PATCH request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [body]: The request body
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [uploadProgress]: Optional upload progress callback
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> patch<T>(String url, dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  });

  /// Performs a DELETE request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> delete<T>(String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    ZapCancelToken? cancelToken,
  });

  /// Performs a custom HTTP request with optional cancellation support.
  /// 
  /// - [url]: The URL to request
  /// - [method]: The HTTP method
  /// - [body]: Optional request body
  /// - [headers]: Optional HTTP headers
  /// - [contentType]: Optional content type
  /// - [query]: Optional query parameters
  /// - [decoder]: Optional response decoder
  /// - [uploadProgress]: Optional upload progress callback
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> request<T>(String url, String method, {
    dynamic body,
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    ResponseDecoder<T>? decoder,
    Progress? uploadProgress,
    ZapCancelToken? cancelToken,
  });

  /// Sends a pre-built request with optional cancellation support.
  /// 
  /// - [request]: The request to send
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [ZapResponse] with the requested data.
  /// Throws [ZapException] if the request is cancelled.
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request, {ZapCancelToken? cancelToken});

  /// Creates a WebSocket connection.
  /// 
  /// - [url]: The WebSocket URL
  /// - [ping]: Ping interval for keep-alive
  /// 
  /// Returns a [ZapSocket] instance.
  ZapSocket socket(String url, {Duration ping = const Duration(seconds: 5)});

  /// Performs a GraphQL query with optional cancellation support.
  /// 
  /// - [query]: The GraphQL query string
  /// - [url]: Optional URL override
  /// - [variables]: Optional query variables
  /// - [headers]: Optional HTTP headers
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [GraphQLResponse] with the query result.
  /// Throws [ZapException] if the request is cancelled.
  Future<GraphQLResponse<T>> query<T>(
    String query, {
    String? url,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    ZapCancelToken? cancelToken,
  });

  /// Performs a GraphQL mutation with optional cancellation support.
  /// 
  /// - [mutation]: The GraphQL mutation string
  /// - [url]: Optional URL override
  /// - [variables]: Optional mutation variables
  /// - [headers]: Optional HTTP headers
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [GraphQLResponse] with the mutation result.
  /// Throws [ZapException] if the request is cancelled.
  Future<GraphQLResponse<T>> mutation<T>(
    String mutation, {
    String? url,
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    ZapCancelToken? cancelToken,
  });

  /// Cleans up and releases any resources held by the instance.
  ///
  /// This method is typically used to close open WebSocket connections,
  /// cancel timers, and nullify any long-lived references to prevent memory leaks.
  /// After calling `dispose`, the instance should not be used again.
  void dispose();

  /// Indicates whether the instance has been disposed.
  ///
  /// Returns `true` if [dispose] has been called and the object is no longer
  /// considered active. This is useful for preventing operations on a closed or
  /// cleaned-up instance.
  bool get isDisposed;
}