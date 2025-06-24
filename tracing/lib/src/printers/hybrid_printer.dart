import '../enums/log_level.dart';
import '../models/log_record.dart';
import '../log_printer.dart';
import '../models/log_config.dart';
import 'pretty_printer.dart';
import 'simple_printer.dart';

/// {@template hybrid_printer}
/// A hybrid log printer that delegates printing based on log level.
///
/// This printer uses a [SimplePrinter] for `DEBUG` level logs (to maintain minimal,
/// performance-friendly output during development), and a [PrettyPrinter] for all
/// other levels, providing detailed and styled logs for higher severity messages.
///
/// Ideal for situations where verbose output is only needed for higher severity,
/// while keeping debug logs concise.
///
/// ### Example
///
/// ```dart
/// final printer = HybridPrinter(
///   config: LogConfig(showTimestamp: true, showLevel: true),
/// );
///
/// final debugLog = LogRecord(
///   level: LogLevel.DEBUG,
///   message: 'Debug info',
///   time: DateTime.now(),
/// );
///
/// final errorLog = LogRecord(
///   level: LogLevel.ERROR,
///   message: 'Something went wrong!',
///   time: DateTime.now(),
/// );
///
/// printer.log(debugLog); // Uses SimplePrinter
/// printer.log(errorLog); // Uses PrettyPrinter
/// ```
/// {@endtemplate}
class HybridPrinter extends LogPrinter {
  /// Printer used for non-debug logs.
  ///
  /// Defaults to [PrettyPrinter] if not explicitly provided.
  final LogPrinter _prettyPrinter;

  /// Printer used specifically for debug logs.
  ///
  /// Defaults to [SimplePrinter] if not explicitly provided.
  final LogPrinter _simplePrinter;

  /// {@macro hybrid_printer}
  ///
  /// [config] is passed to both the pretty and simple printers if custom printers are not provided.
  HybridPrinter({
    LogConfig? config,
    LogPrinter? prettyPrinter,
    LogPrinter? simplePrinter,
  })  : _prettyPrinter = prettyPrinter ?? PrettyPrinter(config: config),
        _simplePrinter = simplePrinter ?? SimplePrinter(config: config);

  @override
  List<String> log(LogRecord record) {
    if (record.level == LogLevel.DEBUG) {
      return _simplePrinter.log(record);
    } else {
      return _prettyPrinter.log(record);
    }
  }
}