import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

/// {@template poll_animator}
/// A widget that animates a poll progress bar with customizable appearance and duration.
///
/// [PollAnimator] displays two bars:
/// - The background bar (representing the entire width of the poll).
/// - The progress bar (animated to the percentage of completion).
///
/// This widget also allows adding a child widget (e.g., text or icons) to overlay the progress bar.
/// 
/// {@endtemplate}
class PollAnimator extends StatelessWidget {
  /// The overall decoration of the progress bar, including borders and gradients.
  ///
  /// If `decoration` is not provided, a default decoration is applied with a
  /// rectangular shape and rounded corners (radius = 8).
  final BoxDecoration? decoration;

  /// The duration of the animation when the background bar appears or changes.
  ///
  /// Defaults to 300 milliseconds if not provided.
  final Duration? duration;

  /// The duration of the animation when the progress bar changes its width based on `percent`.
  ///
  /// Defaults to 1000 milliseconds if not provided.
  final Duration? animatedDuration;

  /// Inner padding of the poll bar, which defines spacing between the edges of the container
  /// and its contents (e.g., the progress bar).
  final EdgeInsetsGeometry? padding;

  /// Outer margin of the poll bar, which defines spacing between the container and
  /// surrounding widgets.
  final EdgeInsetsGeometry? margin;

  /// The percentage of the progress bar that should be filled.
  ///
  /// The value must be between 0.0 (0%) and 1.0 (100%). Required.
  final double percent;

  /// The height of the poll bar. If not provided, defaults to `40` pixels.
  final double? height;

  /// The width of the poll bar. If not provided, the width will expand to fill
  /// the available space within its parent.
  final double? width;

  /// The background color of the entire progress bar.
  ///
  /// This color represents the unfilled portion of the poll.
  final Color? backgroundColor;

  /// The color of the progress bar representing the filled portion.
  final Color? progressColor;

  /// The corner radius of the poll bar.
  ///
  /// If not provided, defaults to `8` pixels.
  final Radius? barRadius;

  /// An optional child widget to overlay on top of the poll bar.
  ///
  /// This child can display any content (e.g., text, icons, or labels).
  final Widget? child;

  /// Creates a [PollAnimator] widget.
  ///
  /// The [percent] parameter is required to indicate the progress level.
  /// Other parameters are optional and can be used to customize the appearance and behavior.
  ///
  /// The animation of the progress bar is controlled by [animatedDuration], while
  /// the animation of the background bar is controlled by [duration].
  /// 
  /// {@macro poll_animator}
  const PollAnimator({
    super.key,
    this.decoration,
    this.duration,
    this.animatedDuration,
    this.padding,
    this.margin,
    required this.percent,
    this.height,
    this.width,
    this.backgroundColor,
    this.progressColor,
    this.barRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the content dimensions
    double contentWidth = width ?? MediaQuery.of(context).size.width;
    double contentHeight = height ?? 40;

    // Default decoration if not provided
    BoxDecoration contentDecoration = decoration ?? BoxDecoration(
      border: decoration?.border,
      backgroundBlendMode: decoration?.backgroundBlendMode,
      boxShadow: decoration?.boxShadow,
      gradient: decoration?.gradient,
      image: decoration?.image,
      shape: decoration?.shape ?? BoxShape.rectangle,
      borderRadius: BorderRadius.all(barRadius ?? const Radius.circular(8)),
    );

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background bar
          Align(
            alignment: Alignment.centerLeft,
            child: _Animated(
              decoration: contentDecoration.copyWith(color: backgroundColor),
              duration: duration ?? const Duration(milliseconds: 300),
              percent: 1,
              height: contentHeight,
              width: contentWidth,
            ),
          ),
          // Progress bar
          Align(
            alignment: Alignment.centerLeft,
            child: _Animated(
              decoration: contentDecoration.copyWith(color: progressColor),
              duration: animatedDuration ?? const Duration(milliseconds: 1000),
              percent: percent,
              height: contentHeight,
              width: contentWidth,
            ),
          ),
          // Optional child overlay
          if (child.isNotNull)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: child!,
            ),
        ],
      ),
    );
  }
}

/// An internal widget used by [PollAnimator] to animate the progress bar.
///
/// [_Animated] smoothly transitions the width of the bar based on the `percent`
/// parameter and the given duration.
class _Animated extends StatelessWidget {
  /// The decoration applied to the bar.
  final Decoration decoration;

  /// The duration of the animation.
  final Duration duration;

  /// The percentage of the bar to be filled (0.0 to 1.0).
  final double percent;

  /// The height of the bar.
  final double height;

  /// The full width of the bar (before applying the `percent`).
  final double width;

  /// Creates an [_Animated] widget.
  ///
  /// This widget animates its width to a percentage of the given [width]
  /// based on the provided `percent` parameter and duration.
  const _Animated({
    required this.decoration,
    required this.duration,
    required this.percent,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width of the filled bar based on the percentage.
    double calculatedWidth = width * percent;

    return AnimatedContainer(
      duration: duration,
      height: height,
      decoration: decoration,
      width: calculatedWidth,
      constraints: BoxConstraints(maxWidth: calculatedWidth),
    );
  }
}