import '../helpers/ansi_color.dart';
import '../enums/log_level.dart';
import '../helpers/commons.dart';
import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';

/// {@template prefix_printer}
/// A customizable log printer that prepends a prefix to each log line.
///
/// This printer is ideal when you want to prepend symbols, emojis, or abbreviations
/// that help visually distinguish log levels. For example, you can use emojis like:
/// - 🔍 DEBUG
/// - ⚠️ WARNING
/// - ❌ ERROR
///
/// If [LogConfig.showEmoji] is enabled and no custom prefix map is provided, default
/// emojis from [LogCommons.levelEmojis] will be used.
///
/// It supports formatting options like timestamps, tags, errors, and stack traces
/// based on the provided [LogConfig].
///
/// ### Example
///
/// ```dart
/// final printer = PrefixPrinter(
///   config: LogConfig(showLevel: true, showTimestamp: true, showEmoji: true),
/// );
///
/// final record = LogRecord(
///   level: LogLevel.info,
///   message: 'User login succeeded',
///   time: DateTime.now(),
///   loggerName: 'AuthService',
/// );
///
/// final lines = printer.log(record);
/// lines.forEach(print);
///
/// // Output:
/// // 🔷: [12:30:00] [AuthService] User login succeeded
/// ```
/// {@endtemplate}
class PrefixPrinter extends LogPrinter {
  /// A map of log level to string prefixes.
  ///
  /// If not provided and [config.showEmoji] is true, uses [LogCommons.levelEmojis].
  /// Otherwise, falls back to the level name (e.g., "INFO", "DEBUG").
  final Map<LogLevel, String> _prefixes;

  /// Configuration object that controls what log components are included.
  ///
  /// Default is [LogConfig()] if none is provided.
  final LogConfig config;

  /// {@macro prefix_printer}
  PrefixPrinter({
    Map<LogLevel, String>? prefixes,
    LogConfig? config,
  }) : _prefixes = prefixes ?? (config?.showEmoji == true ? LogCommons.levelEmojis : {}),
       config = config ?? LogConfig();

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
    final lines = buffer.toString().split('\n');
    
    return lines.map((line) => color(line)).toList();
  }

  @override
  String? getStepValue(LogStep step, LogRecord record) {
    switch (step) {
      case LogStep.LEVEL:
        if (!config.showLevel) return null;
        final prefix = _prefixes[record.level] ?? record.level.name;
        return '$prefix:';
      case LogStep.MESSAGE:
        return stringify(record.message);
      case LogStep.TIMESTAMP:
        if (!config.showTimestamp) return null;
        if (config.showTimeOnly) {
          final time = record.time.toLocal();
          return '[${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}]';
        }
        return '[${config.useHumanReadableTime ? LogCommons.formatTimestamp(record.time, true) : record.time.toIso8601String()}]';
      case LogStep.DATE:
        if (!config.showDateOnly || !config.showTimestamp) return null;
        return '[${record.time.toIso8601String().split('T')[0]}]';
      case LogStep.TAG:
        return (config.showTag && record.loggerName != null && record.loggerName!.isNotEmpty) ? '[${record.loggerName}]' : null;
      case LogStep.ERROR:
        return (record.error != null) ? 'ERROR: ${record.error}' : null;
      case LogStep.STACKTRACE:
        return (record.stackTrace != null) ? '\nStack: ${record.stackTrace}' : null;
      case LogStep.THREAD:
        return config.showThread ? '[main]' : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? '($location)' : null;
    }
  }
}