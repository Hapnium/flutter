import 'package:smart/ui.dart';

import 'floating_config_extension.dart';

/// Extension methods for the `ViewLayout` class to provide convenient
/// ways to modify its floating configuration.
extension ViewLayoutExtensions on ViewLayout {
  /// Sets the floating widget's left position.
  ///
  /// If `value` is not provided, it defaults to `0`.
  ViewLayout floatLeft([double value = 0]) {
    return copyWith(floatConfig: (floatConfig ?? FloatingConfig()).l(value));
  }

  /// Sets the floating widget's right position.
  ///
  /// If `value` is not provided, it defaults to `0`.
  ViewLayout floatRight([double value = 0]) {
    return copyWith(floatConfig: (floatConfig ?? FloatingConfig()).r(value));
  }

  /// Sets the floating widget's top position.
  ///
  /// If `value` is not provided, it defaults to `0`.
  ViewLayout floatTop([double value = 0]) {
    return copyWith(floatConfig: (floatConfig ?? FloatingConfig()).t(value));
  }

  /// Sets the floating widget's bottom position.
  ///
  /// If `value` is not provided, it defaults to `0`.
  ViewLayout floatBottom([double value = 0]) {
    return copyWith(floatConfig: (floatConfig ?? FloatingConfig()).b(value));
  }

  /// Centers the floating widget within its parent.
  ViewLayout floatCenter() {
    return copyWith(floatConfig: (floatConfig ?? FloatingConfig()).center());
  }

  /// Creates a copy of this `ViewLayout` with the given fields replaced with the
  /// new values.
  ///
  /// If `floatConfig` is null, it defaults to the existing `floatConfig`.
  ViewLayout copyWith({FloatingConfig? floatConfig}) {
    return ViewLayout(
      key: key,
      child: child,
      floatingButton: floatingButton,
      appbar: appbar,
      bottomNavbar: bottomNavbar,
      bottomSheet: bottomSheet,
      floater: floater,
      floaterWidth: floaterWidth,
      floatConfig: floatConfig ?? this.floatConfig,
      backgroundColor: backgroundColor,
      floatingLocation: floatingLocation,
      extendBody: extendBody,
      extendBehindAppbar: extendBehindAppbar,
      goDark: goDark,
      shouldWillPop: shouldWillPop,
      onWillPop: onWillPop,
      theme: theme,
      shouldOverride: shouldOverride,
      isLoading: isLoading,
      barColor: barColor,
      loadingHeight: loadingHeight,
      loadingPosition: loadingPosition,
      navigationColor: navigationColor,
      withActivity: withActivity,
      drawer: drawer,
      endDrawer: endDrawer,
      loadingWidth: loadingWidth,
      darkBackgroundColor: darkBackgroundColor,
      loadingColor: loadingColor,
      loadingBackgroundColor: loadingBackgroundColor,
      floatFit: floatFit,
      loadingFit: loadingFit,
      onInactivity: onInactivity,
      onActivity: onActivity,
      inactivityDuration: inactivityDuration,
      config: config,
      useFloaterWidth: useFloaterWidth,
    );
  }
}