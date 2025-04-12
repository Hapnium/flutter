import 'package:flutter/material.dart';
import 'package:smart/extensions.dart';
import 'package:smart/src/styles/colors/common_colors.dart';

import 'shimmer.dart';

/// A widget that applies a shimmering effect to its child.
///
/// This widget uses the `Shimmer` widget to create a shimmering effect over its child.
/// It provides options to customize the base and highlight colors for both light
/// and dark mode.
class LoadingShimmer extends StatelessWidget {
  /// Whether the current theme is dark mode. Defaults to `false`.
  final bool isDarkMode;

  /// The base color for the shimmer effect in dark mode.
  /// Defaults to `Color(0xff8C8C8C)`.
  final Color? darkBaseColor;

  /// The base color for the shimmer effect in light mode.
  /// Defaults to `Color.fromARGB(255, 210, 210, 210)`.
  final Color? lightBaseColor;

  /// The highlight color for the shimmer effect in dark mode.
  /// Defaults to `Color.fromARGB(255, 176, 176, 176)`.
  final Color? darkHighlightColor;

  /// The highlight color for the shimmer effect in light mode.
  /// Defaults to `Colors.grey.shade300`.
  final Color? lightHighlightColor;

  /// The child widget to apply the shimmering effect to.
  final Widget content;

  /// A widget that applies a shimmering effect to its child.
  ///
  /// This widget uses the `Shimmer` widget to create a shimmering effect over its child.
  /// It provides options to customize the base and highlight colors for both light
  /// and dark mode.
  const LoadingShimmer({
    super.key,
    required this.content,
    this.isDarkMode = false,
    this.darkBaseColor,
    this.lightBaseColor,
    this.darkHighlightColor,
    this.lightHighlightColor
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDarkMode
        ? darkBaseColor ?? CommonColors.instance.shimmerHigh.darken(65)
        : lightBaseColor ?? const Color.fromARGB(255, 210, 210, 210),
      highlightColor: isDarkMode
        ? darkHighlightColor ?? CommonColors.instance.shimmerHigh.darken(66)
        : lightHighlightColor ?? Colors.grey.shade300,
      child: content
    );
  }
}