import 'package:flutter/cupertino.dart';

/// A configuration class for managing system-safe area constraints.
///
/// This class provides customizable options to control how a [SafeArea] widget
/// handles system UI intrusions such as notches, status bars, and navigation bars.
/// 
/// You can enable or disable safe area constraints for each side of the screen,
/// define minimum padding values, and choose whether to maintain bottom view padding.
///
/// ## Example Usage:
/// ```dart
/// SafeAreaConfig config = SafeAreaConfig(
///   left: false,
///   top: true,
///   right: false,
///   bottom: true,
///   minimum: EdgeInsets.all(10),
///   maintainBottomViewPadding: true,
/// );
///
/// SafeAreaConfig updatedConfig = config.copyWith(top: false, bottom: false);
/// ```
class SafeAreaConfig {
  /// Creates a new [SafeAreaConfig] instance with customizable safe area options.
  ///
  /// All parameters have default values to ensure predictable behavior.
  const SafeAreaConfig({
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  /// Whether to avoid system intrusions on the left side of the screen.
  ///
  /// Defaults to `true`.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  ///
  /// Defaults to `true`.
  final bool top;

  /// Whether to avoid system intrusions on the right side of the screen.
  ///
  /// Defaults to `true`.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  ///
  /// Defaults to `true`.
  final bool bottom;

  /// Defines the minimum padding to apply along each side.
  ///
  /// The actual padding applied will be the greater of this value and the system's
  /// media padding.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets minimum;

  /// Whether to maintain the bottom [MediaQueryData.viewPadding] instead of
  /// the bottom [MediaQueryData.padding].
  ///
  /// This is useful for preventing UI shifts when a software keyboard is opened.
  ///
  /// Defaults to `false`.
  final bool maintainBottomViewPadding;

  /// Creates a copy of this [SafeAreaConfig] but with the given fields replaced with new values.
  ///
  /// This allows partial modification without altering the original instance.
  ///
  /// ## Example:
  /// ```dart
  /// SafeAreaConfig config = SafeAreaConfig();
  /// SafeAreaConfig updatedConfig = config.copyWith(top: false, bottom: false);
  /// ```
  SafeAreaConfig copyWith({
    bool? left,
    bool? top,
    bool? right,
    bool? bottom,
    EdgeInsets? minimum,
    bool? maintainBottomViewPadding,
  }) {
    return SafeAreaConfig(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      minimum: minimum ?? this.minimum,
      maintainBottomViewPadding: maintainBottomViewPadding ?? this.maintainBottomViewPadding,
    );
  }

  @override
  String toString() {
    return 'SafeAreaConfig(left: $left, top: $top, right: $right, bottom: $bottom, minimum: $minimum, maintainBottomViewPadding: $maintainBottomViewPadding)';
  }
}