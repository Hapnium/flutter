import '../enums/log_level.dart';
import '../helpers/stack_trace_parser.dart';

/// {@template logRecord}
/// A `LogRecord` represents a single logging event captured by the logging system.
///
/// It holds metadata such as the log level, message, timestamp, error object,
/// and stack trace. This structure allows loggers to format and route logs
/// consistently and meaningfully.
///
/// This is particularly useful in diagnostic tools, analytics, and
/// structured log processing.
///
/// Example usage:
/// ```dart
/// final record = LogRecord(
///   LogLevel.warning,
///   'Something suspicious happened',
///   loggerName: 'AuthService',
///   error: FormatException('Invalid token'),
///   stackTrace: StackTrace.current,
/// );
/// print(record);
/// ```
/// {@endtemplate}
class LogRecord {
  /// The severity level of the log message.
  ///
  /// This determines how important the log message is, and can influence
  /// which messages are displayed or stored depending on the configured
  /// log level filters.
  ///
  /// Common levels include:
  /// - `LogLevel.debug`
  /// - `LogLevel.info`
  /// - `LogLevel.warning`
  /// - `LogLevel.error`
  /// - `LogLevel.fatal`
  final LogLevel level;

  /// The main log message.
  ///
  /// This should describe the event or observation. Try to keep it concise
  /// yet descriptive.
  final String message;

  /// An optional name for the logger that produced this record.
  ///
  /// This helps identify the origin of the log in larger applications.
  ///
  /// Example:
  /// ```dart
  /// loggerName: 'UserService'
  /// ```
  final String? loggerName;

  /// The timestamp indicating when this log record was created.
  ///
  /// If not explicitly passed, defaults to the current time via `DateTime.now()`.
  final DateTime time;

  /// Optional object representing the error or exception that occurred.
  ///
  /// This is useful for capturing caught errors along with the log message.
  ///
  /// Example:
  /// ```dart
  /// error: ArgumentError('User ID cannot be null')
  /// ```
  final Object? error;

  /// Optional stack trace associated with the error.
  ///
  /// Provides detailed context of where the error occurred, aiding in
  /// debugging and tracing the source of problems.
  final StackTrace? stackTrace;

  /// Cached location string extracted from stack trace
  /// 
  /// This is used to avoid re-parsing the stack trace on every log output.
  String? _location;

  /// {@macro logRecord}
  ///
  /// Creates a new instance of [LogRecord].
  ///
  /// If [time] is not provided, it defaults to the current time.
  LogRecord(
    this.level,
    this.message, {
    this.loggerName,
    DateTime? time,
    this.error,
    this.stackTrace,
  }) : time = time ?? DateTime.now();

  /// Gets the location information from the stack trace.
  /// 
  /// Returns a formatted string like "main.dart:42:10" or null if unavailable.
  String? get location {
    _location ??= StackTraceParser.extractLocation(stackTrace: stackTrace);
    return _location;
  }

  /// Returns a simple string representation of the log message.
  ///
  /// Format: `[$level] $message`
  ///
  /// Example:
  /// ```
  /// [WARNING] Token has expired
  /// ```
  @override
  String toString() => '[$level] $message';
}