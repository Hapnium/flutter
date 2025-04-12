import 'package:flutter/cupertino.dart';
import 'package:hapnium/hapnium.dart';

extension ColorExtensions on Color {
  /// Lightens a color by a given percentage.
  ///
  /// [percent] must be between 0 and 100.
  Color lighten(double percent) {
    assert(0 <= percent && percent <= 100, 'Percent must be between 0 and 100');

    HSLColor hsl = HSLColor.fromColor(this);
    double lightness = (hsl.lightness + percent / 100).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Darkens a color by a given percentage.
  ///
  /// [percent] must be between 0 and 100.
  Color darken(double percent) {
    assert(0 <= percent && percent <= 100, 'Percent must be between 0 and 100');

    HSLColor hsl = HSLColor.fromColor(this);
    double lightness = (hsl.lightness - percent / 100).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Generates a gradient using the given color as the base.
  ///
  /// This method creates a smooth gradient by:
  /// - Lightening the color for highlights.
  /// - Keeping the original color.
  /// - Darkening the color for shadows.
  ///
  /// The [angle] parameter defines the gradient direction.
  ///
  /// Example usage:
  /// ```dart
  /// Color baseColor = Color(0xFF6200EA);
  /// Gradient gradient = baseColor.toGradient();
  /// ```
  LinearGradient toGradient({
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      stops: stops,
      tileMode: tileMode,
      transform: transform,
      colors: [
        lighten(20),  // Lighter shade for highlights
        this,         // Base color
        darken(20),   // Darker shade for depth
      ],
    );
  }

  /// Checks if the color is within a white range.
  ///
  /// If [value] is not provided, it defaults to 0.8.
  bool isWhiteRange({double value = 0.8}) {
    return computeLuminance().isGt(value);
  }
}