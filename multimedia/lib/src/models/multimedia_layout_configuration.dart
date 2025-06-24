import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// {@template multimedia_layout_configuration}
/// Configuration for the visual and behavioral layout of multimedia screens.
///
/// This class controls the major structural elements and system-level behavior
/// of a screen, such as app bars, bottom navigation, drawers, floating widgets,
/// and loading indicators. It's especially useful when building flexible
/// multimedia or media-centric interfaces that must adapt to user activity,
/// light/dark themes, and custom UI configurations.
///
/// ### Example
/// ```dart
/// MultimediaLayoutConfiguration(
///   appbar: AppBar(title: Text('Gallery')),
///   bottomNavbar: BottomNavigationBar(items: [...]),
///   floatingButton: FloatingActionButton(onPressed: () {}),
///   backgroundColor: Colors.white,
///   loadingColor: Colors.blueAccent,
///   withActivity: true,
///   onInactivity: () => print('User inactive'),
///   isLoading: true,
/// )
/// ```
/// {@endtemplate}
class MultimediaLayoutConfiguration {
  /// Optional floating action button.
  ///
  /// Typically shown in the lower-right corner of the screen.
  ///
  /// Defaults to `null`.
  final Widget? floatingButton;

  /// App bar displayed at the top of the screen.
  ///
  /// Can be used to show titles, actions, and navigation buttons.
  ///
  /// Defaults to `null`.
  final PreferredSizeWidget? appbar;

  /// Bottom navigation bar.
  ///
  /// Useful for tabbed navigation or screen switching.
  ///
  /// Defaults to `null`.
  final Widget? bottomNavbar;

  /// Bottom sheet widget anchored at the bottom.
  ///
  /// Can be persistent or modal depending on usage.
  ///
  /// Defaults to `null`.
  final Widget? bottomSheet;

  /// A floating widget positioned above main content.
  ///
  /// Useful for context-aware UI elements or media controls.
  ///
  /// Defaults to `null`.
  final Widget? floater;

  /// Navigation drawer anchored on the left.
  ///
  /// Typically contains a navigation menu.
  ///
  /// Defaults to `null`.
  final Widget? drawer;

  /// Navigation drawer anchored on the right.
  ///
  /// Useful for settings or auxiliary content.
  ///
  /// Defaults to `null`.
  final Widget? endDrawer;

  /// Configuration for floating widget layout and behavior.
  ///
  /// Supersedes [floaterPosition] if both are provided.
  ///
  /// Defaults to `null`.
  final FloatingConfig? floatConfig;

  /// Height of the loading indicator.
  ///
  /// Defaults to `1`.
  final Double loadingHeight;

  /// Vertical position of the loading indicator.
  ///
  /// 0 places it at the top; 1 places it at the bottom.
  ///
  /// Defaults to `0`.
  final Double loadingPosition;

  /// Width of the loading indicator.
  ///
  /// Defaults to `null`.
  final Double? loadingWidth;

  /// Width of the floating widget.
  ///
  /// Only used when [useFloaterWidth] is `true`.
  ///
  /// Defaults to `null`.
  final Double? floaterWidth;

  /// Background color of the screen.
  ///
  /// Defaults to `null`.
  final Color? backgroundColor;

  /// Background color used in dark mode.
  ///
  /// Defaults to `null`.
  final Color? darkBackgroundColor;

  /// Status bar color.
  ///
  /// Defaults to `null`.
  final Color? barColor;

  /// System navigation bar color.
  ///
  /// Defaults to `null`.
  final Color? navigationColor;

  /// Color of the loading indicator.
  ///
  /// Defaults to `null`.
  final Color? loadingColor;

  /// Background color behind the loading indicator.
  ///
  /// Defaults to `null`.
  final Color? loadingBackgroundColor;

  /// Location of the floating action button.
  ///
  /// Used to control FAB alignment, such as [FloatingActionButtonLocation.endDocked].
  ///
  /// Defaults to `null`.
  final FloatingActionButtonLocation? floatingLocation;

  /// Whether to use a `SafeArea` to avoid system UI intrusions.
  ///
  /// Defaults to `true`.
  final Boolean needSafeArea;

  /// Whether to apply [floaterWidth] to the floating widget.
  ///
  /// Defaults to `false`.
  final Boolean useFloaterWidth;

  /// Whether user activity and inactivity should be tracked.
  ///
  /// Enables [onActivity] and [onInactivity] callbacks.
  ///
  /// Defaults to `false`.
  final Boolean withActivity;

  /// Whether the content should extend behind the bottom navbar.
  ///
  /// Useful for immersive UI.
  ///
  /// Defaults to `false`.
  final Boolean extendBody;

  /// Whether content should extend behind the app bar.
  ///
  /// Useful for images or background extending under app bar.
  ///
  /// Defaults to `false`.
  final Boolean extendBehindAppbar;

  /// Whether dark mode UI styling is enabled.
  ///
  /// Defaults to `false`.
  final Boolean goDark;

  /// Whether default themes and colors should be overridden.
  ///
  /// Defaults to `false`.
  final Boolean shouldOverride;

  /// Whether the screen should handle back navigation.
  ///
  /// Disabling this allows system default behavior.
  ///
  /// Defaults to `true`.
  final Boolean shouldWillPop;

  /// Whether a loading indicator should be shown.
  ///
  /// Controlled programmatically for long operations.
  ///
  /// Defaults to `false`.
  final Boolean isLoading;

  /// Layout behavior for the floating widget in a stack.
  ///
  /// Defaults to `null`.
  final StackFit? floatFit;

  /// Layout behavior for the loading indicator in a stack.
  ///
  /// Defaults to `null`.
  final StackFit? loadingFit;

  /// Callback triggered after a period of user inactivity.
  ///
  /// Only fires when [withActivity] is `true`.
  ///
  /// Defaults to `null`.
  final UserActivityHandler? onInactivity;

  /// Callback triggered when user activity resumes.
  ///
  /// Only fires when [withActivity] is `true`.
  ///
  /// Defaults to `null`.
  final UserActivityHandler? onActivity;

  /// Duration of inactivity before [onInactivity] is fired.
  ///
  /// Defaults to 3 minutes.
  final Duration? inactivityDuration;

  /// The theme type used for the layout (e.g., light, dark, system).
  ///
  /// Defaults to `null`.
  final ThemeType? theme;

  /// Callback invoked when the system back button is pressed.
  ///
  /// Useful for intercepting back navigation logic.
  ///
  /// Defaults to `null`.
  final PopScreenInvoked? onWillPop;

  /// Overrides multiple UI behaviors through a unified configuration.
  ///
  /// Defaults to `null`.
  final UiConfig? config;

  /// {@macro multimedia_layout_configuration}
  const MultimediaLayoutConfiguration({
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