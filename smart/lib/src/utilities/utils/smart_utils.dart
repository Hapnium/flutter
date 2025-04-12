import 'package:flutter/cupertino.dart';
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
  static ResponsiveUtil responsive(BuildContext context, {ResponsiveConfig? config}) => ResponsiveUtil(context, config: config);
}