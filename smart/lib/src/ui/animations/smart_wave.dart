import 'dart:math';
import 'package:flutter/material.dart';

/// A customizable audio wave widget that can display static or animated bars.
///
/// Use [isAnimated] to toggle animation, and configure appearance with
/// [count], [minHeight], [maxHeight], [barWidth], [spacing], etc.
///
/// Example:
/// ```dart
/// SmartWave(
///   isAnimated: true,
///   count: 15,
///   color: Colors.deepOrange,
/// )
/// ```
class SmartWave extends StatefulWidget {
  /// The number of wave bars (will be mirrored symmetrically).
  final int count;

  /// Minimum height of each bar.
  final double minHeight;

  /// Maximum height of each bar.
  final double maxHeight;

  /// Width of each individual bar.
  final double barWidth;

  /// Space between each bar.
  final double spacing;

  /// Color of the bars.
  final Color color;

  /// Whether the wave is animated or static.
  final bool isAnimated;

  /// Duration of the animation cycle.
  final Duration duration;

  /// Curve of the animation.
  final Curve curve;

  /// Optional custom animation builder (for advanced use).
  final double Function(int index, double animationValue)? customHeightBuilder;

  const SmartWave({
    Key? key,
    this.count = 13,
    this.minHeight = 6,
    this.maxHeight = 26,
    this.barWidth = 3,
    this.spacing = 2,
    this.color = Colors.blue,
    this.isAnimated = false,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.customHeightBuilder,
  }) : super(key: key);

  @override
  State<SmartWave> createState() => _SmartWaveState();
}

class _SmartWaveState extends State<SmartWave> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    if (widget.isAnimated) {
      _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.isAnimated) {
      _controller.dispose();
    }
    super.dispose();
  }

  double _defaultHeightBuilder(int index, double animationValue) {
    final mid = (widget.count - 1) / 2;
    final symmetryFactor = 1 - ((index - mid).abs() / mid);
    final phaseShift = (index / widget.count) * 2 * pi;
    final waveValue = sin(animationValue * 2 * pi + phaseShift); // -1 to 1
    final normalized = (waveValue + 1) / 2; // 0 to 1
    return widget.minHeight + (widget.maxHeight - widget.minHeight) * symmetryFactor * normalized;
  }

  double _barHeight(int index, double value) {
    if (widget.customHeightBuilder != null) {
      return widget.customHeightBuilder!(index, value);
    }
    return _defaultHeightBuilder(index, value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) {
      // Static wave with symmetrical heights
      final mid = (widget.count - 1) / 2;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.count * 2 - 1, (i) {
          if (i.isOdd) return SizedBox(width: widget.spacing);
          final index = i ~/ 2;
          final symmetryFactor = 1 - ((index - mid).abs() / mid);
          final height = widget.minHeight +
              (widget.maxHeight - widget.minHeight) * symmetryFactor;
          return _buildBar(height);
        }),
      );
    }

    // Animated wave
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final value = _animation.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.count * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(width: widget.spacing);
            final index = i ~/ 2;
            final height = _barHeight(index, value);
            return _buildBar(height);
          }),
        );
      },
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: widget.barWidth,
      height: height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.barWidth / 2),
      ),
    );
  }
}