import 'dart:async';
import 'package:flutter/material.dart';

typedef TimerWidgetBuilder = Widget Function(BuildContext context, double progress, int remaining);

/// {@template smart_timer}
/// A countdown timer widget that supports circular or linear (square) styles.
///
/// The timer begins counting down when [startCounting] is true,
/// can be paused with [pause], and reset with [reset].
/// Once countdown completes, it stops and optionally shows a custom widget using [actionBuilder].
/// 
/// {@endtemplate}
class SmartTimer extends StatefulWidget {
  /// A widget to display when the countdown is complete or not active.
  final WidgetBuilder? actionBuilder;

  /// Optional override to display the timer widget.
  final TimerWidgetBuilder? timerBuilder;

  /// Triggers the timer to start counting down.
  final bool startCounting;

  /// Pauses the countdown timer.
  final bool pause;

  /// Resets the timer to [initialTimeout] and stops it.
  final bool reset;

  /// The total countdown duration in seconds.
  final int initialTimeout;

  /// Progress bar color.
  final Color color;

  /// Background color of the progress indicator.
  final Color backgroundColor;

  /// Style for the text showing the remaining time.
  final TextStyle? textStyle;

  /// Whether to show a circular timer. If false, shows linear.
  final bool isCircular;

  /// Border radius for linear progress (ignored for circular).
  final BorderRadiusGeometry? borderRadius;

  /// Padding around the time text.
  final EdgeInsetsGeometry? padding;

  /// Overall size of the progress indicator.
  final Size? size;

  /// Stroke width for circular timer (ignored for linear).
  final double? strokeWidth;

  /// Alignment of timer contents in the stack.
  final AlignmentGeometry? alignment;

  /// Stack fit behavior.
  final StackFit? fit;

  /// Clip behavior of the timer container.
  final Clip? clipBehavior;

  /// Text direction for rendering children.
  final TextDirection? textDirection;

  /// Animated color for the progress bar value.
  final Animation<Color?>? valueColor;

  /// Text color.
  final Color? textColor;

  /// Creates a circular countdown timer.
  /// 
  /// {@macro smart_timer}
  const SmartTimer.circular({
    super.key,
    this.actionBuilder,
    this.startCounting = false,
    this.pause = false,
    this.reset = false,
    this.initialTimeout = 60,
    this.color = Colors.blue,
    this.backgroundColor = Colors.blueAccent,
    this.textStyle,
    this.size,
    this.strokeWidth,
    this.alignment,
    this.fit,
    this.clipBehavior,
    this.valueColor,
    this.textDirection,
    this.padding,
    this.timerBuilder,
    this.textColor
  })  : isCircular = true, borderRadius = null;

  /// Creates a square/linear countdown timer.
  /// 
  /// {@macro smart_timer}
  const SmartTimer.square({
    super.key,
    this.actionBuilder,
    this.startCounting = false,
    this.pause = false,
    this.reset = false,
    this.initialTimeout = 60,
    this.color = Colors.blue,
    this.backgroundColor = Colors.blueAccent,
    this.textStyle,
    this.borderRadius,
    this.padding,
    this.size,
    this.alignment,
    this.fit,
    this.clipBehavior,
    this.textDirection,
    this.valueColor,
    this.timerBuilder,
    this.textColor
  })  : isCircular = false, strokeWidth = null;

  @override
  State<SmartTimer> createState() => _SmartTimerState();
}

class _SmartTimerState extends State<SmartTimer> {
  late int _timeout;
  Timer? _timer;
  bool _isCounting = false;
  Size _resolvedSize = const Size(48, 48);

  @override
  void initState() {
    super.initState();
    _timeout = widget.initialTimeout;
    _resolvedSize = widget.size ?? _resolvedSize;
    _handleControls();
  }

  @override
  void didUpdateWidget(covariant SmartTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleControls();
  }

  void _handleControls() {
    if (widget.reset) {
      _resetTimer();
    } else if (widget.pause) {
      _pauseTimer();
    } else if (widget.startCounting && !_isCounting) {
      _startTimer();
    }
  }

  void _startTimer() {
    _isCounting = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeout <= 1) {
        timer.cancel();
        setState(() {
          _timeout = 0;
          _isCounting = false;
        });
      } else {
        setState(() {
          _timeout--;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isCounting = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timeout = widget.initialTimeout;
      _isCounting = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (_timeout / widget.initialTimeout);

    if (!_isCounting && widget.actionBuilder != null) {
      return widget.actionBuilder!(context);
    }

    if(widget.timerBuilder != null) {
      return widget.timerBuilder!(context, progress, _timeout);
    }

    return Stack(
      alignment: widget.alignment ?? Alignment.center,
      fit: widget.fit ?? StackFit.loose,
      clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
      textDirection: widget.textDirection,
      children: [
        SizedBox(
          width: _resolvedSize.width,
          height: _resolvedSize.height,
          child: widget.isCircular ? CircularProgressIndicator(
            strokeWidth: widget.strokeWidth ?? 2.5,
            value: progress,
            color: widget.color,
            backgroundColor: widget.backgroundColor,
            valueColor: widget.valueColor,
          ) : ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              color: widget.color,
              backgroundColor: widget.backgroundColor,
              valueColor: widget.valueColor,
              minHeight: _resolvedSize.height,
              borderRadius: widget.borderRadius
            ),
          ),
        ),
        Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Text(
            "${_timeout}s",
            style: widget.textStyle ?? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: widget.textColor,
            ),
          ),
        ),
      ],
    );
  }
}