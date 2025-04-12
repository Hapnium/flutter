import 'package:tracing/tracing.dart';

/// An abstract class that defines the interface for a logging src.service.
///
/// This src.service provides methods for logging messages with various options.
abstract class LoggingService {
  /// Logs a message with the specified options.
  ///
  /// This method allows you to log messages with different levels (`INFO`, `DEBUG`, `WARN`, `ERROR`),
  /// a custom prefix, an optional source identifier, and a header flag.
  ///
  /// Args:
  ///   * text: The message to be logged.
  ///   * prefix: A custom prefix to add before the message (defaults to "LogManager").
  ///   * from: An optional source identifier for the log message.
  ///   * needHeader: A flag indicating whether to include a header with timestamp and level (defaults to true).
  ///   * mode: The logging level of the message (defaults to LogMode.INFO).
  void log(dynamic text, {String? prefix, String? from, bool? needHeader, LogMode? mode});
}