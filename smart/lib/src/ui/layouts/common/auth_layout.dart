import 'package:flutter/material.dart';
import 'package:smart/responsive.dart';
import 'package:hapnium/hapnium.dart';

/// A wrapper widget for authentication screens, providing consistent layout and styling.
///
/// This widget adjusts its layout based on the device's screen size and can be scrollable or non-scrollable.
class AuthLayout extends StatelessWidget {
  /// The child widget to be wrapped.
  final Widget child;

  /// The background color of the wrapper.
  final Color? backgroundColor;

  /// Whether the content should be scrollable.
  final Boolean isScrollable;

  /// The main axis alignment for the column layout.
  final MainAxisAlignment? mainAxisAlignment;

  /// The cross axis alignment for the column layout.
  final CrossAxisAlignment? crossAxisAlignment;

  /// The width of the content box.
  final Double? boxWidth;

  /// The shape of the card containing the content.
  final ShapeBorder? shape;

  /// Spacing between the content and other elements.
  final Double? spacing;

  /// Divider size for desktop screens.
  final Double? desktopDivider;

  /// Divider size for tablet screens.
  final Double? tabletDivider;

  /// Divider size for mobile screens.
  final Double? mobileDivider;

  /// General divider size used when no specific one is provided.
  final Double? divider;

  /// Configuration for responsive behavior.
  final ResponsiveConfig? config;

  /// The z-coordinate at which to place this card. This controls the size of
  /// the shadow below the card.
  ///
  /// Defines the card's [Material.elevation].
  ///
  /// Default is 2.
  final double? elevation;

  /// Creates an authentication wrapper with non-scrollable content.
  const AuthLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.boxWidth,
    this.shape,
    this.spacing,
    this.desktopDivider,
    this.tabletDivider,
    this.mobileDivider,
    this.divider,
    this.config,
    this.elevation
  }) : isScrollable = false;

  /// Creates an authentication wrapper with scrollable content.
  const AuthLayout.scrollable({
    super.key,
    required this.child,
    this.backgroundColor,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.boxWidth,
    this.shape,
    this.spacing,
    this.desktopDivider,
    this.tabletDivider,
    this.mobileDivider,
    this.divider,
    this.config,
    this.elevation
  }) : isScrollable = true;

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil breakPoint = ResponsiveUtil(context, config: config);

    if (breakPoint.isDesktop || breakPoint.isTablet) {
      Double div = breakPoint.isDesktop
          ? desktopDivider ?? 2.5
          : breakPoint.isTablet && tabletDivider.isNotNull
          ? tabletDivider!
          : breakPoint.isMobile && mobileDivider.isNotNull
          ? mobileDivider!
          : divider.isNotNull
          ? divider!
          : 1.6;

      Widget childView = Column(
        children: [
          child,
          const SizedBox(height: 30),
        ],
      );

      return Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: boxWidth ?? MediaQuery.sizeOf(context).width / div,
              child: Card(
                elevation: elevation ?? 2,
                color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: isScrollable ? SingleChildScrollView(child: childView) : childView,
              ),
            ),
          ),
        ],
      );
    } else if (isScrollable) {
      return SingleChildScrollView(child: child);
    } else {
      return child;
    }
  }
}