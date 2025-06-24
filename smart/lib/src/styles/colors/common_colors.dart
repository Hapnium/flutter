import 'theme_colors.dart';

/// {@template common_colors}
/// Accessor for the defined colors in [ThemeColors]
/// 
/// This class provides a singleton instance of [ThemeColors] that can be used
/// to access the colors defined in [ThemeColors].
/// 
/// {@endtemplate}
class CommonColors extends ThemeColors {
  /// {@macro common_colors}
  CommonColors._();

  /// {@macro common_colors}
  static CommonColors instance = CommonColors._();
}