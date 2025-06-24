import '../helpers/stack_trace_parser.dart';
import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';
import '../helpers/commons.dart';

/// {@template flat_structured_printer}
/// A structured log printer that formats log records with optional indentation and stack traces.
///
/// This printer outputs each log record as a structured single-line summary followed by
/// additional indented lines for the stack trace if it is present and enabled in the config.
/// It offers better readability compared to flat output, especially when errors and stack traces
/// are involved.
///
/// The log content is customized through the [LogConfig] object, which determines which
/// [LogStep]s to include (timestamp, level, message, etc.).
///
/// ### Example
///
/// ```dart
/// final printer = FlatStructuredPrinter();
/// final record = LogRecord(
///   level: LogLevel.error,
///   message: 'Something went wrong!',
///   time: DateTime.now(),
///   stackTrace: StackTrace.current,
/// );
///
/// final output = printer.log(record);
/// for (final line in output) {
///   print(line);
/// }
///
/// // Output example:
/// // [ERROR][Something went wrong!]
/// //   ↪ #0 MyApp._handleError (main.dart:42)
/// //   ↪ #1 runApp (main.dart:50)
/// //   ↪ #2 main (main.dart:10)
/// ```
/// {@endtemplate}
class FlatStructuredPrinter extends LogPrinter {
  /// Configuration for customizing the log output format.
  ///
  /// Controls which parts of the log record are included, such as timestamp,
  /// log level, message, stack trace, etc.
  ///
  /// Defaults to an instance of [LogConfig] with default values if not provided.
  final LogConfig config;

  /// List of paths to exclude from stack traces
  /// 
  /// Defaults to [StackTraceParser.defaultExcludePaths].
  final List<String> excludePaths;

  /// {@macro flat_structured_printer}
  FlatStructuredPrinter({
    LogConfig? config, 
    List<String>? excludePaths
  }) : config = config ?? LogConfig(), excludePaths = excludePaths ?? StackTraceParser.defaultExcludePaths;

  @override
  List<String> log(LogRecord record) {
    final buffer = <String>[];
    final mainLine = StringBuffer();
    
    for (final step in config.steps) {
      if (step == LogStep.STACKTRACE) {
        final stackLines = extractStack(record.stackTrace, excludePaths);
        buffer.addAll(stackLines.map((line) => '  ↪ $line'));
      } else {
        final value = getStepValue(step, record);
        if (value != null && value.isNotEmpty) {
          if (mainLine.isNotEmpty) mainLine.write(' ');

          if(step == LogStep.MESSAGE) {
            mainLine.write(value);
          } else {
            mainLine.write('[$value]');
          }
        }
      }
    }
    
    buffer.insert(0, mainLine.toString());
    return buffer;
  }

  @override
  String? getStepValue(LogStep step, LogRecord record) {
    final color = levelColor(record.level);
    
    switch (step) {
      case LogStep.TIMESTAMP:
        if (!config.showTimestamp) return null;
        return config.useHumanReadableTime 
            ? LogCommons.formatTimestamp(record.time, true)
            : record.time.toIso8601String();
      case LogStep.DATE:
        if (!config.showDateOnly || !config.showTimestamp) return null;
        return record.time.toIso8601String().split('T')[0];
      case LogStep.LEVEL:
        return config.showLevel ? color(record.level.name) : null;
      case LogStep.TAG:
        return (config.showTag && record.loggerName != null && record.loggerName!.isNotEmpty) ? record.loggerName : null;
      case LogStep.MESSAGE:
        return stringify(record.message);
      case LogStep.ERROR:
        return (record.error != null) ? 'ERROR: ${record.error}' : null;
      case LogStep.THREAD:
        return config.showThread ? LogCommons.formatElapsed(Duration.zero) : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? 'LOC:$location' : null;
      case LogStep.STACKTRACE:
        return null; // Handled separately
    }
  }
}