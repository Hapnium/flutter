import '../definitions.dart';
import 'zap_config.dart';

/// The [ZapPulseConfig] class holds configuration options for the ZapPulse platform,
/// allowing customization of various behaviors such as token usage, logging, and error handling.
///
/// This class provides flexible options that control how ZapPulse interacts with different
/// environments (like development or production) and handles sessions and failures.
class ZapPulseConfig {
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

  /// - **onRemoveRoute**: A callback function to execute when removing routes. Default is `null`.
  final Callback? onRemoveRoute;

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

  /// - **customAuthHeaderBuilder**: A custom function to build authentication headers.
  /// 
  /// This function receives the current session and should return a map of headers to add.
  /// If provided, this takes precedence over [authHeaderName] and [tokenPrefix].
  /// 
  /// Example:
  /// ```dart
  /// customAuthHeaderBuilder: (session) => {
  ///   'Authorization': 'Bearer ${session.accessToken}',
  ///   'X-Refresh-Token': session.refreshToken,
  ///   'X-User-ID': session.userId.toString(),
  /// }
  /// ```
  final HeaderBuilder? customAuthHeaderBuilder;

  ZapPulseConfig({
    this.onSessionRefreshed,
    this.showErrorLogs = false,
    this.zapConfig,
    this.sessionFactory,
    this.onRemoveRoute,
    this.headers,
    this.showRequestLogs = false,
    this.showResponseLogs = false,
    this.isWeb = false,
    this.connectTimeout = const Duration(seconds: 30),
    this.authHeaderName = 'Authorization',
    this.tokenPrefix = 'Bearer',
    this.customAuthHeaderBuilder,
  });

  /// Creates a new [ZapPulseConfig] instance by copying existing values and
  /// overriding specific fields with new values, if provided.
  ZapPulseConfig copyWith({
    bool? showErrorLogs,
    bool? showResponseLogs,
    bool? showRequestLogs,
    ZapConfig? zapConfig,
    AsyncSessionCallback? onSessionRefreshed,
    SessionCallback? sessionFactory,
    Callback? onRemoveRoute,
    bool? removeAllPathsWhenRequestFails,
    bool? reloadPageWhenRequestFails,
    Headers? headers,
    bool? isWeb,
    Duration? connectTimeout,
    String? authHeaderName,
    String? tokenPrefix,
    HeaderBuilder? customAuthHeaderBuilder,
  }) {
    return ZapPulseConfig(
      showErrorLogs: showErrorLogs ?? this.showErrorLogs,
      showRequestLogs: showRequestLogs ?? this.showRequestLogs,
      showResponseLogs: showResponseLogs ?? this.showResponseLogs,
      zapConfig: zapConfig ?? this.zapConfig,
      onSessionRefreshed: onSessionRefreshed ?? this.onSessionRefreshed,
      sessionFactory: sessionFactory ?? this.sessionFactory,
      onRemoveRoute: onRemoveRoute ?? this.onRemoveRoute,
      headers: headers ?? this.headers,
      isWeb: isWeb ?? this.isWeb,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      authHeaderName: authHeaderName ?? this.authHeaderName,
      tokenPrefix: tokenPrefix ?? this.tokenPrefix,
      customAuthHeaderBuilder: customAuthHeaderBuilder ?? this.customAuthHeaderBuilder,
    );
  }
}