// ignore_for_file: constant_identifier_names

import 'http_content_type.dart';

/// {@template constants}
/// 
/// This class contains constants used in the HTTP client.
/// 
/// {@endtemplate}
abstract class Constants {
  /// {@macro constants}
  /// 
  /// Example:
  /// ```dart
  /// final headers = {
  ///   'Content-Type': HttpContentType.APPLICATION_JSON,
  /// };
  /// ```
  static const String DEFAULT_CONTENT_TYPE = '${HttpContentType.APPLICATION_JSON}; charset=utf-8';

  /// {@macro constants}
  /// 
  /// Example:
  /// ```dart
  /// final headers = {
  ///   'Content-Type': HttpContentType.APPLICATION_JSON,
  /// };
  /// ```
  static const String DEFAULT_USER_AGENT = 'hapx-client';
}