import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// A widget that displays a rating icon based on the given rating value.
///
/// The user can provide a custom implementation for rating calculation by
/// passing a `customIconResolver` in [RatingIconConfig]. If not provided,
/// the default implementation will be used.
class RatingIcon extends StatelessWidget {
  /// The rating value to be displayed.
  final double rating;

  /// Configuration for customizing rating icons and calculations.
  final RatingIconConfig config;

  /// Optional text size for the rating text.
  final double? textSize;

  /// Optional color for the icons and text.
  final Color? color;

  /// Whether to include text value
  final bool showText;

  /// A widget that displays a rating icon based on the given rating value.
  ///
  /// The user can provide a custom implementation for rating calculation by
  /// passing a `customIconResolver` in [RatingIconConfig]. If not provided,
  /// the default implementation will be used.
  const RatingIcon({
    super.key,
    required this.rating,
    this.color,
    this.config = const RatingIconConfig(),
    this.textSize,
    this.showText = true
  });

  @override
  Widget build(BuildContext context) {
    if(showText) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            config.iconResolver.isNotNull ? config.iconResolver!(rating, config) : _getRatingIcon(),
            color: color ?? Theme.of(context).primaryColor,
            size: config.iconSize,
          ),
          TextBuilder(
            text: "$rating",
            color: color ?? Theme.of(context).primaryColor,
            size: Sizing.font(textSize ?? 14),
            weight: FontWeight.bold
          ),
        ],
      );
    } else {
      return Icon(
        config.iconResolver.isNotNull ? config.iconResolver!(rating, config) : _getRatingIcon(),
        color: color ?? Theme.of(context).primaryColor,
        size: config.iconSize,
      );
    }
  }

  /// Determines the appropriate rating icon based on the rating value.
  IconData _getRatingIcon() {
    if (rating >= config.fullStarValue) {
      return config.fullStarIcon;
    } else if (rating >= config.halfStarValue) {
      return config.halfStarIcon;
    } else {
      return config.emptyStarIcon;
    }
  }
}