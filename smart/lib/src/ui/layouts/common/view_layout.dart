// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart/enums.dart';
import 'package:smart/extensions.dart';
import 'package:hapnium/hapnium.dart';

import '../../export.dart';

/// A wrapper for handling common layout configurations in the application.
///
/// This widget provides an easy way to structure layouts with app bars, bottom
/// navigation bars, floating action buttons, inactivity detection, loading indicators,
/// and customizable themes.
class ViewLayout extends StatelessWidget {
  /// The main content of the screen.
  final Widget child;

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

  /// Position of the floating widget.
  ///
  /// @deprecated Use [floatConfig] instead.
  @Deprecated("Use [floatConfig] instead.")
  final Double floaterPosition;

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

  /// Creates a `ViewLayout` with customizable layout features.
  ///
  /// [child] is required and represents the main content of the screen.
  const ViewLayout({
    super.key,
    required this.child,
    this.floatingButton,
    this.appbar,
    this.bottomNavbar,
    this.bottomSheet,
    this.floater,
    this.floaterPosition = 230.0,
    this.needSafeArea = true,
    this.backgroundColor,
    this.floatingLocation,
    this.extendBody = false,
    this.extendBehindAppbar = false,
    this.goDark = false,
    this.shouldWillPop = false,
    this.onWillPop,
    this.theme,
    this.shouldOverride = false,
    this.isLoading = false,
    this.barColor,
    this.loadingHeight = 1,
    this.loadingPosition = 0,
    this.navigationColor,
    this.withActivity = false,
    this.drawer,
    this.endDrawer,
    this.loadingWidth,
    this.floaterWidth,
    this.darkBackgroundColor,
    this.loadingColor,
    this.loadingBackgroundColor,
    this.floatFit,
    this.loadingFit,
    this.onInactivity,
    this.onActivity,
    this.inactivityDuration,
    this.config,
    this.floatConfig,
    this.useFloaterWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget layout = _build(context);

    if ((shouldWillPop && onWillPop.isNotNull) || onWillPop.isNotNull) {
      layout = PopScope(onPopInvokedWithResult: onWillPop, child: layout);
    }

    return layout;
  }

  Widget _build(BuildContext context) {
    if (withActivity) {
      return InactivityLayout(
        child: _buildWithLoading(context),
        onInactivity: onInactivity,
        onActivity: onActivity,
        inactivityDuration: inactivityDuration,
      );
    } else {
      return _buildWithLoading(context);
    }
  }

  Widget _buildWithLoading(BuildContext context) {
    if (isLoading) {
      return Stack(
        fit: loadingFit ?? StackFit.expand,
        children: [
          _layout(context),
          Positioned(
            top: loadingPosition,
            child: Loading.vertical(
              width: loadingWidth ?? MediaQuery.sizeOf(context).width,
              height: loadingHeight,
              color: loadingColor ?? Theme.of(context).primaryColor,
              backgroundColor: loadingBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            )
          ),
        ],
      );
    } else {
      return _layout(context);
    }
  }

  Widget _layout(BuildContext context) {
    Boolean isLightTheme = theme.isNotNull && theme!.isLight;
    Color? statusBarColor = shouldOverride
      ? backgroundColor
      : goDark
      ? darkBackgroundColor
      : barColor ?? Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor;
    Color? systemNavigationBarColor = shouldOverride
      ? backgroundColor
      : goDark
      ? darkBackgroundColor
      : navigationColor ?? Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor;
    Brightness statusBarIconBrightness = goDark
      ? Brightness.light
      : isLightTheme
      ? Brightness.dark
      : Brightness.light;
    Brightness systemNavigationBarIconBrightness = goDark
      ? Brightness.light
      : isLightTheme
      ? Brightness.dark
      : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: config?.statusBarColor ?? statusBarColor,
        systemNavigationBarColor: config?.systemNavigationBarColor ?? systemNavigationBarColor,
        statusBarIconBrightness: config?.statusBarIconBrightness ?? statusBarIconBrightness,
        systemNavigationBarIconBrightness: config?.systemNavigationBarIconBrightness ?? systemNavigationBarIconBrightness,
        statusBarBrightness: config?.statusBarBrightness,
        systemNavigationBarDividerColor: config?.systemNavigationBarDividerColor,
        systemNavigationBarContrastEnforced: config?.systemNavigationBarContrastEnforced,
        systemStatusBarContrastEnforced: config?.systemStatusBarContrastEnforced
      ),
      child: Scaffold(
        appBar: appbar,
        extendBody: extendBody,
        drawer: drawer,
        endDrawer: endDrawer,
        extendBodyBehindAppBar: extendBehindAppbar,
        backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        body: _buildChild(context),
        floatingActionButton: floatingButton,
        floatingActionButtonLocation: floatingLocation,
        bottomNavigationBar: bottomNavbar,
        bottomSheet: bottomSheet,
      )
    );
  }

  Widget _buildChild(BuildContext context) {
    Widget child = this.child;

    if (floater.isNotNull) {
      // Use floatConfig if available; otherwise, create a FloatingConfig using floaterPosition
      final FloatingConfig config = floatConfig ?? FloatingConfig(bottom: floaterPosition);
      final Widget floatChild = useFloaterWidth ? SizedBox(
        width: floaterWidth ?? MediaQuery.sizeOf(context).width,
        child: floater!,
      ) : floater!;

      child = Stack(
        fit: floatFit ?? StackFit.expand,
        children: [
          child,
          Positioned(
            left: config.left,
            right: config.right,
            top: config.top,
            bottom: config.bottom,
            height: config.height,
            width: config.width,
            child: floatChild,
          ),
        ],
      );
    }

    return needSafeArea ? SafeArea(child: child) : child;
  }
}