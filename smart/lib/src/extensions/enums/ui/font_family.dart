import '../../../enums/ui/font_family.dart';

/// Provides expressive boolean checks for [FontFamily].
///
/// This extension simplifies status checks by replacing `==` comparisons
/// with readable getters.
///
/// Example:
/// ```dart
/// if (fontFamily.isLeagueSpartan) {
///   // Use League Spartan font
/// } else if (fontFamily.isNunito) {
///   // Use Nunito font
/// }
/// ```
extension FontFamilyExtension on FontFamily {
  /// Returns `true` if the font family is [FontFamily.leagueSpartan].
  bool get isLeagueSpartan => this == FontFamily.leagueSpartan;

  /// Returns `true` if the font family is [FontFamily.nunito].
  bool get isNunito => this == FontFamily.nunito;

  /// Returns `true` if the font family is [FontFamily.glow].
  bool get isGlow => this == FontFamily.glow;
}