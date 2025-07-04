import '../core/zap_inst.dart';
import '../enums/exception_type.dart';
import 'zap_exception.dart';

part 'exception_handler.dart';

/// Signature for custom exception handlers.
///
/// Used to define actions (e.g., logging, retrying, UI alerts) for specific
/// categories of exceptions encountered in ZapClient.
typedef OnException = void Function(ZapException exception);

/// {@template controller_advice}
/// Configuration class for registering exception handlers.
///
/// Inspired by Spring Boot's `@ControllerAdvice`, this class allows
/// centralized registration of typed exception handlers for ZapClient.
///
/// Example:
/// ```dart
/// final config = ControllerAdvice(
///   onTimeout: (e) => Z.log('Timeout: ${e.message}'),
///   onAuth: (e) => redirectToLogin(),
///   enableLogging: true,
/// );
///
/// final handler = config.handler;
/// ```
/// 
/// {@endtemplate}
class ControllerAdvice {
  /// Optional custom handler for timeout exceptions.
  /// 
  /// {@macro controller_advice}
  final OnException? onTimeout;

  /// Optional custom handler for network exceptions.
  /// 
  /// {@macro controller_advice}
  final OnException? onNetwork;

  /// Optional custom handler for server exceptions (5xx).
  /// 
  /// {@macro controller_advice}
  final OnException? onServer;

  /// Optional custom handler for client exceptions (4xx).
  /// 
  /// {@macro controller_advice}
  final OnException? onClient;

  /// Optional custom handler for authentication errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onAuth;

  /// Optional custom handler for SSL/certificate errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onSSL;

  /// Optional custom handler for TCP connection errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onConnection;

  /// Optional custom handler for DNS resolution errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onDNS;

  /// Optional custom handler for data parsing/format errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onParsing;

  /// Optional custom handler for cancelled operations.
  /// 
  /// {@macro controller_advice}
  final OnException? onCancelled;

  /// Optional fallback handler for unclassified errors.
  /// 
  /// {@macro controller_advice}
  final OnException? onUnknown;

  /// Whether to enable default console logging for all exception types.
  /// 
  /// {@macro controller_advice}
  final bool enableLogging;

  /// The internal [ExceptionHandler] instance configured using provided callbacks.
  /// 
  /// {@macro controller_advice}
  late final ExceptionHandler handler;

  /// Constructs the exception config and registers all handlers.
  ///
  /// Any omitted handler types can be automatically registered with default
  /// console loggers by setting [enableLogging] to `true`.
  /// 
  /// {@macro controller_advice}
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
      ExceptionType.timeout: (e) => Z.log('⏱️  TIMEOUT: ${e.message}'),
      ExceptionType.network: (e) => Z.log('🌐 NETWORK: ${e.message}'),
      ExceptionType.server: (e) => Z.log('🔥 SERVER: ${e.message}'),
      ExceptionType.client: (e) => Z.log('❌ CLIENT: ${e.message}'),
      ExceptionType.auth: (e) => Z.log('🔐 AUTH: ${e.message}'),
      ExceptionType.ssl: (e) => Z.log('🔒 SSL: ${e.message}'),
      ExceptionType.connection: (e) => Z.log('🔌 CONNECTION: ${e.message}'),
      ExceptionType.dns: (e) => Z.log('🌍 DNS: ${e.message}'),
      ExceptionType.parsing: (e) => Z.log('📝 PARSING: ${e.message}'),
      ExceptionType.cancelled: (e) => Z.log('🚫 CANCELLED: ${e.message}'),
    };

    for (final entry in defaultHandlers.entries) {
      if (!handler._handlers.containsKey(entry.key)) {
        handler.registerHandler(entry.key, entry.value);
      }
    }
  }

  static void _defaultLogger(ZapException e) {
    Z.log('🔍 ZAP EXCEPTION: ${e.toString()}');
  }

  void onException(ZapException e) {
    handler.handle(e);
  }
}