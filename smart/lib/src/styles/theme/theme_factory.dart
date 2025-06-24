import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/theme_settings.dart';
import '../../enums/ui/font_family.dart';

/// {@template theme_factory}
/// An abstract class that provides methods to generate themes and text styles.
///
/// This class allows developers to create both light and dark themes, as well
/// as define text themes using custom fonts, Google Fonts, or built-in package fonts.
/// 
/// {@endtemplate}
abstract class ThemeFactory {
  /// Generates a [TextStyle] using the given [fontFamily].
  ///
  /// If no style is provided, it defaults to an empty [TextStyle].
  @protected
  @nonVirtual
  TextStyle textStyleBuilder({TextStyle? style, String? fontFamily, FontFamily? font}) {
    assert(fontFamily != null || font != null, 'Either fontFamily or font must be provided.');

    style ??= const TextStyle();
    fontFamily ??= font!.type;

    return style.copyWith(fontFamily: fontFamily, package: "smart");
  }

  /// Creates a [TextTheme] using the specified [fontFamily] or [FontFamily].
  ///
  /// If [baseTheme] is not provided, it defaults to `ThemeData.light().textTheme`.
  @protected
  @nonVirtual
  TextTheme textThemeBuilder({TextTheme? baseTheme, String? fontFamily, FontFamily? font}) {
    assert(fontFamily != null || font != null, 'Either fontFamily or font must be provided.');

    fontFamily ??= font!.type;
    baseTheme ??= ThemeData.light().textTheme;

    return TextTheme(
      displayLarge: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.displayLarge),
      displayMedium: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.displayMedium),
      displaySmall: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.displaySmall),
      headlineLarge: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.headlineLarge),
      headlineMedium: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.headlineMedium),
      headlineSmall: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.headlineSmall),
      titleLarge: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.titleLarge),
      titleMedium: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.titleMedium),
      titleSmall: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.titleSmall),
      bodyLarge: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.bodyLarge),
      bodyMedium: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.bodyMedium),
      bodySmall: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.bodySmall),
      labelLarge: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.labelLarge),
      labelMedium: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.labelMedium),
      labelSmall: textStyleBuilder(fontFamily: fontFamily, style: baseTheme.labelSmall),
    );
  }

  /// The theme settings that define global configurations.
  ThemeSettings get settings;

  /// Provides the light theme.
  ThemeData get light;

  /// Provides the dark theme.
  ThemeData get dark;

  /// The default text theme used in the app.
  TextTheme get text;

  /// The text theme for logos, using a built-in package font.
  TextTheme get logo;

  /// A default text style.
  TextStyle get style;
}