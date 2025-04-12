import 'package:flutter/cupertino.dart';
import 'package:hapnium/hapnium.dart';

/// A widget that provides spacing in layouts using flexible (`Spacer`) or fixed (`SizedBox`) spacing.
///
/// This widget allows you to create horizontal or vertical spaces within layouts, either by using a `Spacer`
/// for flexible space or a `SizedBox` for fixed space.
///
/// ## Usage:
/// - `Spacing.flexible()` - Uses `Spacer` to create a flexible space.
/// - `Spacing.vertical(10)` - Creates a fixed vertical space of `10` pixels.
/// - `Spacing.horizontal(10)` - Creates a fixed horizontal space of `10` pixels.
class Spacing extends StatelessWidget {
  /// The height of the space (used for vertical spacing).
  final Double? height;

  /// The width of the space (used for horizontal spacing).
  final Double? width;

  /// Determines if a flexible spacer (`Spacer`) should be used.
  final Boolean _spaced;

  /// The flex value for the `Spacer` (used when `_spaced` is `true`).
  final Integer? flex;

  /// Creates a flexible spacer that takes up available space.
  ///
  /// This constructor creates a `Spacer` with the specified [flex] value, defaulting to `1`.
  ///
  /// Example:
  /// ```dart
  /// Row(
  ///   children: [
  ///     Text("Left"),
  ///     Spacing.flexible(2),
  ///     Text("Right"),
  ///   ],
  /// )
  /// ```
  const Spacing.flexible([this.flex = 1])
      : height = null,
        width = null,
        _spaced = true;

  /// Creates a vertical space with a specified [height].
  ///
  /// Example:
  /// ```dart
  /// Column(
  ///   children: [
  ///     Text("Above"),
  ///     Spacing.vertical(20),  // 20 pixels of vertical space
  ///     Text("Below"),
  ///   ],
  /// )
  /// ```
  const Spacing.vertical(this.height)
      : width = null,
        flex = null,
        _spaced = false;

  /// Creates a horizontal space with a specified [width].
  ///
  /// Example:
  /// ```dart
  /// Row(
  ///   children: [
  ///     Icon(Icons.star),
  ///     Spacing.horizontal(10), // 10 pixels of horizontal space
  ///     Icon(Icons.star),
  ///   ],
  /// )
  /// ```
  const Spacing.horizontal(this.width)
      : height = null,
        flex = null,
        _spaced = false;

  /// Creates an empty space.
  ///
  /// This constructor creates an empty `SizedBox.shrink()`.
  const Spacing() : height = null, width = null, _spaced = false, flex = null;

  @override
  Widget build(BuildContext context) {
    if (_spaced) {
      return Spacer(flex: flex ?? 1);
    } else if (height.isNotNull) {
      return SizedBox(height: height);
    } else if (width.isNotNull) {
      return SizedBox(width: width);
    } else {
      return SizedBox.shrink();
    }
  }
}