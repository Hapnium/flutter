import '../enums/log_step.dart';

/// {@template log_config}
/// Configuration class that controls the appearance and content of log output.
///
/// Used by various log printers to determine which pieces of information
/// should be included and how they should be formatted.
/// 
/// {@endtemplate}
class LogConfig {
  /// Whether to show the full timestamp (date and time) in the log output.
  final bool showTimestamp;

  /// Whether to show only the time portion of the timestamp.
  ///
  /// Takes effect only if [showTimestamp] is `true`.
  final bool showTimeOnly;

  /// Whether to show only the date portion of the timestamp.
  ///
  /// Takes effect only if [showTimestamp] is `true`.
  final bool showDateOnly;

  /// Whether to include the log level (e.g., INFO, ERROR) in the output.
  final bool showLevel;

  /// Whether to include the logger name or tag in the output.
  final bool showTag;

  /// Whether to include the thread or isolate identifier.
  final bool showThread;

  /// Whether to display timestamps in a human-readable format
  /// (e.g., `Jun 23, 2025 14:58:22`) instead of ISO 8601.
  final bool useHumanReadableTime;

  /// Whether to include emojis representing the log level (e.g., 🟢, 🔴).
  final bool showEmoji;

  /// Whether to show the location of the log call (e.g., file/line).
  final bool showLocation;

  /// The ordered list of log steps that define how a log message is composed.
  ///
  /// This determines what information is shown and in what order.
  /// Defaults to [LogStep.defaultSteps] if not specified.
  final List<LogStep> steps;

  /// Creates a new [LogConfig] with custom display options.
  ///
  /// All options are enabled by default.
  /// 
  /// {@macro log_config}
  LogConfig({
    this.showTimestamp = true,
    this.showTimeOnly = true,
    this.showDateOnly = true,
    this.showLevel = true,
    this.showTag = true,
    this.showThread = true,
    this.useHumanReadableTime = true,
    this.showEmoji = true,
    this.showLocation = true,
    List<LogStep>? steps,
  }) : steps = steps ?? LogStep.defaultSteps;
}