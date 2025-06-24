import '../helpers/ansi_color.dart';
import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';
import '../helpers/commons.dart';

/// {@template simple_printer}
/// Simple printer that outputs basic, compact log messages in a single line.
/// 
/// Ideal for minimal output needs such as CLI tools, performance-focused apps,
/// or when logs need to remain readable in raw text or terminal formats.
/// 
/// Configuration allows showing log level, timestamp, tag, errors, etc.
/// {@endtemplate}
class SimplePrinter extends LogPrinter {
  /// Logging configuration that controls formatting details like
  /// whether to show timestamps, emojis, tags, etc.
  final LogConfig config;

  /// {@macro simple_printer}
  SimplePrinter({LogConfig? config}) : config = config ?? LogConfig();

  @override
  List<String> log(LogRecord record) {
    final buffer = StringBuffer();
    
    for (final step in config.steps) {
      final value = getStepValue(step, record);
      if (value != null && value.isNotEmpty) {
        if (buffer.isNotEmpty) buffer.write(' ');
        buffer.write(value);
      }
    }
    
    final color = LogCommons.levelColors[record.level] ?? const AnsiColor.none();
    return [color(buffer.toString())];
  }

  @override
  String? getStepValue(LogStep step, LogRecord record) {
    switch (step) {
      case LogStep.LEVEL:
        if (!config.showLevel) return null;
        final emoji = config.showEmoji ? LogCommons.levelEmojis[record.level] ?? '' : '';
        return '$emoji[${record.level.name.substring(0, 1)}]';
      case LogStep.MESSAGE:
        return stringify(record.message);
      case LogStep.TIMESTAMP:
        if (!config.showTimestamp) return null;
        if (config.showTimeOnly) {
          final time = record.time.toLocal();
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
        }
        return config.useHumanReadableTime 
            ? LogCommons.formatTimestamp(record.time, true)
            : record.time.toIso8601String();
      case LogStep.DATE:
        if (!config.showDateOnly || !config.showTimestamp) return null;
        return record.time.toIso8601String().split('T')[0];
      case LogStep.TAG:
        return (config.showTag && record.loggerName != null && record.loggerName!.isNotEmpty) ? '[${record.loggerName}]' : null;
      case LogStep.ERROR:
        return (record.error != null) ? 'ERROR: ${record.error}' : null;
      case LogStep.STACKTRACE:
        return (record.stackTrace != null) ? '\n${record.stackTrace}' : null;
      case LogStep.THREAD:
        return config.showThread ? '[T:main]' : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? '($location)' : null;
    }
  }
}