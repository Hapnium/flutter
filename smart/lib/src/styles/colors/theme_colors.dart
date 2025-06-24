import 'package:flutter/material.dart';

/// {@template theme_colors}
/// A base class for defining a set of constant colors used for the UI layout of the app.
///
/// This class provides both light and dark theme colors, as well as additional colors
/// used for various UI elements such as hints, errors, success indicators, and special categories.
///
/// ## Extending `ThemeColors`
///
/// This class is designed to be extended by other classes, allowing developers to override
/// specific colors while still maintaining access to the base colors defined here.
///
/// ### Example Usage:
///
/// ```dart
/// class CustomColors extends ThemeColors {
///   @override
///   Color lightTheme2 = Color(0xffFF0000); // Custom override
/// }
///
/// void main() {
///   final colors = CustomColors();
///   print(colors.lightTheme2); // Prints the overridden color value
/// }
/// ```
/// 
/// {@endtemplate}
abstract class ThemeColors {
  /// Primary light theme background color.
  Color lightTheme = const Color(0xffFFFFFF);

  /// Secondary light theme background color.
  Color lightTheme2 = const Color(0xffF1F1F1);

  /// Primary dark theme background color.
  Color darkTheme = const Color(0xff050404);

  /// Secondary dark theme background color.
  Color darkTheme2 = const Color(0xff222222);

  /// Hint text color.
  Color hint = const Color(0xff8C8C8C);

  /// Standard grey color used in various UI components.
  Color grey = const Color(0xff383838);

  /// Light grey color used for disabled elements or background accents.
  Color hinted = const Color(0xffD9D9D9);

  /// Color representing an "all day" event or activity.
  Color allDay = const Color(0xff000870);

  /// Color used for PayU branding.
  Color payu = const Color(0xffB80000);

  /// Color representing a premium status or feature.
  Color premium = const Color(0xffB8006B);

  /// Color used for free-tier plans or features.
  Color freePlan = const Color(0xff2C0F0C);

  /// Standard green color used for success states or confirmations.
  Color green = const Color(0xff06C270);

  /// Standard yellow color used for warnings or attention-grabbing elements.
  Color yellow = const Color(0xffFF9E53);

  /// Standard error color used for validation messages or failure states.
  Color error = const Color(0xffFF3B3B);

  /// Neutral informational color.
  Color info = const Color(0xffAAAAAA);

  /// Standard warning color.
  Color warning = const Color(0xffffcc00);

  /// Standard success color.
  Color success = const Color(0xff06c270);

  /// Base color for shimmer loading effects.
  Color shimmerBase = const Color.fromARGB(255, 176, 176, 176);

  /// Highlight color for shimmer loading effects.
  Color shimmerHigh = const Color.fromARGB(255, 210, 210, 210);

  /// Default shimmer background color.
  Color shimmer = const Color(0xFF111111);

  /// WhatsApp Green
  Color whatsapp = const Color(0xFF25D366);

  /// Facebook Blue
  Color facebook = const Color(0xFF1877F2);

  /// Instagram Gradient
  LinearGradient instagramGradient = const LinearGradient(
    colors: [
      Color(0xFFFEDA77), // Yellow
      Color(0xFFF56040), // Orange
      Color(0xFFC13584), // Red/Pink
      Color(0xFF833AB4), // Violet/Purple
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Twitter Black (or very dark grey)
  Color twitter = const Color(0xFF000000);

  /// Twitter Blue
  Color twitterBlue = const Color(0xFF1DA1F2);

  /// Snapchat Yellow
  Color snapchat = const Color(0xFFFFFC00);

  /// Instagram Average Color
  Color instagram = const Color.fromRGBO(216, 85, 134, 1.0);
}