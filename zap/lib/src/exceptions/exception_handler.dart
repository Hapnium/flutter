part of 'controller_advice.dart';

/// A centralized exception handling configuration inspired by Spring Boot's `@ControllerAdvice`.
///
/// The [ExceptionHandler] class allows developers to register specific exception
/// handlers for different [ExceptionType]s and manage them in a unified manner.
/// This pattern promotes cleaner separation between business logic and error handling,
/// enabling consistent exception processing across the application.
///
/// You can register handlers for specific types of exceptions and a fallback
/// default handler for cases not explicitly covered.
///
/// ### Example Usage:
/// ```dart
/// final handler = ExceptionHandler(
///   defaultHandler: (e) => print("Unhandled: ${e.message}"),
/// );
///
/// handler.registerHandler(
///   ExceptionType.network,
///   (e) => print("Network error: ${e.message}"),
/// );
///
/// // Later during execution:
/// handler.handle(ZapException(
///   type: ExceptionType.network,
///   message: "Timeout occurred",
/// ));
/// ```
///
/// In the example above, the registered handler for `ExceptionType.network`
/// will be called. If an exception of another type is passed,
/// the default handler (if set) will be invoked instead.
class ExceptionHandler {
  /// A map of registered handlers keyed by [ExceptionType].
  final Map<ExceptionType, Function(ZapException)> _handlers = {};

  /// A default handler to be used when no specific handler is found.
  final Function(ZapException)? _defaultHandler;

  /// Constructs an [ExceptionHandler].
  ///
  /// The optional [defaultHandler] provides fallback handling when a specific
  /// exception type is not registered via [registerHandler].
  ExceptionHandler({Function(ZapException)? defaultHandler})
      : _defaultHandler = defaultHandler;

  /// Registers a handler for a specific [ExceptionType].
  ///
  /// If a handler is already registered for the given [type], it will be overwritten.
  void registerHandler(ExceptionType type, Function(ZapException) handler) {
    _handlers[type] = handler;
  }

  /// Registers multiple handlers at once using a map of [ExceptionType] to handlers.
  ///
  /// Existing handlers for matching keys will be overwritten.
  void registerHandlers(Map<ExceptionType, Function(ZapException)> handlers) {
    _handlers.addAll(handlers);
  }

  /// Handles the provided [ZapException] by invoking a matching handler.
  ///
  /// If no handler is registered for [exception.type], the [_defaultHandler] is invoked.
  /// If neither is available, the exception is silently ignored.
  void handle(ZapException exception) {
    final handler = _handlers[exception.type] ?? _defaultHandler;
    handler?.call(exception);
  }
}