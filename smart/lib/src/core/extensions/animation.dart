import 'package:flutter/material.dart';

import '../animations/animations.dart';
import '../animations/smart_animated_builder.dart';

const _defaultDuration = Duration(seconds: 2);
const _defaultDelay = Duration.zero;

/// An extension on `Widget` that adds chainable animation helpers using SmartAnimatedBuilder.
/// Example usage:
///
/// ```dart
/// Text("Hello World")
///   .fadeIn(duration: Duration(seconds: 1))
///   .scale(begin: 0.5, end: 1.0)
/// ```
///
/// All animations support delay, duration, onComplete, and can be chained sequentially.
extension AnimationExtension on Widget {
  SmartAnimatedBuilder? get _currentAnimation => (this is SmartAnimatedBuilder) ? this as SmartAnimatedBuilder : null;

  /// Applies a fade-in animation to the widget.
  ///
  /// Useful for showing widgets smoothly.
  ///
  /// Example:
  /// ```dart
  /// Text("Welcome").fadeIn()
  /// ```
  SmartAnimatedBuilder fadeIn({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeOutAnimation, 'Cannot use fadeOut + fadeIn when isSequential is false');

    return FadeInAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  /// Applies a fade-out animation to the widget.
  ///
  /// Useful for hiding widgets smoothly.
  SmartAnimatedBuilder fadeOut({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeInAnimation, 'Cannot use fadeOut + fadeIn when isSequential is false');

    return FadeOutAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  /// Rotates the widget from [begin] to [end] (in turns, 1.0 = 360°).
  SmartAnimatedBuilder rotate({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return RotateAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Scales the widget from [begin] to [end].
  ///
  /// Example: `scale(begin: 0.0, end: 1.0)` grows from nothing.
  SmartAnimatedBuilder scale({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return ScaleAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Slides the widget based on a dynamic [offset] function.
  ///
  /// [begin] and [end] control the animation progress.
  ///
  /// ```dart
  /// .slide(offset: (_) => Offset(1, 0)) // Slide from right
  /// ```
  SmartAnimatedBuilder slide({
    required OffsetBuilder offset,
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SlideAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      offsetBuild: offset,
      child: this,
    );
  }

  /// Creates a bounce animation using [begin] and [end] scale factors.
  SmartAnimatedBuilder bounce({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BounceAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Rotates the widget endlessly in a spinning motion.
  SmartAnimatedBuilder spin({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SpinAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  /// Animates the size of a widget vertically or horizontally.
  ///
  /// Useful for collapsible sections or expanding containers.
  SmartAnimatedBuilder size({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SizeAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Applies a blur effect to the widget from [begin] to [end] radius.
  ///
  /// ```dart
  /// Image.network("...")
  ///   .blur(begin: 0, end: 10)
  /// ```
  SmartAnimatedBuilder blur({
    double begin = 0,
    double end = 15,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BlurAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Applies a flip animation (horizontal or vertical).
  ///
  /// ```dart
  /// Card(...).flip(begin: 0, end: 1)
  /// ```
  SmartAnimatedBuilder flip({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return FlipAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Waving effect like a flag or liquid ripple.
  SmartAnimatedBuilder wave({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return WaveAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Internal method to resolve the delay depending on whether this animation is sequential.
  Duration _getDelay(bool isSequential, Duration delay) {
    assert(
      !(isSequential && delay != Duration.zero),
      "Error: When isSequential is true, delay must be zero. Got: $delay",
    );

    return isSequential ? (_currentAnimation?.totalDuration ?? Duration.zero) : delay;
  }
}