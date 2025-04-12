import 'package:logger/logger.dart';
import 'package:tracing/tracing.dart';

class Logging implements LoggingService {
  @override
  void log(text, {String? prefix, String? from, bool? needHeader, LogMode? mode}) {
    String prefixText = prefix ?? "LogManager";
    bool showHeader = needHeader ?? true;
    LogMode logMode = mode ?? LogMode.INFO;

    var logger = Logger(
      filter: null,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: null,
    );

    String message;
    if (showHeader) {
      message = "$prefixText::: ${from != null ? "${from}__________________________" : ""} ${_buildFormattedText(text)}";
    } else {
      message = "$prefixText::: ${_buildFormattedText(text)}";
    }

    switch (logMode) {
      case LogMode.TRACE:
        logger.t(message);
        break;
      case LogMode.DEBUG:
        logger.d(message);
        break;
      case LogMode.INFO:
        logger.i(message);
        break;
      case LogMode.ERROR:
        logger.e(message, error: text);
        break;
      case LogMode.FATAL:
        logger.f(message, error: text, stackTrace: text);
        break;
      default:
        logger.d(message);
    }
  }

  String _buildFormattedText(dynamic text) {
    if (text is String) {
      return text;
    } else if (text is List) {
      final buffer = StringBuffer();
      buffer.write("[");
      for (var item in text) {
        buffer.write(_buildFormattedText(item));
        buffer.write(", ");
      }
      buffer.write("]");
      return buffer.toString().replaceAll(", ]", "]");
    } else if (text is Map) {
      final buffer = StringBuffer();
      buffer.writeln("{");
      for (var key in text.keys) {
        final value = text[key];
        buffer.write("  \"$key\": ${_buildFormattedText(value)},");
        buffer.writeln();
      }
      buffer.write("}");
      return buffer.toString().replaceAll(", }", "}");
    } else {
      return text.toString();
    }
  }
}