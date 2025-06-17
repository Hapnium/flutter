import 'package:tracing/tracing.dart' show console;
import '../enums/exception_type.dart';
import 'zap_exception.dart';

part 'exception_handler.dart';

/// Signature for custom exception handlers.
///
/// Used to define actions (e.g., logging, retrying, UI alerts) for specific
/// categories of exceptions encountered in ZapClient.
typedef OnException = void Function(ZapException exception);

/// Configuration class for registering exception handlers.
///
/// Inspired by Spring Boot's `@ControllerAdvice`, this class allows
/// centralized registration of typed exception handlers for ZapClient.
///
/// Example:
/// ```dart
/// final config = ControllerAdvice(
///   onTimeout: (e) => console.log('Timeout: ${e.message}'),
///   onAuth: (e) => redirectToLogin(),
///   enableLogging: true,
/// );
///
/// final handler = config.handler;
/// ```
class ControllerAdvice {
  /// Optional custom handler for timeout exceptions.
  final OnException? onTimeout;

  /// Optional custom handler for network exceptions.
  final OnException? onNetwork;

  /// Optional custom handler for server exceptions (5xx).
  final OnException? onServer;

  /// Optional custom handler for client exceptions (4xx).
  final OnException? onClient;

  /// Optional custom handler for authentication errors.
  final OnException? onAuth;

  /// Optional custom handler for SSL/certificate errors.
  final OnException? onSSL;

  /// Optional custom handler for TCP connection errors.
  final OnException? onConnection;

  /// Optional custom handler for DNS resolution errors.
  final OnException? onDNS;

  /// Optional custom handler for data parsing/format errors.
  final OnException? onParsing;

  /// Optional custom handler for cancelled operations.
  final OnException? onCancelled;

  /// Optional fallback handler for unclassified errors.
  final OnException? onUnknown;

  /// Whether to enable default console logging for all exception types.
  final bool enableLogging;

  /// The internal [ExceptionHandler] instance configured using provided callbacks.
  late final ExceptionHandler handler;

  /// Constructs the exception config and registers all handlers.
  ///
  /// Any omitted handler types can be automatically registered with default
  /// console loggers by setting [enableLogging] to `true`.
  ControllerAdvice({
    this.onTimeout,
    this.onNetwork,
    this.onServer,
    this.onClient,
    this.onAuth,
    this.onSSL,
    this.onConnection,
    this.onDNS,
    this.onParsing,
    this.onCancelled,
    this.onUnknown,
    this.enableLogging = true,
  }) {
    handler = ExceptionHandler(
      defaultHandler: onUnknown ?? (enableLogging ? _defaultLogger : null),
    );

    _registerAllHandlers();
    if (enableLogging) _registerDefaultLoggersIfMissing();
  }

  void _registerAllHandlers() {
    if (onTimeout != null) handler.registerHandler(ExceptionType.timeout, onTimeout!);
    if (onNetwork != null) handler.registerHandler(ExceptionType.network, onNetwork!);
    if (onServer != null) handler.registerHandler(ExceptionType.server, onServer!);
    if (onClient != null) handler.registerHandler(ExceptionType.client, onClient!);
    if (onAuth != null) handler.registerHandler(ExceptionType.auth, onAuth!);
    if (onSSL != null) handler.registerHandler(ExceptionType.ssl, onSSL!);
    if (onConnection != null) handler.registerHandler(ExceptionType.connection, onConnection!);
    if (onDNS != null) handler.registerHandler(ExceptionType.dns, onDNS!);
    if (onParsing != null) handler.registerHandler(ExceptionType.parsing, onParsing!);
    if (onCancelled != null) handler.registerHandler(ExceptionType.cancelled, onCancelled!);
  }

  void _registerDefaultLoggersIfMissing() {
    final defaultHandlers = <ExceptionType, OnException>{
      ExceptionType.timeout: (e) => console.log('⏱️  TIMEOUT: ${e.message}'),
      ExceptionType.network: (e) => console.log('🌐 NETWORK: ${e.message}'),
      ExceptionType.server: (e) => console.log('🔥 SERVER: ${e.message}'),
      ExceptionType.client: (e) => console.log('❌ CLIENT: ${e.message}'),
      ExceptionType.auth: (e) => console.log('🔐 AUTH: ${e.message}'),
      ExceptionType.ssl: (e) => console.log('🔒 SSL: ${e.message}'),
      ExceptionType.connection: (e) => console.log('🔌 CONNECTION: ${e.message}'),
      ExceptionType.dns: (e) => console.log('🌍 DNS: ${e.message}'),
      ExceptionType.parsing: (e) => console.log('📝 PARSING: ${e.message}'),
      ExceptionType.cancelled: (e) => console.log('🚫 CANCELLED: ${e.message}'),
    };

    for (final entry in defaultHandlers.entries) {
      if (!handler._handlers.containsKey(entry.key)) {
        handler.registerHandler(entry.key, entry.value);
      }
    }
  }

  static void _defaultLogger(ZapException e) {
    console.log('🔍 ZAP EXCEPTION: ${e.toString()}');
  }

  void onException(ZapException e) {
    handler.handle(e);
  }
}