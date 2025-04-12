import 'package:flutter/material.dart';

part 'rating_bar_indicator_state.dart';

/// A widget to display a rating indicator based on a given [rating] value.
///
/// This is a read-only version of [RatingBar], designed for displaying ratings
/// rather than capturing user input. It is particularly useful for showing
/// pre-determined ratings, such as those fetched from a database or API.
///
/// Unlike [RatingBar], which is interactive, `RatingBarIndicator` does not
/// respond to user gestures. It simply displays the rating value provided
/// through the [rating] property.
///
/// **Key Features:**
///
/// * Displays a rating as a row of customizable items.
/// * Supports fractional rating values for more precise representations.
/// * Read-only; does not allow user interaction.
/// * Customizable appearance through `itemBuilder`.
///
/// **Usage:**
///
/// Use `RatingBarIndicator` to display ratings when you only need to show
/// a value and not capture user input. For interactive rating capture,
/// use [RatingBar].
///
/// **Example:**
///
/// ```dart
/// RatingBarIndicator(
///   rating: 3.5,
///   itemCount: 5,
///   itemSize: 24.0,
///   itemBuilder: (context, index) {
///     return Icon(
///       Icons.star,
///       color: Colors.amber,
///     );
///   },
/// )
/// ```
class RatingBarIndicator extends StatefulWidget {
  /// {@macro flutterRatingBar.itemBuilder}
  /// Widget for each rating bar item.
  /// This allows you to customize the appearance of each item in the rating bar.
  final IndexedWidgetBuilder itemBuilder;

  /// {@macro flutterRatingBar.textDirection}
  /// The text flows from right to left if [textDirection] = TextDirection.rtl.
  final TextDirection? textDirection;

  /// {@macro flutterRatingBar.unratedColor}
  /// Defines the color for the unrated portion of the rating bar.
  /// If not specified, the unrated portion will use the default color.
  final Color? unratedColor;

  /// {@macro flutterRatingBar.direction}
  /// Direction of the rating bar. Defaults to `Axis.horizontal`.
  final Axis direction;

  /// {@macro flutterRatingBar.itemCount}
  /// Defines the total number of rating bar items. Defaults to 5.
  final int itemCount;

  /// {@macro flutterRatingBar.itemPadding}
  /// The amount of space by which to inset each rating item. Defaults to EdgeInsets.zero.
  final EdgeInsets itemPadding;

  /// {@macro flutterRatingBar.itemSize}
  /// Defines the width and height of each rating item in the bar. Defaults to 40.0.
  final double itemSize;

  /// Controls the scrolling behaviour of the rating bar.
  /// Since this is a read-only widget, scrolling is disabled by default.
  /// Defaults to [NeverScrollableScrollPhysics].
  final ScrollPhysics physics;

  /// Defines the rating value to be displayed. Defaults to 0.0.
  /// This value determines how many items are filled.
  final double rating;

  /// Creates a [RatingBarIndicator] widget.
  RatingBarIndicator({
    required this.itemBuilder,
    this.textDirection,
    this.unratedColor,
    this.direction = Axis.horizontal,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.physics = const NeverScrollableScrollPhysics(),
    this.rating = 0.0,
  });

  @override
  _RatingBarIndicatorState createState() => _RatingBarIndicatorState();
}