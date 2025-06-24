// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:tracing/tracing.dart' show console;

enum LogMode { TRACE, DEBUG, INFO, WARN, ERROR, FATAL }

class _ZapLogger {
  void log(
    dynamic message, {
    String? prefix,
    String? from,
    bool needHeader = true,
    LogMode mode = LogMode.INFO,
  }) {
    switch(mode) {
      case LogMode.TRACE:
        console.trace(message, tag: from ?? prefix);
        break;
      case LogMode.DEBUG:
        console.debug(message, tag: from ?? prefix);
        break;
      case LogMode.INFO:
        console.info(message, tag: from ?? prefix);
        break;
      case LogMode.WARN:
        console.warn(message, tag: from ?? prefix);
        break;
      case LogMode.ERROR:
        console.error(message, tag: from ?? prefix);
        break;
      case LogMode.FATAL:
        console.fatal(message, tag: from ?? prefix);
        break;
    }
  }
}

class ZapImpl {
  bool _showLog = false;
  final _logger = _ZapLogger();

  // ignore: unnecessary_getters_setters
  bool get showLog => _showLog;

  set showLog(bool value) {
    _showLog = value;
  }

  /// Logs a message to the console with the specified options.
  ///
  /// If `showLog` is set to `false`, the message will not be logged.
  void log(
    dynamic message, {
    LogMode mode = LogMode.INFO,
    String? prefix,
    String? from,
    bool needHeader = true,
  }) {
    if (showLog) {
      _logger.log(
        message,
        prefix: prefix,
        from: from,
        needHeader: needHeader,
        mode: mode,
      );
    }
  }

  /// Logs a trace message to the console.
  void trace(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.TRACE, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs a debug message to the console.
  void debug(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.DEBUG, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs an info message to the console.
  void info(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.INFO, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs a warning message to the console.
  void warn(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.WARN, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs an error message to the console.
  void error(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.ERROR, prefix: prefix, from: from, needHeader: needHeader);
  }

  /// Logs a fatal message to the console.
  void fatal(dynamic message, {String? prefix, String? from, bool needHeader = true}) {
    log(message, mode: LogMode.FATAL, prefix: prefix, from: from, needHeader: needHeader);
  }
}

final Z = ZapImpl();