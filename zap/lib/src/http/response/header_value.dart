import 'dart:collection';

import '../../definitions.dart';

/// The header value
/// 
/// This is used to parse and handle the header value
class HeaderValue {
  String _value;
  Map<String, String?>? _parameters;
  Map<String, String?>? _unmodifiableParameters;

  /// Create a [HeaderValue]
  /// 
  /// Args:
  ///   value: The header value
  ///   parameters: The parameters of the header value
  HeaderValue([this._value = '', Headers? parameters]) {
    if (parameters != null) {
      _parameters = HashMap<String, String>.from(parameters);
    }
  }

  /// Parse a header value
  /// 
  /// Args:
  ///   value: The header value
  ///   parameterSeparator: The separator of parameters
  ///   valueSeparator: The separator of values
  ///   preserveBackslash: When true, the backslash will be preserved
  static HeaderValue parse(String value, {
    String parameterSeparator = ';',
    String? valueSeparator,
    bool preserveBackslash = false,
  }) {
    var result = HeaderValue();
    result._parse(value, parameterSeparator, valueSeparator, preserveBackslash);
    return result;
  }

  /// The value of the header
  String get value => _value;

  void _ensureParameters() {
    _parameters ??= HashMap<String, String>();
  }

  /// The parameters of the header value
  Map<String, String?>? get parameters {
    _ensureParameters();
    _unmodifiableParameters ??= UnmodifiableMapView(_parameters!);
    return _unmodifiableParameters;
  }

  /// Convert this [HeaderValue] to a string
  @override
  String toString() {
    var stringBuffer = StringBuffer();
    stringBuffer.write(_value);
    if (parameters != null && parameters!.isNotEmpty) {
      _parameters!.forEach((name, value) {
        stringBuffer
          ..write('; ')
          ..write(name)
          ..write('=')
          ..write(value);
      });
    }
    return stringBuffer.toString();
  }

  /// Parse the header value
  /// 
  /// Args:
  ///   value: The header value
  ///   parameterSeparator: The separator of parameters
  ///   valueSeparator: The separator of values
  ///   preserveBackslash: When true, the backslash will be preserved
  void _parse(String value, String parameterSeparator, String? valueSeparator, bool preserveBackslash) {
    var index = 0;

    bool done() => index == value.length;

    void bump() {
      while (!done()) {
        if (value[index] != ' ' && value[index] != '\t') return;
        index++;
      }
    }

    String parseValue() {
      var start = index;
      while (!done()) {
        if (value[index] == ' ' ||
            value[index] == '\t' ||
            value[index] == valueSeparator ||
            value[index] == parameterSeparator) {
          break;
        }
        index++;
      }
      return value.substring(start, index);
    }

    void expect(String expected) {
      if (done() || value[index] != expected) {
        throw StateError('Failed to parse header value');
      }
      index++;
    }

    void maybeExpect(String expected) {
      if (value[index] == expected) index++;
    }

    void parseParameters() {
      var parameters = HashMap<String, String?>();
      _parameters = UnmodifiableMapView(parameters);

      String parseParameterName() {
        var start = index;
        while (!done()) {
          if (value[index] == ' ' ||
              value[index] == '\t' ||
              value[index] == '=' ||
              value[index] == parameterSeparator ||
              value[index] == valueSeparator) {
            break;
          }
          index++;
        }
        return value.substring(start, index).toLowerCase();
      }

      String? parseParameterValue() {
        if (!done() && value[index] == '"') {
          var stringBuffer = StringBuffer();
          index++;
          while (!done()) {
            if (value[index] == '\\') {
              if (index + 1 == value.length) {
                throw StateError('Failed to parse header value');
              }
              if (preserveBackslash && value[index + 1] != '"') {
                stringBuffer.write(value[index]);
              }
              index++;
            } else if (value[index] == '"') {
              index++;
              break;
            }
            stringBuffer.write(value[index]);
            index++;
          }
          return stringBuffer.toString();
        } else {
          var val = parseValue();
          return val == '' ? null : val;
        }
      }

      while (!done()) {
        bump();
        if (done()) return;
        var name = parseParameterName();
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        maybeExpect('=');
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        var valueParameter = parseParameterValue();
        if (name == 'charset' && valueParameter != null) {
          valueParameter = valueParameter.toLowerCase();
        }
        parameters[name] = valueParameter;
        bump();
        if (done()) return;
        if (value[index] == valueSeparator) return;
        expect(parameterSeparator);
      }
    }

    bump();
    _value = parseValue();
    bump();
    if (done()) return;
    maybeExpect(parameterSeparator);
    parseParameters();
  }
}