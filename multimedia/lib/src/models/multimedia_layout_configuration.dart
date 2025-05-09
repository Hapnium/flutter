import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class MultimediaLayoutConfiguration {
  /// Optional floating action button.
  final Widget? floatingButton;

  /// App bar for the screen.
  final PreferredSizeWidget? appbar;

  /// Bottom navigation bar.
  final Widget? bottomNavbar;

  /// Bottom sheet widget.
  final Widget? bottomSheet;

  /// A floating widget that can be positioned above content.
  final Widget? floater;

  /// Navigation drawer on the left side.
  final Widget? drawer;

  /// Navigation drawer on the right side.
  final Widget? endDrawer;

  /// Configuration for the floating widget.
  ///
  /// If still using the old [floaterPosition] parameter, the [floatConfig] should be used instead.
  /// However, if both are provided, the [floatConfig] will take precedence.
  ///
  /// In order to provide support for older versions of the library, the [floaterPosition] parameter is still supported.
  /// The [FloatingConfig] will be used to configure the position of the floating widget, using the provided value
  /// from the [floaterPosition] parameter.
  ///
  /// Defaults to null.
  final FloatingConfig? floatConfig;

  /// Height of the loading indicator.
  final Double loadingHeight;

  /// Position of the loading indicator.
  final Double loadingPosition;

  /// Width of the loading indicator.
  final Double? loadingWidth;

  /// Width of the floating widget.
  final Double? floaterWidth;

  /// Background color of the screen.
  final Color? backgroundColor;

  /// Background color when in dark mode.
  final Color? darkBackgroundColor;

  /// Status bar color.
  final Color? barColor;

  /// Navigation bar color.
  final Color? navigationColor;

  /// Color of the loading indicator.
  final Color? loadingColor;

  /// Background color of the loading indicator.
  final Color? loadingBackgroundColor;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingLocation;

  /// Whether the layout should use a `SafeArea` to avoid system UI intrusions.
  final Boolean needSafeArea;

  /// Whether to use the defined width of [floaterWidth] for the floating widget.
  final Boolean useFloaterWidth;

  /// Whether to track user activity and inactivity.
  final Boolean withActivity;

  /// Whether to extend the body behind the bottom navigation bar.
  final Boolean extendBody;

  /// Whether to extend content behind the app bar.
  final Boolean extendBehindAppbar;

  /// Whether the layout should use dark mode.
  final Boolean goDark;

  /// Whether to override default theme configurations.
  final Boolean shouldOverride;

  /// Whether to handle system back navigation.
  final Boolean shouldWillPop;

  /// Whether a loading indicator should be displayed.
  final Boolean isLoading;

  /// Stack fit behavior for the floating widget.
  final StackFit? floatFit;

  /// Stack fit behavior for the loading indicator.
  final StackFit? loadingFit;

  /// Callback triggered when inactivity is detected.
  final UserActivityHandler? onInactivity;

  /// Optional callback triggered when user activity is detected.
  final UserActivityHandler? onActivity;

  /// The duration of inactivity before [onInactivity] is triggered.
  /// Defaults to 3 minutes if not provided.
  final Duration? inactivityDuration;

  /// The theme type used for styling.
  final ThemeType? theme;

  /// Callback invoked when the system back button is pressed.
  final PopScreenInvoked? onWillPop;

  /// UI Config to override other settings
  ///
  /// Defaults to null
  final UiConfig? config;

  MultimediaLayoutConfiguration({
    this.floatingButton,
    this.appbar,
    this.bottomNavbar,
    this.bottomSheet,
    this.floater,
    this.drawer,
    this.endDrawer,
    this.floatConfig,
    this.loadingHeight = 1,
    this.loadingPosition = 0,
    this.loadingWidth,
    this.floaterWidth,
    this.backgroundColor,
    this.darkBackgroundColor,
    this.barColor,
    this.navigationColor,
    this.loadingColor,
    this.loadingBackgroundColor,
    this.floatingLocation,
    this.needSafeArea = true,
    this.useFloaterWidth = false,
    this.withActivity = false,
    this.extendBody = false,
    this.extendBehindAppbar = false,
    this.goDark = false,
    this.shouldOverride = false,
    this.shouldWillPop = true,
    this.isLoading = false,
    this.floatFit,
    this.loadingFit,
    this.onInactivity,
    this.onActivity,
    this.inactivityDuration,
    this.theme,
    this.onWillPop,
    this.config,
});
}