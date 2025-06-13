import '../definitions.dart';
import 'session_response.dart';

/// Configuration class for Zync WebSocket connections with flexible authentication.
class ZyncConfig {
  /// The WebSocket endpoint URL.
  final String url;
  
  /// Optional subscription topic/channel.
  final String? subscription;
  
  /// Authentication session for the connection.
  final SessionResponse? session;
  
  /// Additional headers to send with the connection.
  final Headers? headers;
  
  /// Whether to show connection logs.
  final bool showConnectionLogs;
  
  /// Whether to show error logs.
  final bool showErrorLogs;
  
  /// Whether to show send logs.
  final bool showSendLogs;
  
  /// Whether to show debug logs.
  final bool showDebugLogs;
  
  /// Whether running on web platform.
  final bool isWebPlatform;
  
  /// Whether to use authentication token.
  final bool useToken;

  /// - **authHeaderName**: The name of the authentication header. Default is `'Authorization'`.
  /// 
  /// Examples: `'Authorization'`, `'X-API-Key'`, `'X-Auth-Token'`, etc.
  final String authHeaderName;

  /// - **tokenPrefix**: The prefix to add before the token in the auth header. Default is `'Bearer'`.
  /// 
  /// Examples: `'Bearer'`, `'Token'`, `'Goog'`, `'Basic'`, etc.
  /// Set to empty string `''` if no prefix is needed.
  final String tokenPrefix;

  /// - **authHeaderBuilder**: A custom function to build authentication headers.
  /// 
  /// This function receives the current session and should return a map of headers to add.
  /// If provided, this takes precedence over [authHeaderName] and [tokenPrefix].
  /// 
  /// Example:
  /// ```dart
  /// authHeaderBuilder: (session) => {
  ///   'Authorization': 'Bearer ${session.accessToken}',
  ///   'X-Refresh-Token': session.refreshToken,
  ///   'X-User-ID': session.userId.toString(),
  /// }
  /// ```
  final HeaderBuilder? authHeaderBuilder;

  /// - **sessionFactory**: A callback function to handle session updates. Default is `null`.
  final SessionCallback? sessionFactory;
  
  /// Callback for when a message is received.
  final RealtimeCallback? onReceived;
  
  /// Callback for when an error occurs.
  final ErrorCallback? onError;
  
  /// Callback for connection state changes.
  final StateCallback? onStateChanged;
  
  /// Ping interval for keep-alive messages.
  final Duration pingInterval;
  
  /// Maximum number of reconnection attempts.
  final int maxReconnectAttempts;
  
  /// Delay between reconnection attempts.
  final Duration reconnectDelay;

  ZyncConfig({
    required this.url,
    this.subscription,
    this.session,
    this.headers,
    this.showConnectionLogs = false,
    this.showErrorLogs = false,
    this.showSendLogs = false,
    this.showDebugLogs = false,
    this.isWebPlatform = false,
    this.useToken = true,
    this.authHeaderName = 'Authorization',
    this.tokenPrefix = 'Bearer',
    this.authHeaderBuilder,
    this.sessionFactory,
    this.onReceived,
    this.onError,
    this.onStateChanged,
    this.pingInterval = const Duration(seconds: 30),
    this.maxReconnectAttempts = 5,
    this.reconnectDelay = const Duration(seconds: 3),
  });

  ZyncConfig copyWith({
    String? url,
    String? subscription,
    SessionResponse? session,
    Headers? headers,
    bool? showConnectionLogs,
    bool? showErrorLogs,
    bool? showSendLogs,
    bool? showDebugLogs,
    bool? isWebPlatform,
    bool? useToken,
    String? authHeaderName,
    String? tokenPrefix,
    HeaderBuilder? authHeaderBuilder,
    SessionCallback? sessionFactory,
    RealtimeCallback? onReceived,
    ErrorCallback? onError,
    StateCallback? onStateChanged,
    Duration? pingInterval,
    int? maxReconnectAttempts,
    Duration? reconnectDelay,
  }) {
    return ZyncConfig(
      url: url ?? this.url,
      subscription: subscription ?? this.subscription,
      session: session ?? this.session,
      headers: headers ?? this.headers,
      showConnectionLogs: showConnectionLogs ?? this.showConnectionLogs,
      showErrorLogs: showErrorLogs ?? this.showErrorLogs,
      showSendLogs: showSendLogs ?? this.showSendLogs,
      showDebugLogs: showDebugLogs ?? this.showDebugLogs,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
      useToken: useToken ?? this.useToken,
      authHeaderName: authHeaderName ?? this.authHeaderName,
      tokenPrefix: tokenPrefix ?? this.tokenPrefix,
      authHeaderBuilder: authHeaderBuilder ?? this.authHeaderBuilder,
      sessionFactory: sessionFactory ?? this.sessionFactory,
      onReceived: onReceived ?? this.onReceived,
      onError: onError ?? this.onError,
      onStateChanged: onStateChanged ?? this.onStateChanged,
      pingInterval: pingInterval ?? this.pingInterval,
      maxReconnectAttempts: maxReconnectAttempts ?? this.maxReconnectAttempts,
      reconnectDelay: reconnectDelay ?? this.reconnectDelay,
    );
  }
}