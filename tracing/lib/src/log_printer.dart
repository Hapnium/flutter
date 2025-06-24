import 'enums/log_level.dart';
import 'enums/log_step.dart';
import 'helpers/ansi_color.dart';
import 'helpers/commons.dart';
import 'helpers/stack_trace_parser.dart';
import 'models/log_record.dart';

/// {@template logPrinter}
/// A base class for implementing custom log output formatting.
///
/// Subclasses of [LogPrinter] are responsible for formatting a [LogRecord]
/// into one or more strings for display, file logging, or other destinations.
///
/// Log printers provide flexibility in how logs are presented, making them
/// essential for different environments such as terminals, files, remote logging
/// services, or testing frameworks.
///
/// Example:
/// ```dart
/// class SimpleLogPrinter extends LogPrinter {
///   @override
///   List<String> log(LogRecord record) {
///     return ['${record.time.toIso8601String()} [${record.level}] ${record.message}'];
///   }
/// }
/// ```
/// {@endtemplate}
abstract class LogPrinter {
  /// Formats the given [LogRecord] into a list of strings.
  ///
  /// This method is called for each log event. The returned list of strings
  /// will be output line-by-line by the logging framework.
  ///
  /// Each string in the list represents a line, allowing multi-line logs
  /// (such as those with stack traces or structured JSON).
  ///
  /// Implementations should avoid side effects and keep formatting consistent.
  ///
  /// Example return:
  /// ```dart
  /// [
  ///   "[INFO] Application started",
  ///   "Details: version 1.0.0"
  /// ]
  /// ```
  List<String> log(LogRecord record);

  /// Returns the color for the given log level.
  ///
  /// If the log level is not found in [LogCommons.levelColors], returns [AnsiColor.none()].
  AnsiColor levelColor(LogLevel level) => LogCommons.levelColors[level] ?? const AnsiColor.none();

  /// Extracts the string representation of the given [LogStep] from a [LogRecord].
  ///
  /// Returns `null` if the step is disabled or the corresponding data is unavailable.
  String? getStepValue(LogStep step, LogRecord record) => null;

  /// Extracts the stack trace from a [LogRecord].
  ///
  /// Returns an empty list if the stack trace is null.
  List<String> extractStack(StackTrace? stackTrace, List<String> excludePaths) {
    if (stackTrace == null) return [];
    
    final formatted = StackTraceParser.formatStackTrace(
      stackTrace,
      3, // Take first 3 lines
      excludePaths: excludePaths,
    );
    
    return formatted?.split('\n') ?? [];
  }

  /// Converts a message to its string representation.
  ///
  /// If the message is a function, it will be invoked and its result stringified.
  /// Otherwise, it will be formatted into a readable string.
  String stringify(dynamic message) {
    if(message == null) {
      return 'No log message';
    } else if(message is Function) {
      return message().toString();
    } else {
      return _buildFormattedText(message, 0);
    }
  }

  /// Formats a dynamic value into a string.
  ///
  /// Handles strings, lists, maps, and other types by converting them to a
  /// readable string format.
  String _buildFormattedText(dynamic value, int indentLevel) {
    const indentUnit = '  '; // 2 spaces
    final indent = indentUnit * indentLevel;
    final nextIndent = indentUnit * (indentLevel + 1);

    if (value == null) {
      return 'null';
    }

    if (value is String) {
      return value;
    }

    if (value is List) {
      if (value.isEmpty) return '[]';
      final buffer = StringBuffer();
      buffer.writeln('[');
      for (var i = 0; i < value.length; i++) {
        buffer.writeln('$nextIndent${_buildFormattedText(value[i], indentLevel + 1)}${i < value.length - 1 ? ',' : ''}');
      }
      buffer.write('$indent]');
      return buffer.toString();
    }

    if (value is Map) {
      if (value.isEmpty) return '{}';
      final buffer = StringBuffer();
      buffer.writeln('{');
      final entries = value.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final key = entry.key;
        final val = entry.value;
        buffer.writeln('$nextIndent"$key": ${_buildFormattedText(val, indentLevel + 1)}${i < entries.length - 1 ? ',' : ''}');
      }
      buffer.write('$indent}');

      return buffer.toString();
    }

    return value.toString();
  }
}