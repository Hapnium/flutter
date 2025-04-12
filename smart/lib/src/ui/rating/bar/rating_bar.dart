import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

part 'rating_bar_widget.dart';
part 'rating_bar_state.dart';

/// A widget to receive rating input from users or to display ratings.
///
/// [RatingBar] can be used to both receive rating input from users and to
/// display ratings. For a read-only version that supports fractional rating
/// values, consider using [RatingBarIndicator] instead.
///
/// **Usage:**
///
/// Use `RatingBar` to create an interactive rating bar where users can tap or
/// drag to select a rating. You can customize the appearance of the rating
/// items using `RatingBarWidget` or `itemBuilder`.
///
/// **Example:**
///
/// ```dart
/// RatingBar(
///   initialRating: 3,
///   minRating: 1,
///   direction: Axis.horizontal,
///   allowHalfRating: true,
///   itemCount: 5,
///   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
///   itemBuilder: (context, _) => Icon(
///     Icons.star,
///     color: Colors.amber,
///   ),
///   onRatingUpdate: (rating) {
///     print(rating);
///   },
/// )
/// ```
class RatingBar extends StatefulWidget {
  /// Callback that returns the current rating whenever the rating is updated.
  ///
  /// [updateOnDrag] can be used to control when the callback is triggered
  /// during drag gestures.
  final ValueChanged<double> onRatingUpdate;

  /// Defines the color for the glow effect when the rating bar is touched.
  ///
  /// Defaults to `ColorScheme.secondary` if available, otherwise no glow.
  final Color? glowColor;

  /// Sets the maximum rating value.
  ///
  /// Defaults to [itemCount].
  final double? maxRating;

  /// The text flows from right to left if [textDirection] = TextDirection.rtl.
  final TextDirection? textDirection;

  /// Defines the color for the unrated portion of the rating bar.
  ///
  /// Defaults to `ThemeData.disabledColor`.
  final Color? unratedColor;

  /// Enables half-rating support if set to `true`.
  ///
  /// Defaults to `false`.
  final bool allowHalfRating;

  /// Direction of the rating bar.
  ///
  /// Defaults to `Axis.horizontal`.
  final Axis direction;

  /// Enables the glow effect when the rating bar is touched.
  ///
  /// Defaults to `true`.
  final bool glow;

  /// Defines the radius of the glow effect.
  ///
  /// Defaults to `2`.
  final double glowRadius;

  /// Disables any gestures over the rating bar if set to `true`.
  ///
  /// Defaults to `false`.
  final bool ignoreGestures;

  /// Defines the initial rating value.
  ///
  /// Defaults to `0.0`.
  final double initialRating;

  /// Defines the total number of rating bar items.
  ///
  /// Defaults to `5`.
  final int itemCount;

  /// The amount of space by which to inset each rating item.
  final EdgeInsetsGeometry itemPadding;

  /// Defines the width and height of each rating item in the bar.
  ///
  /// Defaults to `40.0`.
  final double itemSize;

  /// Sets the minimum rating value.
  ///
  /// Defaults to `0`.
  final double minRating;

  /// Disables drag-to-rate functionality if set to `true`.
  ///
  /// Note: Enabling this mode disables half-rating capability.
  /// Defaults to `false`.
  final bool tapOnlyMode;

  /// Defines whether the `onRatingUpdate` callback is triggered during drag gestures.
  ///
  /// Defaults to `false`.
  final bool updateOnDrag;

  /// How the items within the [RatingBar] should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the items in
  /// the RatingBar are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to `WrapAlignment.start`.
  final WrapAlignment wrapAlignment;

  /// Used to build the rating bar items.
  final IndexedWidgetBuilder? _itemBuilder;

  /// Used to customize the rating bar items.
  final RatingBarWidget? _child;

  /// Creates [RatingBar] using the [child] for customization.
  const RatingBar({
    /// Customizes the Rating Bar item with [RatingBarWidget].
    required RatingBarWidget child,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
  })  : _itemBuilder = null,
        _child = child;

  /// Creates [RatingBar] using the [itemBuilder] for customization.
  const RatingBar.builder({
    /// Widget for each rating bar item.
    required IndexedWidgetBuilder itemBuilder,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
  })  : _itemBuilder = itemBuilder,
        _child = null;

  @override
  _RatingBarState createState() => _RatingBarState();
}