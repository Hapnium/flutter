import '../../../enums/preference/theme_type.dart';

/// Provides convenient boolean checks for [ThemeType] values.
///
/// This extension allows you to perform quick comparisons with readable getter methods.
/// Instead of writing `if (media == ThemeType.video)`, you can use `media.isVideo`.
///
/// Example Usage:
/// ```dart
/// ThemeType media = ThemeType.photo;
/// if (media.isPhoto) {
///   print("User selected a photo.");
/// }
/// ```
extension ThemeTypeExtension on ThemeType {
  /// Returns `true` if the theme type is a **light**.
  bool get isLight => this == ThemeType.light;

  /// Returns `true` if the theme type is a **dark**.
  bool get isDark => this == ThemeType.dark;
}