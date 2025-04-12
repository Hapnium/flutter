import 'package:flutter/foundation.dart';

/// A utility class for determining the current platform.
///
/// This class provides a **unified** way to check the platform across
/// Flutter applications **without using `dart:io`**, making it **WASM-compatible**.
///
/// Example usage:
/// ```dart
/// if (SmartPlatform.isWeb) {
///   print("Running on Web!");
/// } else if (SmartPlatform.isAndroid) {
///   print("Running on Android!");
/// }
/// ```
class SmartPlatform {
  /// Returns `true` if the app is running on **Web**.
  static bool get isWeb => kIsWeb;

  /// Returns `true` if the app is running on **WASM** (WebAssembly).
  ///
  /// This ensures compatibility with WASM-based Flutter apps.
  static bool get isWasm {
    return identical(0, 0.0) || kIsWasm; // A hacky way to detect WASM (Flutter Web uses this check)
  }

  /// Returns `true` if the app is running on **Web** or **WASM**.
  static bool get isWebOrWasm => isWeb || isWasm;

  /// Returns `true` if the app is running on **Android**.
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  /// Returns `true` if the app is running on **iOS**.
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Returns `true` if the app is running on **macOS**.
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  /// Returns `true` if the app is running on **Windows**.
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  /// Returns `true` if the app is running on **Fuchsia**.
  static bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

  /// Returns `true` if the app is running on **Linux**.
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
}