import '../helpers/ansi_color.dart';
import '../helpers/commons.dart';
import '../helpers/stack_trace_parser.dart';
import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import '../enums/log_step.dart';

/// {@template pretty_printer}
/// A visually styled log printer that wraps log output in a clean box format.
///
/// This printer improves readability during development by using Unicode borders,
/// emoji icons (optional), and structured multi-line formatting. It is useful for
/// console applications, CLI tools, or Flutter/Dart debug output.
///
/// ### Example Output:
/// ```
/// ┌──────────────────────────────────────────────────────────────────────────────
/// │ 💬 MESSAGE: User signed in
/// │ ⏰ TIME: 2025-06-23 10:20:01.235
/// │ 🏷️ TAG: AuthService
/// ├──────────────────────────────────────────────────────────────────────────────
/// │ ❌ ERROR: Missing token
/// │ 📋 STACK:
/// │ #0 AuthService.login (auth_service.dart:42)
/// │ #1 ...
/// └──────────────────────────────────────────────────────────────────────────────
/// ```
/// 
/// Configuration is controlled via [LogConfig], and log content is selected
/// based on [LogStep] order.
/// {@endtemplate}
class PrettyPrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '┄';
  static const singleDivider = '─';

  /// Number of stack trace lines to show for normal logs
  /// 
  /// Defaults to 2.
  final int methodCount;

  /// Number of stack trace lines to show for error logs
  /// 
  /// Defaults to 8.
  final int errorMethodCount;

  /// Maximum line length for the log output
  /// 
  /// Defaults to 120.
  final int lineLength;

  /// Configuration for the printer
  /// 
  /// Defaults to [LogConfig.defaultConfig].
  final LogConfig config;

  /// List of paths to exclude from stack traces
  /// 
  /// Defaults to [StackTraceParser.defaultExcludePaths].
  final List<String> excludePaths;

  /// Index to start from in the stack trace
  /// 
  /// Defaults to 0.
  final int stackTraceBeginIndex;

  /// {@macro prettyPrinter}
  PrettyPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    LogConfig? config,
    this.stackTraceBeginIndex = 0,
    List<String>? excludePaths,
  }) : config = config ?? LogConfig(), excludePaths = excludePaths ?? StackTraceParser.defaultExcludePaths;

  @override
  List<String> log(LogRecord record) {
    final buffer = <String>[];
    final color = levelColor(record.level);
    
    buffer.add(_formatTopBorder(color));
    
    bool hasContent = false;
    for (final step in config.steps) {
      final content = getStepValue(step, record);
      if (content != null) {
        if (hasContent && (step == LogStep.STACKTRACE || step == LogStep.ERROR)) {
          buffer.add(_formatMiddleBorder(color));
        }
        buffer.addAll(_formatSection(color, content));
        hasContent = true;
      }
    }
    
    buffer.add(_formatBottomBorder(color));
    return buffer;
  }

  @override
  String? getStepValue(LogStep step, LogRecord record) {
    switch (step) {
      case LogStep.TIMESTAMP:
        if (!config.showTimestamp) return null;
        final time = config.useHumanReadableTime 
            ? LogCommons.formatTimestamp(record.time, true)
            : record.time.toIso8601String();
        return '⏰ TIME: $time';
      case LogStep.DATE:
        if (!config.showDateOnly || !config.showTimestamp) return null;
        return '📅 DATE: ${record.time.toIso8601String().split('T')[0]}';
      case LogStep.LEVEL:
        if (!config.showLevel) return null;
        final emoji = config.showEmoji ? LogCommons.levelEmojis[record.level] ?? '' : '';
        return '$emoji LEVEL: ${record.level.name}';
      case LogStep.TAG:
        return (config.showTag && record.loggerName != null && record.loggerName!.isNotEmpty) 
            ? '🏷️ TAG: ${record.loggerName}' 
            : null;
      case LogStep.MESSAGE:
        return '💬 MESSAGE: ${stringify(record.message)}';
      case LogStep.ERROR:
        return (record.error != null) ? '❌ ERROR: ${record.error}' : null;
      case LogStep.STACKTRACE:
        if (record.stackTrace == null) return null;
        final methodCountToUse = record.error != null ? errorMethodCount : methodCount;
        final formattedStack = StackTraceParser.formatStackTrace(
          record.stackTrace,
          methodCountToUse,
          excludePaths: excludePaths,
          stackTraceBeginIndex: stackTraceBeginIndex,
        );
        return formattedStack != null ? '📋 STACK:\n$formattedStack' : null;
      case LogStep.THREAD:
        return config.showThread ? '🧵 THREAD: main' : null;
      case LogStep.LOCATION:
        if (!config.showLocation) return null;
        final location = record.location;
        return location != null ? '📍 LOCATION: $location' : null;
    }
  }

  /// Returns the formatted top border for the log message.
  ///
  /// The border is styled with Unicode characters and colored based on the log level.
  String _formatTopBorder(AnsiColor color) {
    return color('$topLeftCorner${singleDivider * (lineLength - 1)}');
  }

  /// Returns the formatted middle border for the log message.
  ///
  /// The border is styled with Unicode characters and colored based on the log level.
  String _formatMiddleBorder(AnsiColor color) {
    return color('$middleCorner${doubleDivider * (lineLength - 1)}');
  }

  /// Returns the formatted bottom border for the log message.
  ///
  /// The border is styled with Unicode characters and colored based on the log level.
  String _formatBottomBorder(AnsiColor color) {
    return color('$bottomLeftCorner${singleDivider * (lineLength - 1)}');
  }

  /// Returns the formatted section for the log message.
  ///
  /// The section is styled with Unicode characters and colored based on the log level.
  List<String> _formatSection(AnsiColor color, String content) {
    final lines = content.split('\n');
    return lines.map((line) => color('$verticalLine $line')).toList();
  }
}