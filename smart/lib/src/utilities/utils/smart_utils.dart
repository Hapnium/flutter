import 'dart:math' show sqrt;

import 'package:flutter/material.dart' show BuildContext, Color, Colors, HSLColor, LinearGradient, Alignment, AlignmentGeometry, TileMode, GradientTransform;
import 'package:smart/responsive.dart';

import '../country/country_data.dart';
import '../country/country.dart';
import 'google_map_style.dart';

/// A utility class providing access to various helper functions and data.
///
/// The class contains commonly used utilities related to:
/// - Country data
/// - Google Maps styles
/// - Responsive design utilities
/// - Name-based utilities (initials, colors)
///
/// This class is **not meant to be instantiated** and should be accessed statically.
class SmartUtils {
  /// Private constructor to prevent instantiation.
  SmartUtils._();

  /// Returns a list of all countries in the world.
  ///
  /// Uses [CountryData] to fetch a list of available [Country] models.
  ///
  /// Example:
  /// ```dart
  /// List<Country> allCountries = SmartUtils.countries;
  /// print("Total countries: ${allCountries.length}");
  /// ```
  static List<Country> get countries => CountryData.instance.countries;

  /// Returns the dark theme styling for Google Maps.
  ///
  /// Uses [GoogleMapStyle] to retrieve the predefined dark mode styling as a [String].
  ///
  /// Example:
  /// ```dart
  /// String darkTheme = SmartUtils.googleMapDarkTheme;
  /// print("Google Map Dark Theme: $darkTheme");
  /// ```
  static String get googleMapDarkTheme => GoogleMapStyle.instance.darkTheme;

  /// Provides a responsive utility instance for handling screen responsiveness.
  ///
  /// Uses [ResponsiveUtil] to create a responsive layout helper based on the given [BuildContext].
  /// Optionally, a [ResponsiveConfig] can be provided to customize behavior.
  ///
  /// Example:
  /// ```dart
  /// ResponsiveUtil responsiveUtil = SmartUtils.responsive(context);
  /// print("Current screen size: ${responsiveUtil.screenSize}");
  /// ```
  ///
  /// - [context]: The [BuildContext] of the widget tree.
  /// - [config]: Optional [ResponsiveConfig] to customize responsive behavior.
  ///
  /// Returns a [ResponsiveUtil] instance.
  static ResponsiveUtil responsive(BuildContext context, {ResponsiveConfig? config}) =>
      ResponsiveUtil(context, config: config);

  /// Generates a consistent color from a given name string, avoiding excluded colors.
  ///
  /// This is useful for generating avatar background colors based on a user name.
  ///
  /// - [name]: The input name to derive the color from.
  /// - [excludedColors]: Optional list of colors that should not be used.
  /// - [minDistance]: Minimum color distance required from excluded colors (0.0-1.0).
  ///
  /// Returns a [Color] derived from the name hash. If the name is empty, a default grey color is returned.
  ///
  /// Example:
  /// ```dart
  /// Color avatarColor = SmartUtils.generateColorFromName(
  ///   "Jane Doe", 
  ///   excludedColors: [Colors.red, Colors.blue]
  /// );
  /// ```
  static Color generateColorFromName(
    String name, {
    List<Color>? excludedColors,
    double minDistance = 0.15,
  }) {
    if (name.isEmpty) return Colors.grey.shade400;
    
    final hash = name.replaceAll(" ", "").hashCode;
    double hue = (hash % 360).toDouble();
    
    // If we have excluded colors, ensure our generated color is different enough
    if (excludedColors != null && excludedColors.isNotEmpty) {
      // Try up to 10 different hues to find one that's different enough
      for (int attempt = 0; attempt < 10; attempt++) {
        final testColor = HSLColor.fromAHSL(1.0, hue, 0.5, 0.65).toColor();
        
        // Check if this color is too close to any excluded color
        bool tooClose = false;
        for (final excludedColor in excludedColors) {
          if (_colorDistance(testColor, excludedColor) < minDistance) {
            tooClose = true;
            break;
          }
        }
        
        // If this color is acceptable, use it
        if (!tooClose) {
          break;
        }
        
        // Otherwise, try a different hue
        hue = (hue + 37) % 360; // Use a prime number to get good distribution
      }
    }

    return HSLColor.fromAHSL(1.0, hue, 0.5, 0.65).toColor();
  }

  /// Generates a consistent [LinearGradient] from a given name string with full customization,
  /// avoiding excluded colors.
  ///
  /// This is useful for generating personalized gradient backgrounds for avatars,
  /// cards, UI elements based on names or identifiers.
  ///
  /// ### Parameters:
  /// - [name]: The input string to derive gradient colors from.
  /// - [excludedColors]: Optional list of colors that should not be used in the gradient.
  /// - [minDistance]: Minimum color distance required from excluded colors (0.0-1.0).
  ///
  /// #### Gradient Control:
  /// - [begin]: The start alignment of the gradient. Defaults to [Alignment.centerLeft].
  /// - [end]: The end alignment of the gradient. Defaults to [Alignment.centerRight].
  /// - [tileMode]: The tile mode of the gradient. Defaults to [TileMode.clamp].
  /// - [stops]: Optional stops for the gradient colors.
  /// - [transform]: Optional transform for the gradient.
  ///
  /// #### Color Generation Customization:
  /// - [saturation1]: Saturation of the first color (0.0 to 1.0). Defaults to 0.6.
  /// - [lightness1]: Lightness of the first color. Defaults to 0.6.
  /// - [saturation2]: Saturation of the second color. Defaults to 0.7.
  /// - [lightness2]: Lightness of the second color. Defaults to 0.55.
  /// - [hueOffset]: Offset added to the hue for the second color. Defaults to 40°.
  ///
  /// #### Fallback Handling:
  /// - [fallbackColors]: Optional fallback color list if name is empty.
  /// - [fallbackBegin]: Begin alignment if name is empty. Defaults to [Alignment.topLeft].
  /// - [fallbackEnd]: End alignment if name is empty. Defaults to [Alignment.bottomRight].
  ///
  /// ### Returns:
  /// A fully customized [LinearGradient] based on the name hash or fallback.
  ///
  /// ### Example:
  /// ```dart
  /// LinearGradient gradient = SmartUtils.generateGradientFromName(
  ///   "Jane Doe",
  ///   excludedColors: [Colors.red, Colors.green],
  ///   begin: Alignment.topCenter,
  ///   end: Alignment.bottomCenter,
  /// );
  /// ```
  static LinearGradient generateGradientFromName(
    String name, {
    /// Color exclusion
    List<Color>? excludedColors,
    double minDistance = 0.15,
    
    /// LinearGradient parameters
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,

    /// Color tuning
    double saturation1 = 0.6,
    double lightness1 = 0.6,
    double saturation2 = 0.7,
    double lightness2 = 0.55,
    double hueOffset = 40,

    /// Fallback
    List<Color>? fallbackColors,
    AlignmentGeometry fallbackBegin = Alignment.topLeft,
    AlignmentGeometry fallbackEnd = Alignment.bottomRight,
  }) {
    if (name.isEmpty) {
      return LinearGradient(
        colors: fallbackColors ?? [Colors.grey.shade400, Colors.grey.shade600],
        begin: fallbackBegin,
        end: fallbackEnd,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );
    }

    final hash = name.replaceAll(" ", "").hashCode;
    double baseHue = (hash % 360).toDouble();
    double secondHue = (baseHue + hueOffset) % 360;
    
    // If we have excluded colors, ensure our generated colors are different enough
    if (excludedColors != null && excludedColors.isNotEmpty) {
      // Try up to 10 different hue combinations to find ones that are different enough
      for (int attempt = 0; attempt < 10; attempt++) {
        final color1 = HSLColor.fromAHSL(1.0, baseHue, saturation1, lightness1).toColor();
        final color2 = HSLColor.fromAHSL(1.0, secondHue, saturation2, lightness2).toColor();
        
        // Check if either color is too close to any excluded color
        bool tooClose = false;
        for (final excludedColor in excludedColors) {
          if (_colorDistance(color1, excludedColor) < minDistance || _colorDistance(color2, excludedColor) < minDistance) {
            tooClose = true;
            break;
          }
        }
        
        // If these colors are acceptable, use them
        if (!tooClose) {
          break;
        }
        
        // Otherwise, try different hues
        baseHue = (baseHue + 37) % 360; // Use prime numbers for better distribution
        secondHue = (baseHue + hueOffset) % 360;
      }
    }

    final color1 = HSLColor.fromAHSL(1.0, baseHue, saturation1, lightness1).toColor();
    final color2 = HSLColor.fromAHSL(1.0, secondHue, saturation2, lightness2).toColor();

    return LinearGradient(
      colors: [color1, color2],
      begin: begin ?? Alignment.centerLeft,
      end: end ?? Alignment.centerRight,
      stops: stops,
      tileMode: tileMode,
      transform: transform,
    );
  }
  
  /// Calculates the perceptual distance between two colors.
  /// Returns a value between 0.0 (identical) and 1.0 (completely different).
  static double _colorDistance(Color a, Color b) {
    final hslA = HSLColor.fromColor(a);
    final hslB = HSLColor.fromColor(b);

    final hueDiff = (hslA.hue - hslB.hue).abs() / 360.0;
    final satDiff = (hslA.saturation - hslB.saturation).abs();
    final lightDiff = (hslA.lightness - hslB.lightness).abs();

    // Weighted Euclidean distance in HSL space
    return sqrt(hueDiff * hueDiff + satDiff * satDiff + lightDiff * lightDiff) / sqrt(3);
  }

  /// Extracts initials from a full name or a combination of first and last names.
  ///
  /// This method tries to derive the best initials to represent a person.
  ///
  /// - [fullName]: Full name of the person (e.g., "Jane Doe").
  /// - [firstName]: First name (used if [fullName] is not provided).
  /// - [lastName]: Last name (used if neither [fullName] nor [firstName] is provided).
  ///
  /// Returns a [String] containing the initials in uppercase. If no names are provided, an empty string is returned.
  ///
  /// Example:
  /// ```dart
  /// String initials = SmartUtils.getInitials(fullName: "John Doe"); // "JD"
  /// ```
  static String getInitials({String? fullName, String? firstName, String? lastName}) {
    if (fullName != null && fullName.trim().isNotEmpty) {
      final parts = fullName.trim().split(RegExp(r'\s+'));
      return parts.length >= 2
          ? parts[0][0].toUpperCase() + parts[1][0].toUpperCase()
          : parts[0][0].toUpperCase();
    }

    if (firstName != null && firstName.trim().isNotEmpty) {
      return firstName.trim()[0].toUpperCase();
    }

    if (lastName != null && lastName.trim().isNotEmpty) {
      return lastName.trim()[0].toUpperCase();
    }

    return "";
  }
}