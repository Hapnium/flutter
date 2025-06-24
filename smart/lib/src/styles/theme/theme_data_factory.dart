import 'package:flutter/material.dart';
import '../models/theme_settings.dart';

/// {@template theme_data_factory} 
/// An abstract class that defines the structure of a theme.
///
/// Any theme class (e.g., `LightTheme`, `DarkTheme`) must extend this class.
/// It enforces the presence of key theme properties such as colors and [ThemeData].
/// 
/// {@endtemplate}
abstract class ThemeDataFactory {
  /// The theme settings that define custom configurations.
  final ThemeSettings settings;

  /// Creates a new [ThemeDataFactory] with the given [settings].
  ThemeDataFactory(this.settings);

  /// The primary color of the theme.
  Color get primaryColor;

  /// The secondary color of the theme.
  Color get secondaryColor;

  /// An alternate color used for UI elements.
  Color get alternateColor;

  /// The primary text color used in the theme.
  Color get primaryTextColor;

  /// The secondary text color used in the theme.
  Color get secondaryTextColor;

  /// The background color of the theme.
  Color get backgroundColor;

  /// The color used for selections, highlights, or focus states.
  Color get selectionColor;

  /// The [ThemeData] that represents the full theme.
  ThemeData get theme;
}