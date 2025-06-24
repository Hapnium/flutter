// ignore_for_file: constant_identifier_names

import 'dart:convert';

import '../../definitions.dart';

/// {@template is_token_char}
/// 
/// Args:
///   byte: The byte to check
/// 
/// Returns:
///   Whether the byte is a token character
/// 
/// {@endtemplate}
bool isTokenChar(int byte) {
  return byte > 31 && byte < 128 && !SEPARATOR_MAP[byte];
}

/// {@template is_value_char}
/// 
/// Args:
///   byte: The byte to check
/// 
/// Returns:
///   Whether the byte is a value character
/// 
/// {@endtemplate}
bool isValueChar(int byte) {
  return (byte > 31 && byte < 128) ||
      (byte == CharCode.SP) ||
      (byte == CharCode.HT);
}

/// {@template char_code}
/// 
/// Args:
///   HT: Horizontal tab
///   LF: Line feed
///   CR: Carriage return
///   SP: Space
///   COMMA: Comma
///   SLASH: Slash
///   ZERO: Zero
///   ONE: One
///   COLON: Colon
///   SEMI_COLON: Semicolon
/// 
/// {@endtemplate}
class CharCode {
  /// {@macro char_code}
  static const int HT = 9;
  static const int LF = 10;
  static const int CR = 13;
  static const int SP = 32;
  static const int COMMA = 44;
  static const int SLASH = 47;
  static const int ZERO = 48;
  static const int ONE = 49;
  static const int COLON = 58;
  static const int SEMI_COLON = 59;
}

const bool F = false;

const bool T = true;
const SEPARATOR_MAP = [
  F, F, F, F, F, F, F, F, F, T, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, T, F, T, F, F, F, F, F, T, T, F, F, T, F, F, T, //
  F, F, F, F, F, F, F, F, F, F, T, T, T, T, T, T, T, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, T, T, T, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, T, F, T, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, //
  F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F
];

String validateField(String field) {
  for (var i = 0; i < field.length; i++) {
    if (!isTokenChar(field.codeUnitAt(i))) {
      throw FormatException(
          'Invalid HTTP header field name: ${json.encode(field)}', field, i);
    }
  }
  return field.toLowerCase();
}

// BodyByteStream toBodyByteStreamStream(BodyByteStream stream) {
//   return (stream);
// }

final _asciiOnly = RegExp(r'^[\x00-\x7F]+$');

final newlineRegExp = RegExp(r'\r\n|\r|\n');

/// Returns whether [string] is composed entirely of ASCII-compatible
/// characters.
bool isPlainAscii(String string) => _asciiOnly.hasMatch(string);

/// {@template get_boundary}
/// 
/// Args:
///   GET_BOUNDARY: The boundary string
/// 
/// {@endtemplate}
const String GET_BOUNDARY = 'hap-http-boundary-';

/// {@template browser_encode}
/// 
/// Args:
///   value: The value to encode
/// 
/// Returns:
///   The encoded value
/// 
/// {@endtemplate}
String browserEncode(String value) {
  return value.replaceAll(newlineRegExp, '%0D%0A').replaceAll('"', '%22');
}

const BodyBytes boundaryCharacters = <int>[
  43,
  95,
  45,
  46,
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  88,
  89,
  90,
  97,
  98,
  99,
  100,
  101,
  102,
  103,
  104,
  105,
  106,
  107,
  108,
  109,
  110,
  111,
  112,
  113,
  114,
  115,
  116,
  117,
  118,
  119,
  120,
  121,
  122
];