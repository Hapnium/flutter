/// Optional logger interface used for logging pageable-related messages.
///
/// This allows injecting custom logging behavior (e.g., logging to file,
/// remote service, or structured log format) when debugging or tracing
/// pageable state and behavior.
abstract interface class PageableLogger {
  /// Logs a message.
  ///
  /// [message] is the text to log.
  /// [tag] is an optional identifier (e.g., "Fetcher", "Error") to help
  /// categorize or filter logs.
  void log(String message, {String? tag});
}

/// A default [PageableLogger] that prints messages to the console.
///
/// Useful during development for simple debugging or tracing pagination flow.
///
/// Example:
/// ```dart
/// final logger = ConsolePageableLogger();
/// logger.log('Fetching page 2', tag: 'Pagination');
/// // Output: [Pagination] Fetching page 2
/// ```
class ConsolePageableLogger implements PageableLogger {
  @override
  void log(String message, {String? tag}) {
    print('[${tag ?? 'Pageable'}] $message');
  }
}