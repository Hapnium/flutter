import 'package:connectify/connectify.dart';

/// The [ConnectifyConfig] class holds configuration options for the Connectify platform,
/// allowing customization of various behaviors such as token usage, logging, and error handling.
///
/// This class provides flexible options that control how Connectify interacts with different
/// environments (like development or production) and handles sessions and failures.
class ConnectifyConfig {
  /// - **useToken**: Specifies whether to use a token in requests. Default is `false`.
  final bool useToken;

  /// - **showErrorLog**: Determines if error logs should be displayed during operations. Default is `false`.
  final bool showErrorLogs;

  /// - **showResponseLogs**: Determines if response logs should be displayed during operations. Default is `false`.
  final bool showResponseLogs;

  /// - **showRequestLogs**: Determines if response logs should be displayed during operations. Default is `false`.
  final bool showRequestLogs;

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

  /// - **isWebPlatform**: Whether the current platform is web.
  final bool isWebPlatform;

  /// - **connectTimeout**: The timeout for connecting to the server. Default is [Duration(seconds: 30)].
  final Duration connectTimeout;

  ConnectifyConfig({
    this.useToken = false,
    this.showErrorLogs = false,
    this.baseUrl,
    this.mode,
    this.session,
    this.onSessionUpdate,
    this.onRemoveRoutes,
    this.headers,
    this.showRequestLogs = false,
    this.showResponseLogs = false,
    this.isWebPlatform = false,
    this.connectTimeout = const Duration(seconds: 30)
  });

  /// Creates a new [ConnectifyConfig] instance by copying existing values and
  /// overriding specific fields with new values, if provided.
  ConnectifyConfig copyWith({
    bool? useToken,
    bool? showErrorLogs,
    bool? showResponseLogs,
    bool? showRequestLogs,
    String? baseUrl,
    Server? mode,
    SessionResponse? session,
    SessionCallback? onSessionUpdate,
    Callback? onRemoveRoutes,
    bool? removeAllPathsWhenRequestFails,
    bool? reloadPageWhenRequestFails,
    Headers? headers,
    bool? isWebPlatform,
    Duration? connectTimeout
  }) {
    return ConnectifyConfig(
      useToken: useToken ?? this.useToken,
      showErrorLogs: showErrorLogs ?? this.showErrorLogs,
      showRequestLogs: showRequestLogs ?? this.showRequestLogs,
      showResponseLogs: showResponseLogs ?? this.showResponseLogs,
      baseUrl: baseUrl ?? this.baseUrl,
      mode: mode ?? this.mode,
      session: session ?? this.session,
      onSessionUpdate: onSessionUpdate ?? this.onSessionUpdate,
      onRemoveRoutes: onRemoveRoutes ?? this.onRemoveRoutes,
      headers: headers ?? this.headers,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
      connectTimeout: connectTimeout ?? this.connectTimeout,
    );
  }
}