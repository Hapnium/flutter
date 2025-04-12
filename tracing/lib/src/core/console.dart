import 'package:tracing/tracing.dart';

/// A singleton class for logging messages to the console.
class Console {
  /// Controls whether logs are displayed in the console.
  bool showLog;

  /// Creates a new Console instance with the specified `showLog` value.
  Console._internal(this.showLog);

  /// The singleton instance of the Console class.
  static final Console _instance = Console._internal(true);

  /// Provides access to the singleton instance of the Console class.
  ///
  /// - `showLog`: Whether to print logs to console or not
  factory Console(bool showLog) {
    return Console._internal(showLog);
  }

  /// The underlying logging service used to write logs.
  final LoggingService _logger = Logging();

  /// Logs a message to the console with the specified options.
  ///
  /// If `showLog` is set to `false`, the message will not be logged.
  ///
  /// - `message`: The message to be logged.
  /// - `mode`: The logging level (e.g., `INFO`, `WARN`, `ERROR`).
  /// - `prefix`: An optional prefix to add to the log message.
  /// - `from`: An optional source identifier for the log message.
  /// - `needHeader`: Whether to include a header with timestamp and level.
  void log(dynamic message, {
    LogMode mode = LogMode.INFO,
    String? prefix,
    String? from,
    bool needHeader = true,
  }) {
    if (showLog) {
      _logger.log(message, prefix: prefix, from: from, needHeader: needHeader, mode: mode);
    }
  }

  /// Logs a trace message to the console.
  ///
  /// See [log] for more details on parameters.
  void trace(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.TRACE, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs a debug message to the console.
  ///
  /// See [log] for more details on parameters.
  void debug(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.DEBUG, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs an info message to the console.
  ///
  /// See [log] for more details on parameters.
  void info(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.INFO, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// **Deprecated:** Use `warn` instead.
  ///
  /// Logs a warning message to the console.
  ///
  /// See [log] for more details on parameters.
  @deprecated
  void warning(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    // Removed implementation
  }

  /// Logs a warning message to the console.
  ///
  /// See [log] for more details on parameters.
  void warn(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.WARN, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs an error message to the console.
  ///
  /// See [log] for more details on parameters.
  void error(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.ERROR, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs a fatal message to the console.
  ///
  /// See [log] for more details on parameters.
  void fatal(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.FATAL, prefix: prefix, from: from, needHeader: needHeader);
  }
}

/// The singleton instance of the Console class.
final console = Console._instance;