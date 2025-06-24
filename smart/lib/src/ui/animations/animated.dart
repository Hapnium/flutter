import 'package:flutter/material.dart';
import 'package:smart/ui.dart';

/// {@template animated}
/// A customizable widget that wraps any child with a container transition animation
/// using Flutter's `OpenContainer` animation.
///
/// This widget is primarily designed for mobile but supports a `nonMobileLayout`
/// fallback for larger screens (e.g., web or desktop).
///
/// The animation transition, visual appearance, and routing behavior can all be
/// customized through constructor parameters.
///
/// Example usage:
/// ```dart
/// Animated<void>(
///   toWidget: DetailPage(),
///   child: ListTile(title: Text("Open Detail")),
/// );
/// ```
///
/// To return a value from the opened screen:
/// ```dart
/// Animated<String>(
///   toWidget: DetailPage(),
///   onClosed: (value) {
///     if (value != null) print("Returned: $value");
///   },
///   child: Text("Tap me"),
/// );
/// ```
/// 
/// {@endtemplate}
class Animated<T> extends StatelessWidget {
  /// {@macro animated}
  const Animated({
    super.key,
    required this.toWidget,
    this.route = "",
    this.params,
    required this.child,
    this.openElevation = 4.0,
    this.isMobile = true,
    this.nonMobileLayout,
    this.closedColor,
    this.openColor,
    this.middleColor,
    this.closedElevation = 4.0,
    this.closedShape,
    this.openShape,
    this.onClosed,
    this.closedBuilder,
    this.openBuilder,
    this.tappable = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionType,
    this.useRootNavigator = false,
    this.routeSettings,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
  });

  /// The destination widget to show on open.
  final Widget toWidget;

  /// A route name used in navigation and analytics. Params are appended as query.
  final String route;

  /// Optional route parameters appended as a query string to [route].
  final Map<String, dynamic>? params;

  /// The widget to display before transition is triggered.
  final Widget child;

  /// Elevation of the open container.
  final double openElevation;

  /// Whether the layout should use mobile design. Set false to use [nonMobileLayout].
  final bool isMobile;

  /// Rounded corners for the open/close containers.
  final BorderRadiusGeometry? borderRadius;

  /// Fallback widget when `isMobile == false`.
  final Widget? nonMobileLayout;

  /// Background color when closed.
  final Color? closedColor;

  /// Background color when opened.
  final Color? openColor;

  /// Optional color shown during transition (rarely needed).
  final Color? middleColor;

  /// Elevation of the closed container.
  final double closedElevation;

  /// Custom shape for the closed container.
  final ShapeBorder? closedShape;

  /// Custom shape for the open container.
  final ShapeBorder? openShape;

  /// Callback when the open screen is closed (can return a value).
  final void Function(T?)? onClosed;

  /// Builder for the closed widget. Falls back to [child] if null.
  final Widget Function(BuildContext, void Function())? closedBuilder;

  /// Builder for the open widget. Falls back to [toWidget] if null.
  final Widget Function(BuildContext, void Function({T? returnValue}))? openBuilder;

  /// Whether the closed container is tappable to trigger the open transition.
  final bool tappable;

  /// Duration of the transition animation.
  final Duration transitionDuration;

  /// Type of transition animation (fade, fadeThrough, etc.).
  final ContainerTransitionType? transitionType;

  /// Whether to use the root navigator.
  final bool useRootNavigator;

  /// Optional [RouteSettings] for the opened page.
  final RouteSettings? routeSettings;

  /// How to clip content inside the transition.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    // Create route string with parameters
    String param = params != null ? _getQueryString(params!) : "";
    String routeName = "$route$param";

    if (isMobile) {
      return OpenContainer(
        transitionType: transitionType ?? ContainerTransitionType.fade,
        openBuilder: openBuilder ?? (BuildContext context, VoidCallback _) => toWidget,
        routeSettings: routeSettings ?? RouteSettings(name: routeName),
        closedElevation: closedElevation,
        openElevation: openElevation,
        closedShape: closedShape ?? RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(24)),
        closedColor: closedColor ?? Theme.of(context).colorScheme.surface,
        closedBuilder: closedBuilder ?? (BuildContext context, VoidCallback openContainer) => child,
        openColor: openColor ?? Theme.of(context).colorScheme.surface,
        openShape: openShape ?? RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(24)),
        onClosed: onClosed,
        tappable: tappable,
        transitionDuration: transitionDuration,
        clipBehavior: clipBehavior,
        useRootNavigator: useRootNavigator,
      );
    } else {
      return nonMobileLayout ?? const SizedBox.shrink();
    }
  }

  /// Converts a map of query parameters into a URL query string.
  String _getQueryString(Map<String, dynamic> params) {
    return params.entries.map((e) {
      return "${e.key}=${Uri.encodeComponent(e.value.toString())}";
    }).join("&");
  }
}