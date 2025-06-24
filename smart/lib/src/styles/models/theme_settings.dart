import 'package:flutter/material.dart';

/// {@template theme_settings}
/// A class representing a set of theme settings for an application.
///
/// This class provides properties for controlling various aspects of the theme,
/// including:
///
/// * `density`: The visual density of the application, affecting spacing and
///   element sizes.
/// * `text`: The text theme used for general text styles throughout the app.
/// * `logo`: A separate text theme specifically for the application logo, if
///   desired.
/// * `style`: A catch-all text style that can be applied to various elements
///   where a consistent style is needed.
/// 
/// {@endtemplate}
class ThemeSettings {
  /// The visual density of the application.
  final VisualDensity density;

  /// The text theme used for general text styles.
  final TextTheme text;

  /// A separate text theme specifically for the application logo.
  final TextTheme logo;

  /// A catch-all text style that can be applied to various elements.
  final TextStyle style;

  /// Creates a new instance of [ThemeSettings].
  ///
  /// All parameters are required.
  /// 
  /// {@macro theme_settings}
  ThemeSettings({required this.density, required this.text, required this.logo, required this.style});
}