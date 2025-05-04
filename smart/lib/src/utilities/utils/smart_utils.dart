import 'package:flutter/material.dart' show BuildContext, Color, Colors, HSLColor;
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

  /// Generates a consistent color from a given name string.
  ///
  /// This is useful for generating avatar background colors based on a user name.
  ///
  /// - [name]: The input name to derive the color from.
  ///
  /// Returns a [Color] derived from the name hash. If the name is empty, a default grey color is returned.
  ///
  /// Example:
  /// ```dart
  /// Color avatarColor = SmartUtils.generateColorFromName("Jane Doe");
  /// ```
  static Color generateColorFromName(String name) {
    if (name.isEmpty) return Colors.grey.shade400;
    final hash = name.hashCode;
    final hue = (hash % 360).toDouble();

    return HSLColor.fromAHSL(1.0, hue, 0.5, 0.65).toColor();
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