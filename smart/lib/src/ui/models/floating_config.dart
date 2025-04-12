/// Configuration class for specifying the position and size of a floating widget.
///
/// This class encapsulates the positioning and sizing parameters for a floating widget,
/// allowing developers to easily define its placement and dimensions relative to the edges
/// of its parent widget.
class FloatingConfig {
  /// The distance from the left edge of the parent widget.
  final double? left;

  /// The distance from the right edge of the parent widget.
  final double? right;

  /// The distance from the bottom edge of the parent widget.
  final double? bottom;

  /// The distance from the top edge of the parent widget.
  final double? top;

  /// The width of the floating widget.
  final double? width;

  /// The height of the floating widget.
  final double? height;

  /// Creates a [FloatingConfig] instance.
  ///
  /// Allows customization of the floating widget's position and size by specifying
  /// the distances from the left, right, bottom, and top edges, as well as its width and height.
  ///
  /// All parameters are optional and default to `0`.
  ///
  /// Example usage:
  /// ```dart
  /// final config = FloatingConfig(left: 10, top: 20, width: 100, height: 50);
  /// ```
  const FloatingConfig({
    this.left,
    this.right,
    this.bottom,
    this.top,
    this.width,
    this.height,
  });

  /// Creates a new instance of [FloatingConfig] with updated values.
  ///
  /// The [copyWith] method allows modifying specific properties while keeping
  /// the rest unchanged.
  ///
  /// Example usage:
  /// ```dart
  /// final config = FloatingConfig(left: 10, top: 20, width: 100, height: 50);
  /// final newConfig = config.copyWith(left: 30, height: 60); // Updates left and height, keeps other values unchanged.
  /// ```
  FloatingConfig copyWith({
    double? left,
    double? right,
    double? bottom,
    double? top,
    double? width,
    double? height,
  }) {
    return FloatingConfig(
      left: left ?? this.left,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      top: top ?? this.top,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}