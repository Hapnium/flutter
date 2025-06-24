import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';
import '../helpers/commons.dart';

/// {@template fmt_printer}
/// A log printer that outputs logs in [logfmt](https://brandur.org/logfmt) format.
///
/// This printer converts log records into a series of key-value pairs suitable for
/// machine parsing and log aggregation systems like Loki, Datadog, or Fluentd.
///
/// Keys such as `level`, `msg`, `time`, and others are included based on the steps
/// defined in the [LogConfig]. Strings are properly escaped and quoted to comply
/// with the logfmt specification.
///
/// ### Example
///
/// ```dart
/// final printer = FmtPrinter();
/// final record = LogRecord(
///   level: LogLevel.warning,
///   message: 'Disk space low',
///   time: DateTime.now(),
///   loggerName: 'SystemMonitor',
/// );
///
/// final output = printer.log(record);
/// print(output.first);
///
/// // Example output:
/// // level=warning msg="Disk space low" time="2025-06-23T15:00:00.000Z" logger="SystemMonitor"
/// ```
/// {@endtemplate}
class FmtPrinter extends LogPrinter {
  /// Configuration for customizing which log components are included.
  ///
  /// Defaults to a new instance of [LogConfig] with default flags enabled/disabled.
  final LogConfig config;

  /// {@macro fmt_printer}
  FmtPrinter({LogConfig? config}) : config = config ?? LogConfig();

  @override
  List<String> log(LogRecord record) {
    final buffer = StringBuffer();
    bool first = true;
    
    for (final step in config.steps) {
      final value = getStepValue(step, record);
      if (value != null) {
        if (!first) buffer.write(' ');
        buffer.write(value);
        first = false;
      }
    }
    
    return [buffer.toString()];
  }

  @override
  String? getStepValue(LogStep step, LogRecord record) {
    switch (step) {
      case LogStep.LEVEL:
        return config.showLevel ? 'level=${record.level.name.toLowerCase()}' : null;
      case LogStep.MESSAGE:
        return 'msg="${_escapeString(record.message)}"';
      case LogStep.TIMESTAMP:
        if (!config.showTimestamp) return null;
        final time = config.useHumanReadableTime 
            ? LogCommons.formatTimestamp(record.time, true)
            : record.time.toIso8601String();
        return 'time="$time"';
      case LogStep.DATE:
        if (!config.showDateOnly || !config.showTimestamp) return null;
        final date = record.time.toIso8601String().split('T')[0];
        return 'date="$date"';
      case LogStep.TAG:
        return (config.showTag && record.loggerName != null && record.loggerName!.isNotEmpty) 
            ? 'logger="${_escapeString(record.loggerName!)}"' 
            : null;
      case LogStep.ERROR:
        return (record.error != null) 
            ? 'error="${_escapeString(record.error.toString())}"' 
            : null;
      case LogStep.STACKTRACE:
        return (record.stackTrace != null) 
            ? 'stacktrace="${_escapeString(record.stackTrace.toString())}"' 
            : null;
      case LogStep.THREAD:
        return config.showThread ? 'thread="main"' : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? 'location="$location"' : null;
    }
  }

  /// Escapes special characters in a string for logfmt output.
  ///
  /// Replaces double quotes with escaped double quotes and newlines with escaped newlines.
  String _escapeString(String input) {
    return input.replaceAll('"', '\\"').replaceAll('\n', '\\n');
  }
}