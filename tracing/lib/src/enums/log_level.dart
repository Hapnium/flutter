/// {@template log_level}
/// Defines various levels of logging severity for controlling logging output.
///
/// This enum is used to filter or categorize log messages based on their
/// importance, relevance, or severity. Logging frameworks and tools use these
/// levels to determine whether a message should be processed or ignored.
///
/// ### Levels Overview:
///
/// | Level   | Value | Description                                                      |
/// |---------|-------|------------------------------------------------------------------|
/// | `trace` | 0     | Detailed debugging or tracing info, typically very verbose.      |
/// | `debug` | 1     | General debugging information, useful for development.           |
/// | `info`  | 2     | General runtime events (e.g., startup, shutdown).                |
/// | `warning` | 3   | Something unexpected, but not necessarily an error.              |
/// | `error` | 4     | Recoverable application errors that require attention.           |
/// | `fatal` | 5     | Critical issues that will likely cause application termination.  |
/// | `off`   | 6     | Disables logging entirely.                                       ///
/// 
/// {@endtemplate}
enum LogLevel {
  /// The most fine-grained level. Use this for tracing function calls, loop iterations, and other
  /// low-level, verbose details.
  ///
  /// Typically disabled in production due to verbosity.
  TRACE(0, 'TRACE'),

  /// Debug-level messages useful for developers during active debugging sessions.
  ///
  /// Includes information like variable values, internal state, and control flow.
  DEBUG(1, 'DEBUG'),

  /// Informational messages that indicate the application’s progress under normal conditions.
  ///
  /// Good for confirming that things are working as expected (e.g., "User successfully logged in").
  INFO(2, 'INFO'),

  /// Indicates a potential issue or unexpected situation, but the application can still continue safely.
  ///
  /// Should be investigated but may not require immediate action (e.g., deprecated API usage).
  WARN(3, 'WARNING'),

  /// An error has occurred that may impact functionality, but the app is still running.
  ///
  /// For example, a failed network request, missing file, or service unavailability.
  ERROR(4, 'ERROR'),

  /// A critical error has occurred that is likely to lead to application failure or shutdown.
  ///
  /// Use for fatal exceptions, data corruption, or failed application bootstrapping.
  FATAL(5, 'FATAL'),

  /// Disables all logging output.
  ///
  /// Use this to suppress all logs, useful for production environments or silent modes.
  OFF(6, 'OFF');

  /// Constructs a log level with an associated [value] for comparison and a human-readable [name].
  /// 
  /// {@macro log_level}
  const LogLevel(this.value, this.name);

  /// Integer value for comparing levels. Lower values mean lower severity.
  final int value;

  /// The display name of the log level (e.g., 'INFO', 'ERROR').
  final String name;

  /// Determines if this log level is enabled given a minimum [level].
  ///
  /// Returns `true` if this log level is equal to or more severe than [level].
  /// This is useful for checking whether a message should be logged:
  ///
  /// ```dart
  /// if (LogLevel.error.isEnabledFor(currentLevel)) {
  ///   print('Something went wrong!');
  /// }
  /// ```
  bool isEnabledFor(LogLevel level) => value >= level.value;

  @override
  String toString() => name;
}