import 'dart:ui';

class UiConfig {
  /// The color of the system bottom navigation bar.
  ///
  /// Only honored in Android versions O and greater.
  final Color? systemNavigationBarColor;

  /// The color of the divider between the system's bottom navigation bar and the app's content.
  ///
  /// Only honored in Android versions P and greater.
  final Color? systemNavigationBarDividerColor;

  /// The brightness of the system navigation bar icons.
  ///
  /// Only honored in Android versions O and greater.
  /// When set to [Brightness.light], the system navigation bar icons are light.
  /// When set to [Brightness.dark], the system navigation bar icons are dark.
  final Brightness? systemNavigationBarIconBrightness;

  /// Overrides the contrast enforcement when setting a transparent navigation
  /// bar.
  ///
  /// When setting a transparent navigation bar in SDK 29+, or Android 10 and up,
  /// a translucent body scrim may be applied behind the button navigation bar
  /// to ensure contrast with buttons and the background of the application.
  ///
  /// SDK 28-, or Android P and lower, will not apply this body scrim.
  ///
  /// Setting this to false overrides the default body scrim.
  ///
  /// See also:
  ///
  ///   * [SystemUiOverlayStyle.systemNavigationBarColor], which is overridden
  ///   when transparent to enforce this contrast policy.
  final bool? systemNavigationBarContrastEnforced;

  /// The color of top status bar.
  ///
  /// Only honored in Android version M and greater.
  final Color? statusBarColor;

  /// The brightness of top status bar.
  ///
  /// Only honored in iOS.
  final Brightness? statusBarBrightness;

  /// The brightness of the top status bar icons.
  ///
  /// Only honored in Android version M and greater.
  final Brightness? statusBarIconBrightness;

  /// Overrides the contrast enforcement when setting a transparent status
  /// bar.
  ///
  /// When setting a transparent status bar in SDK 29+, or Android 10 and up,
  /// a translucent body scrim may be applied to ensure contrast with icons and
  /// the background of the application.
  ///
  /// SDK 28-, or Android P and lower, will not apply this body scrim.
  ///
  /// Setting this to false overrides the default body scrim.
  ///
  /// See also:
  ///
  ///   * [SystemUiOverlayStyle.statusBarColor], which is overridden
  ///   when transparent to enforce this contrast policy.
  final bool? systemStatusBarContrastEnforced;

  UiConfig({
    this.systemNavigationBarColor,
    this.systemNavigationBarDividerColor,
    this.systemNavigationBarIconBrightness,
    this.systemNavigationBarContrastEnforced,
    this.statusBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.systemStatusBarContrastEnforced,
  });
}