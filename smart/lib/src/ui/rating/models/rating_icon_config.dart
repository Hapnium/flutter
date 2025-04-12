import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// Configuration class for customizing rating icons and behavior.
///
/// Allows users to define a custom function for determining which icon to
/// display based on the rating value.
class RatingIconConfig {
  /// The icon to display for a full star rating.
  final IconData fullStarIcon;

  /// The icon to display for a half star rating.
  final IconData halfStarIcon;

  /// The icon to display for an empty star rating.
  final IconData emptyStarIcon;

  /// The size of the rating icons.
  final Double iconSize;

  /// The rating threshold for a full star.
  final Double fullStarValue;

  /// The rating threshold for a half star.
  final Double halfStarValue;

  /// A custom function to determine the icon based on the rating value.
  /// If null, the default implementation will be used.
  final RatingIconResolver? iconResolver;

  const RatingIconConfig({
    this.fullStarIcon = Icons.star_rounded,
    this.halfStarIcon = Icons.star_half_rounded,
    this.emptyStarIcon = Icons.star_border_rounded,
    this.iconSize = 18,
    this.fullStarValue = 5.0,
    this.halfStarValue = 0.9,
    this.iconResolver,
  });
}