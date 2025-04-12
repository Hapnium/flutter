part of 'rating_bar.dart';

/// Defines widgets to be used as rating bar items, allowing for customization of each rating state.
///
/// This class encapsulates the widgets used to represent different states of a
/// rating bar item, providing flexibility and customization for fully rated,
/// half-rated, and unrated states. This allows developers to use any widget
/// (e.g., icons, images, custom shapes) to visually represent the rating.
///
/// **Purpose:**
///
/// The `RatingBarWidget` class is designed to be used with a rating bar widget
/// that needs to display different visual representations for each rating level.
/// It separates the logic of the rating bar from the visual appearance of the
/// rating items, making the rating bar more adaptable and reusable.
///
/// **Usage:**
///
/// Create an instance of `RatingBarWidget` by providing widgets for each of
/// the three states: `full`, `half`, and `empty`. These widgets will be used
/// to represent the different rating levels in the rating bar.
///
/// **Example:**
///
/// ```dart
/// RatingBarWidget(
///   full: Icon(Icons.star, color: Colors.amber),
///   half: Icon(Icons.star_half, color: Colors.amber),
///   empty: Icon(Icons.star_border, color: Colors.grey),
/// )
/// ```
///
/// **Customization:**
///
/// You can use any `Widget` for each state, allowing for extensive customization.
/// This includes using custom images, shapes, or even animated widgets.
///
/// **Parameters:**
///
/// * `full`: The widget representing a fully rated item. This is typically
///   an icon or image that indicates a complete rating.
/// * `half`: The widget representing a half-rated item. This is used when
///   a rating is partially filled.
/// * `empty`: The widget representing an unrated item. This is used to
///   indicate an unrated or empty rating slot.
class RatingBarWidget {
  /// Defines the widget to be used as a rating bar item when the item is fully rated.
  final Widget full;

  /// Defines the widget to be used as a rating bar item when only the half portion of the item is rated.
  final Widget half;

  /// Defines the widget to be used as a rating bar item when the item is unrated.
  final Widget empty;

  /// Creates a [RatingBarWidget] instance.
  ///
  /// Requires widgets for all three states: `full`, `half`, and `empty`.
  ///
  /// **Parameters:**
  ///
  /// * `full`: The widget representing a fully rated item.
  /// * `half`: The widget representing a half-rated item.
  /// * `empty`: The widget representing an unrated item.
  RatingBarWidget({
    required this.full,
    required this.half,
    required this.empty,
  });
}