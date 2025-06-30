import 'package:flutter/material.dart';

/// A widget that provides optional animation transitions for paginated content.
///
/// [PagedBuilderAnimator] is typically used inside a paginated list view,
/// such as with [PagedBuilder], to smoothly animate changes between states
/// (e.g., loading, error, data loaded).
///
/// When [animateTransitions] is `true`, it wraps the [child] in an
/// [AnimatedSwitcher] to provide fade/scale/slide transitions when the child changes.
/// Otherwise, it simply returns the [child] without any animation.
///
/// ---
///
/// ### Example
/// ```dart
/// PagedBuilderAnimator(
///   animateTransitions: true,
///   transitionDuration: Duration(milliseconds: 300),
///   child: _buildCurrentStateWidget(), // Could be loading/error/completed
/// )
/// ```
///
/// ---
///
/// ### Parameters
/// - [child]: The widget to be displayed with or without animation.
/// - [animateTransitions]: Whether to apply animation on state changes.
/// - [transitionDuration]: The duration of the transition animation.
class PagedBuilderAnimator extends StatelessWidget {
  /// The widget to display, optionally animated.
  final Widget child;

  /// Whether to animate transitions between state changes.
  final bool animateTransitions;

  /// The duration of the animation when [animateTransitions] is true.
  final Duration transitionDuration;

  /// Creates a [PagedBuilderAnimator].
  ///
  /// If [animateTransitions] is false, the [child] will be returned without
  /// any animation.
  const PagedBuilderAnimator({
    required this.child,
    required this.animateTransitions,
    required this.transitionDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (!animateTransitions) {
      return child;
    }

    return AnimatedSwitcher(
      duration: transitionDuration,
      child: child,
    );
  }
}