import 'package:flutter/material.dart';

import 'animations.dart';

/// {@template smart_animated_builder}
/// A generic, reusable animation widget that wraps `AnimatedBuilder` with
/// support for delayed start, idle values before animation, optional lifecycle
/// callbacks, and curve customization.
///
/// The `SmartAnimatedBuilder` starts the animation after a specified [delay],
/// then interpolates a [Tween] over the given [duration]. It also allows
/// specifying an [idleValue] that is used before the animation starts.
///
/// ### Features
/// - Delayed animation start via [delay]
/// - Pre-animation idle value rendering
/// - Optional [onStart] and [onComplete] lifecycle hooks
/// - Curve control via [curve]
/// - Child composition support
/// - Built-in support for animation subclasses like `FadeInAnimation`
///
/// ### Example:
/// ```dart
/// SmartAnimatedBuilder<double>(
///   delay: Duration(milliseconds: 300),
///   duration: Duration(milliseconds: 800),
///   idleValue: 0.0,
///   tween: Tween(begin: 0.0, end: 1.0),
///   builder: (context, value, child) {
///     return Opacity(opacity: value, child: child);
///   },
///   child: Text('Hello World'),
/// )
/// ```
/// {@endtemplate}
class SmartAnimatedBuilder<T> extends StatefulWidget {
  /// The duration of the animation.
  final Duration duration;

  /// The delay before the animation starts.
  final Duration delay;

  /// A static child widget passed to the builder.
  final Widget child;

  /// Callback triggered when the animation completes.
  final ValueSetter<AnimationController>? onComplete;

  /// Callback triggered when the animation starts.
  final ValueSetter<AnimationController>? onStart;

  /// The tween used to interpolate values of type [T].
  final Tween<T> tween;

  /// The value to show before the animation starts.
  final T idleValue;

  /// The builder function that receives the interpolated value.
  final ValueWidgetBuilder<T> builder;

  /// The curve applied to the tween animation.
  final Curve curve;

  /// Combined total time (delay + duration).
  Duration get totalDuration => duration + delay;

  /// Creates a [SmartAnimatedBuilder].
  /// 
  /// {@macro smart_animated_builder}
  const SmartAnimatedBuilder({
    super.key,
    this.curve = Curves.linear,
    this.onComplete,
    this.onStart,
    required this.duration,
    required this.tween,
    required this.idleValue,
    required this.builder,
    required this.child,
    required this.delay,
  });

  @override
  SmartAnimatedBuilderState<T> createState() => SmartAnimatedBuilderState<T>();
}

class SmartAnimatedBuilderState<T> extends State<SmartAnimatedBuilder<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<T> _animation;

  // AnimationController get controller => _controller;
  // Animation<T> get animation => _animation;

  bool _wasStarted = false;
  // bool get wasStarted => _wasStarted;

  late T _idleValue;

  bool _willResetOnDispose = false;

  bool get willResetOnDispose => _willResetOnDispose;

  void _listener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        widget.onComplete?.call(_controller);
        if (_willResetOnDispose) {
          _controller.reset();
        }
        break;
    // case AnimationStatus.dismissed:
      case AnimationStatus.forward:
        widget.onStart?.call(_controller);
        break;
    // case AnimationStatus.reverse:
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget is OpacityAnimation) {
      final current =
      context.findRootAncestorStateOfType<SmartAnimatedBuilderState>();
      final isLast = current == null;

      if (widget is FadeInAnimation) {
        _idleValue = 1.0 as dynamic;
      } else {
        if (isLast) {
          _willResetOnDispose = false;
        } else {
          _willResetOnDispose = true;
        }
        _idleValue = widget.idleValue;
      }
    } else {
      _idleValue = widget.idleValue;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_listener);

    _animation = widget.tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _wasStarted = true;
          _controller.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _wasStarted ? _animation.value : _idleValue;
        return widget.builder(context, value, child);
      },
      child: widget.child,
    );
  }
}