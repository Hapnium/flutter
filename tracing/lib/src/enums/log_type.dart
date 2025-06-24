/// Specifies the overall formatting strategy used for log output.
///
/// Different [LogType]s determine how verbose, styled, or structured the logs are.
enum LogType {
  /// Basic flat log format with minimal styling.
  FLAT,

  /// Flat layout with structured key/value formatting.
  FLAT_STRUCTURED,

  /// Pretty format with boxed, styled output.
  PRETTY,

  /// Pretty format with structured sections and symbols.
  PRETTY_STRUCTURED,

  /// Prefix-based logs, where each line begins with a level/tag.
  PREFIX,

  /// printf-style formatting with placeholders and patterns.
  FMT,

  /// Compact single-line logs suitable for CLI or minimal environments.
  SIMPLE,

  /// Hybrid format combining flat and pretty elements.
  HYBRID,
}