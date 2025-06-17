import '../definitions.dart';
import '../exceptions/controller_advice.dart';
import 'zap_config.dart';

/// The [FluxConfig] class holds configuration options for the Flux platform,
/// allowing customization of various behaviors such as token usage, logging, and error handling.
///
/// This class provides flexible options that control how Flux interacts with different
/// environments (like development or production) and handles sessions and failures.
class FluxConfig {
  /// - **useSingleInstance**: Determines if a single instance of [Zap] should be used. Default is `true`.
  final bool useSingleInstance;

  /// - **disposeOnCompleted**: Determines if the [Flux] instance should be disposed after the request is completed. Default is `true`.
  final bool disposeOnCompleted;

  /// - **showErrorLog**: Determines if error logs should be displayed during operations. Default is `false`.
  final bool showErrorLogs;

  /// - **showResponseLogs**: Determines if response logs should be displayed during operations. Default is `false`.
  final bool showResponseLogs;

  /// - **showRequestLogs**: Determines if response logs should be displayed during operations. Default is `false`.
  final bool showRequestLogs;

  /// - **zapConfig**: The configuration of the [ZapClient].
  final ZapConfig? zapConfig;

  /// - **sessionFactory**: A callback function to handle session updates. Default is `null`.
  final SessionCallback? sessionFactory;

  /// - **onSessionRefreshed**: A callback function to handle session refresh. Called when request hits an unauthorized exception.
  /// 
  /// Default is `null`.
  final AsyncSessionCallback? onSessionRefreshed;

  /// - **whenUnauthorized**: A callback function to execute when removing routes. Default is `null`.
  /// 
  /// This is used to remove the current route when the request hits an unauthorized exception.
  final Callback? whenUnauthorized;

  /// - **headers**: Additional headers to send to the request processor. Default is `null`.
  final Headers? headers;

  /// - **isWeb**: Whether the current platform is web.
  final bool isWeb;

  /// - **connectTimeout**: The timeout for connecting to the server. Default is [Duration(seconds: 30)].
  final Duration connectTimeout;

  /// - **authHeaderName**: The name of the authentication header. Default is `'Authorization'`.
  /// 
  /// Examples: `'Authorization'`, `'X-API-Key'`, `'X-Auth-Token'`, etc.
  final String authHeaderName;

  /// - **tokenPrefix**: The prefix to add before the token in the auth header. Default is `'Bearer'`.
  /// 
  /// Examples: `'Bearer'`, `'Token'`, `'Goog'`, `'Basic'`, etc.
  /// Set to empty string `''` if no prefix is needed.
  final String tokenPrefix;

  /// - **controllerAdvice**: A callback function to handle controller advice. Default is `null`.
  /// 
  /// This is used to handle controller advice when the request hits an exception.
  final ControllerAdvice? controllerAdvice;

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

  FluxConfig({
    this.disposeOnCompleted = false,
    this.useSingleInstance = true,
    this.onSessionRefreshed,
    this.showErrorLogs = false,
    this.zapConfig,
    this.sessionFactory,
    this.whenUnauthorized,
    this.headers,
    this.showRequestLogs = false,
    this.showResponseLogs = false,
    this.isWeb = false,
    this.connectTimeout = const Duration(seconds: 30),
    this.authHeaderName = 'Authorization',
    this.tokenPrefix = 'Bearer',
    this.controllerAdvice,
    this.authHeaderBuilder,
  });

  /// Creates a new [FluxConfig] instance by copying existing values and
  /// overriding specific fields with new values, if provided.
  FluxConfig copyWith({
    bool? disposeOnCompleted,
    bool? useSingleInstance,
    bool? showErrorLogs,
    bool? showResponseLogs,
    bool? showRequestLogs,
    ZapConfig? zapConfig,
    AsyncSessionCallback? onSessionRefreshed,
    SessionCallback? sessionFactory,
    Callback? whenUnauthorized,
    bool? removeAllPathsWhenRequestFails,
    bool? reloadPageWhenRequestFails,
    Headers? headers,
    bool? isWeb,
    Duration? connectTimeout,
    String? authHeaderName,
    String? tokenPrefix,
    ControllerAdvice? controllerAdvice,
    HeaderBuilder? authHeaderBuilder,
  }) {
    return FluxConfig(
      disposeOnCompleted: disposeOnCompleted ?? this.disposeOnCompleted,
      useSingleInstance: useSingleInstance ?? this.useSingleInstance,
      showErrorLogs: showErrorLogs ?? this.showErrorLogs,
      showRequestLogs: showRequestLogs ?? this.showRequestLogs,
      showResponseLogs: showResponseLogs ?? this.showResponseLogs,
      zapConfig: zapConfig ?? this.zapConfig,
      onSessionRefreshed: onSessionRefreshed ?? this.onSessionRefreshed,
      sessionFactory: sessionFactory ?? this.sessionFactory,
      whenUnauthorized: whenUnauthorized ?? this.whenUnauthorized,
      headers: headers ?? this.headers,
      isWeb: isWeb ?? this.isWeb,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      authHeaderName: authHeaderName ?? this.authHeaderName,
      tokenPrefix: tokenPrefix ?? this.tokenPrefix,
      controllerAdvice: controllerAdvice ?? this.controllerAdvice,
      authHeaderBuilder: authHeaderBuilder ?? this.authHeaderBuilder,
    );
  }
}