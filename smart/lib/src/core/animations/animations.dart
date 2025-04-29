import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'smart_animated_builder.dart';

typedef OffsetBuilder = Offset Function(BuildContext, double);

class FadeInAnimation extends OpacityAnimation {
  FadeInAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 0,
    super.end = 1,
    super.idleValue = 0,
  });
}

class FadeOutAnimation extends OpacityAnimation {
  FadeOutAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 1,
    super.end = 0,
    super.idleValue = 1,
  });
}

class OpacityAnimation extends SmartAnimatedBuilder<double> {
  OpacityAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    required super.onComplete,
    required double begin,
    required double end,
    required super.idleValue,
  }) : super(
    tween: Tween<double>(begin: begin, end: end),
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: child!,
      );
    },
  );
}

class RotateAnimation extends SmartAnimatedBuilder<double> {
  RotateAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform.rotate(
      angle: value,
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class ScaleAnimation extends SmartAnimatedBuilder<double> {
  ScaleAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform.scale(
      scale: value,
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

// class SlideAnimation extends SmartAnimatedBuilder<Offset> {
//   SlideAnimation({
//     super.key,
//     required super.duration,
//     required super.delay,
//     required super.child,
//     super.onComplete,
//     required Offset begin,
//     required Offset end,
//     super.idleValue = const Offset(0, 0),
//   }) : super(
//           builder: (context, value, child) => Transform.translate(
//             offset: value,
//             child: child,
//           ),
//           tween: Tween(begin: begin, end: end),
//         );
// }

class BounceAnimation extends SmartAnimatedBuilder<double> {
  BounceAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.curve = Curves.bounceOut,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform.scale(
      scale: 1 + value.abs(),
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class SpinAnimation extends SmartAnimatedBuilder<double> {
  SpinAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform.rotate(
      angle: value * pi / 180.0,
      child: child,
    ),
    tween: Tween<double>(begin: 0, end: 360),
  );
}

class SizeAnimation extends SmartAnimatedBuilder<double> {
  SizeAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
    required double begin,
    required double end,
  }) : super(
    builder: (context, value, child) => Transform.scale(
      scale: value,
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class BlurAnimation extends SmartAnimatedBuilder<double> {
  BlurAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: value,
        sigmaY: value,
      ),
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class FlipAnimation extends SmartAnimatedBuilder<double> {
  FlipAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) {
      final radians = value * pi;
      return Transform(
        transform: Matrix4.rotationY(radians),
        alignment: Alignment.center,
        child: child,
      );
    },
    tween: Tween<double>(begin: begin, end: end),
  );
}

class WaveAnimation extends SmartAnimatedBuilder<double> {
  WaveAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform(
      transform: Matrix4.translationValues(
        0.0,
        20.0 * sin(value * pi * 2),
        0.0,
      ),
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class WobbleAnimation extends SmartAnimatedBuilder<double> {
  WobbleAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateZ(sin(value * pi * 2) * 0.1),
      alignment: Alignment.center,
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class SlideInLeftAnimation extends SlideAnimation {
  SlideInLeftAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
    offsetBuild: (context, value) =>
        Offset(value * MediaQuery.of(context).size.width, 0),
  );
}

class SlideInRightAnimation extends SlideAnimation {
  SlideInRightAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
    offsetBuild: (context, value) =>
        Offset((1 - value) * MediaQuery.of(context).size.width, 0),
  );
}

class SlideInUpAnimation extends SlideAnimation {
  SlideInUpAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
    offsetBuild: (context, value) =>
        Offset(0, value * MediaQuery.of(context).size.height),
  );
}

class SlideInDownAnimation extends SlideAnimation {
  SlideInDownAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
    offsetBuild: (context, value) =>
        Offset(0, (1 - value) * MediaQuery.of(context).size.height),
  );
}

class SlideAnimation extends SmartAnimatedBuilder<double> {
  SlideAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    required double begin,
    required double end,
    required OffsetBuilder offsetBuild,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
    builder: (context, value, child) => Transform.translate(
      offset: offsetBuild(context, value),
      child: child,
    ),
    tween: Tween<double>(begin: begin, end: end),
  );
}

class ZoomAnimation extends SmartAnimatedBuilder<double> {
  ZoomAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
      builder: (context, value, child) => Transform.scale(
        scale: lerpDouble(1, end, value)!,
        child: child,
      ),
      tween: Tween<double>(begin: begin, end: end),
    );
}

class ColorAnimation extends SmartAnimatedBuilder<Color?> {
  ColorAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required Color begin,
    required Color end,
    Color? idleColor,
  }) : super(
    builder: (context, value, child) => ColorFiltered(
      colorFilter: ColorFilter.mode(
        Color.lerp(begin, end, value!.a.toDouble())!,
        BlendMode.srcIn,
      ),
      child: child,
    ),
    idleValue: idleColor ?? begin,
    tween: ColorTween(begin: begin, end: end),
  );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment? centerAlignment;
  final Offset? centerOffset;
  final double? minRadius;
  final double? maxRadius;

  CircularRevealClipper({
    required this.fraction,
    this.centerAlignment,
    this.centerOffset,
    this.minRadius,
    this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final center = centerAlignment?.alongSize(size) ??
        centerOffset ??
        Offset(size.width / 2, size.height / 2);
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius ?? calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction)!,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }
}