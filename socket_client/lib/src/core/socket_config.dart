import 'package:socket_client/socket_client.dart';

/// The [SocketConfig] class holds configuration options for the SocketIt platform,
/// allowing customization of various behaviors such as token usage, logging, and error handling.
///
/// This class provides flexible options that control how SocketIt interacts with different
/// environments (like development or production) and handles sessions and failures.
class SocketConfig {
  /// - **useToken**: Specifies whether to use a token in requests. Default is `false`.
  final bool useToken;

  /// - **showErrorLog**: Determines if error logs should be displayed during operations. Default is `false`.
  final bool showErrorLogs;

  /// - **showConnectionLogs**: Determines if connection logs should be displayed during operations. Default is `false`.
  final bool showConnectionLogs;

  /// - **showDebugLogs**: Determines if connection logs should be displayed during operations. Default is `false`.
  final bool showDebugLogs;

  /// - **showSendLogs**: Determines if send logs should be displayed during operations. Default is `false`.
  final bool showSendLogs;

  /// - **baseUrl**: The base URL for API requests. This can be null if not specified.
  final String? baseUrl;

  /// - **mode**: Specifies the operating mode (e.g., production, development, sandbox). Default is `null`.
  final Server? mode;

  /// - **session**: The current session, represented by a [SessionResponse]. Default is `null`.
  final SessionResponse? session;

  /// - **onSessionUpdate**: A callback function to handle session updates. Default is `null`.
  final SessionCallback? onSessionUpdate;

  /// - **onRemoveRoutes**: A callback function to execute when removing routes. Default is `null`.
  final Callback? onRemoveRoutes;

  /// - **headers**: Additional headers to send to the request processor. Default is `null`.
  final Headers? headers;

  /// - **endpoint**: The endpoint to use as the connector. Default is `/ws:hapnium`.
  final String? endpoint;

  /// - **onReceived**: Action to perform when a response is returned [SocketResponse].
  final SocketCallback onReceived;

  /// - **subscription**: The subscription endpoint to listen for.
  final String subscription;

  /// - **isWebPlatform**: Whether the current platform is web.
  final bool isWebPlatform;

  /// - **onError**: Show any error from the connection
  final ErrorCallback? onError;

  SocketConfig({
    this.useToken = false,
    this.showErrorLogs = false,
    this.baseUrl,
    this.mode,
    this.session,
    this.onSessionUpdate,
    this.onRemoveRoutes,
    this.headers,
    this.showSendLogs = false,
    this.showConnectionLogs = false,
    this.endpoint = "/ws:hapnium",
    required this.onReceived,
    required this.subscription,
    this.isWebPlatform = false,
    this.showDebugLogs = false,
    this.onError
  });

  /// Creates a new [SocketConfig] instance by copying existing values and
  /// overriding specific fields with new values, if provided.
  SocketConfig copyWith({
    bool? useToken,
    bool? showErrorLogs,
    bool? showConnectionLogs,
    bool? showSendLogs,
    String? baseUrl,
    Server? mode,
    SessionResponse? session,
    SessionCallback? onSessionUpdate,
    Callback? onRemoveRoutes,
    bool? removeAllPathsWhenRequestFails,
    bool? reloadPageWhenRequestFails,
    Headers? headers,
    String? endpoint,
    SocketCallback? onReceived,
    String? subscription,
    bool? isWebPlatform,
    bool? showDebugLogs,
    ErrorCallback? onError
  }) {
    return SocketConfig(
      useToken: useToken ?? this.useToken,
      showErrorLogs: showErrorLogs ?? this.showErrorLogs,
      showSendLogs: showSendLogs ?? this.showSendLogs,
      showConnectionLogs: showConnectionLogs ?? this.showConnectionLogs,
      baseUrl: baseUrl ?? this.baseUrl,
      mode: mode ?? this.mode,
      session: session ?? this.session,
      onSessionUpdate: onSessionUpdate ?? this.onSessionUpdate,
      onRemoveRoutes: onRemoveRoutes ?? this.onRemoveRoutes,
      headers: headers ?? this.headers,
      endpoint: endpoint ?? this.endpoint,
      onReceived: onReceived ?? this.onReceived,
      subscription: subscription ?? this.subscription,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
      showDebugLogs: showDebugLogs ?? this.showDebugLogs,
      onError: onError ?? this.onError
    );
  }
}