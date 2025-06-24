/// Defines individual components (steps) that can be included in log output.
///
/// Used by log printers to control the composition of each log message.
/// Enables granular formatting such as showing only time, message, or level.
enum LogStep {
  /// Timestamp of the log, including date and time.
  TIMESTAMP,

  /// Only the date portion of the timestamp (useful when omitting time).
  DATE,

  /// Log level indicator (e.g., INFO, ERROR), optionally with emoji.
  LEVEL,

  /// Optional user-defined tag or logger name to identify the log source.
  TAG,

  /// Indicates the thread or isolate where the log originated.
  THREAD,

  /// Represents the code location where the log was triggered (if available).
  LOCATION,

  /// The main log message or content.
  MESSAGE,

  /// Any error object attached to the log event.
  ERROR,

  /// A stack trace, usually included when an error is present.
  STACKTRACE;

  /// Default ordering and selection of log steps used by printers unless overridden.
  static List<LogStep> get defaultSteps => [
    DATE,
    TIMESTAMP,
    TAG,
    LEVEL,
    MESSAGE,
    THREAD,
    LOCATION,
    ERROR,
    STACKTRACE,
  ];
}