import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';
import '../helpers/commons.dart';

/// {@template flat_printer}
/// A simple, flat-style log printer that outputs log records in a structured format.
/// 
/// This printer formats each log record as a single line, with each configured step
/// enclosed in square brackets. It is useful for compact and readable logging output
/// in CLI or file logs.
///
/// The formatting behavior is controlled by the [LogConfig] object, allowing you to
/// choose which log information to include, such as timestamp, level, tag, message,
/// error, stack trace, and more.
///
/// ### Example
///
/// ```dart
/// final printer = FlatPrinter();
/// final record = LogRecord(
///   level: LogLevel.info,
///   message: 'App started',
///   time: DateTime.now(),
///   loggerName: 'AppLogger',
/// );
///
/// final output = printer.log(record);
/// print(output.first); // Example: [INFO][AppLogger][App started]
/// ```
/// {@endtemplate}
class FlatPrinter extends LogPrinter {
  /// Configuration object that determines which log steps to include.
  ///
  /// By default, this is initialized to a default [LogConfig] if not provided.
  final LogConfig config;

  /// {@macro flat_printer}
  FlatPrinter({LogConfig? config}) : config = config ?? LogConfig();

  @override
  List<String> log(LogRecord record) {
    final buffer = StringBuffer();
    
    for (final step in config.steps) {
      final value = getStepValue(step, record);
      if (value != null && value.isNotEmpty) {
        if(step == LogStep.MESSAGE) {
          buffer.write(" $value");
        } else {
          buffer.write('[$value]');
        }
      }
    }
    
    return [buffer.toString()];
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
      case LogStep.STACKTRACE:
        return (record.stackTrace != null) ? 'STACK: ${record.stackTrace}' : null;
      case LogStep.THREAD:
        return config.showThread ? 'T:main' : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? 'LOC:$location' : null;
    }
  }
}