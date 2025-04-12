import 'package:smart/ui.dart';

/// Extension methods for the `FloatingConfig` class to provide convenient
/// ways to modify its properties.
extension FloatingConfigExtension on FloatingConfig {
  /// Sets the left position of the floating widget.
  ///
  /// If `value` is not provided, it defaults to `0`.
  /// The right position is set to `null` to ensure only the left position is applied.
  FloatingConfig l([double value = 0]) {
    return copyWith(left: value, right: null);
  }

  /// Sets the right position of the floating widget.
  ///
  /// If `value` is not provided, it defaults to `0`.
  /// The left position is set to `null` to ensure only the right position is applied.
  FloatingConfig r([double value = 0]) {
    return copyWith(right: value, left: null);
  }

  /// Sets the top position of the floating widget.
  ///
  /// If `value` is not provided, it defaults to `0`.
  /// The bottom position is set to `null` to ensure only the top position is applied.
  FloatingConfig t([double value = 0]) {
    return copyWith(top: value, bottom: null);
  }

  /// Sets the bottom position of the floating widget.
  ///
  /// If `value` is not provided, it defaults to `0`.
  /// The top position is set to `null` to ensure only the bottom position is applied.
  FloatingConfig b([double value = 0]) {
    return copyWith(bottom: value, top: null);
  }

  /// Sets the width of the floating widget.
  ///
  /// This method creates a new `FloatingConfig` instance with the specified width.
  FloatingConfig w(double value) {
    return copyWith(width: value);
  }

  /// Sets the height of the floating widget.
  ///
  /// This method creates a new `FloatingConfig` instance with the specified height.
  FloatingConfig h(double value) {
    return copyWith(height: value);
  }

  /// Centers the floating widget within its parent.
  ///
  /// This method sets the left, right, top, and bottom positions to `null`,
  /// which effectively centers the widget.
  FloatingConfig center() {
    return copyWith(left: null, right: null, top: null, bottom: null);
  }

  /// Sets custom positions and dimensions for the floating widget.
  ///
  /// Allows specifying any combination of left, right, top, bottom, width, and height.
  /// Any parameter that is not provided will retain its existing value.
  FloatingConfig custom({
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? width,
    double? height,
  }) {
    return copyWith(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      width: width,
      height: height,
    );
  }
}