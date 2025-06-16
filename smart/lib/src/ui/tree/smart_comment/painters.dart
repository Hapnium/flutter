// ============================================================================
// CUSTOM PAINTER CLASSES
// ============================================================================

import 'package:flutter/material.dart';

/// Custom painter that draws connecting lines for child comments.
/// 
/// This painter draws:
/// - Curved horizontal lines connecting parent to child
/// - Vertical continuation lines (if not the last child)
/// - Handles RTL text direction
class ChildPainter extends CustomPainter {
  /// Whether this is the last child at the current level.
  final bool isLast;

  /// Padding applied to the child widget.
  final EdgeInsets padding;

  /// Text direction for RTL support.
  final TextDirection textDirection;

  /// Size of the parent comment's avatar.
  final Size parentAvatarSize;

  /// Color of the connecting lines.
  final Color pathColor;

  /// Divider value for line position calculations.
  final double divider;

  /// Width of the connecting lines.
  final double strokeWidth;

  /// Current nesting level.
  final int nestingLevel;

  /// Paint object for drawing lines.
  late Paint _paint;

  /// Creates a ChildPainter.
  /// 
  /// **Parameters:**
  /// - `isLast`: Whether this is the last child
  /// - `textDirection`: Text direction for RTL support
  /// - `padding`: Padding applied to child
  /// - `parentAvatarSize`: Size of parent's avatar
  /// - `pathColor`: Color of lines
  /// - `strokeWidth`: Width of lines
  /// - `divider`: Line position calculation factor
  /// - `nestingLevel`: Current nesting depth
  ChildPainter({
    required this.isLast,
    required this.textDirection,
    required this.padding,
    required this.parentAvatarSize,
    required this.pathColor,
    required this.strokeWidth,
    required this.divider,
    required this.nestingLevel,
  }) {
    _paint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  /// Paints the connecting lines on the canvas.
  /// 
  /// **Drawing Logic:**
  /// 1. Calculate line start position based on parent avatar and divider
  /// 2. Draw curved path from parent to child position
  /// 3. Draw vertical continuation line if not the last child
  /// 4. Handle RTL by translating canvas and inverting X coordinates
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();

    // Handle RTL text direction
    if (textDirection == TextDirection.rtl) {
      canvas.translate(size.width, 0);
    }

    // Calculate line start position
    double rootDx = parentAvatarSize.width / divider;
    if (textDirection == TextDirection.rtl) {
      rootDx *= -1;
    }

    // Draw curved connecting line
    path.moveTo(rootDx, 0);
    path.cubicTo(
      rootDx,
      0,
      rootDx,
      padding.top + parentAvatarSize.height / divider,
      rootDx * divider + divider,
      padding.top + parentAvatarSize.height / divider,
    );
    canvas.drawPath(path, _paint);

    // Draw vertical continuation line if not the last child
    if (!isLast) {
      canvas.drawLine(
        Offset(rootDx, 0),
        Offset(rootDx, size.height),
        _paint,
      );
    }
  }

  /// Determines if the painter should repaint.
  /// 
  /// **Returns:** Always true to ensure proper repainting
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter that draws vertical lines for nested comments.
/// 
/// This painter draws vertical lines from the avatar bottom to the
/// widget bottom, indicating that this comment has children.
class NestedPainter extends CustomPainter {
  /// Size of the comment's avatar.
  final Size avatar;

  /// Color of the connecting lines.
  final Color pathColor;

  /// Width of the connecting lines.
  final double strokeWidth;

  /// Divider value for line position calculations.
  final double divider;

  /// Text direction for RTL support.
  final TextDirection textDirection;

  /// Whether this comment has children.
  final bool hasChildren;

  /// Current nesting level.
  final int nestingLevel;

  /// Paint object for drawing lines.
  late Paint _paint;

  /// Creates a NestedPainter.
  /// 
  /// **Parameters:**
  /// - `avatar`: Size of the avatar
  /// - `pathColor`: Color of lines
  /// - `strokeWidth`: Width of lines
  /// - `textDirection`: Text direction for RTL support
  /// - `divider`: Line position calculation factor
  /// - `hasChildren`: Whether this comment has children
  /// - `nestingLevel`: Current nesting depth
  NestedPainter(
    this.avatar,
    this.pathColor,
    this.strokeWidth,
    this.textDirection,
    this.divider,
    this.hasChildren,
    this.nestingLevel,
  ) {
    _paint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  /// Paints vertical lines if the comment has children.
  /// 
  /// **Drawing Logic:**
  /// 1. Return early if no children
  /// 2. Calculate line position based on avatar size and divider
  /// 3. Draw vertical line from avatar bottom to widget bottom
  /// 4. Handle RTL by translating canvas and inverting X coordinates
  @override
  void paint(Canvas canvas, Size size) {
    if (!hasChildren) return;

    // Handle RTL text direction
    if (textDirection == TextDirection.rtl) {
      canvas.translate(size.width, 0);
    }

    // Calculate line position
    double dx = avatar.width / divider;
    if (textDirection == TextDirection.rtl) {
      dx *= -1;
    }

    // Draw vertical line
    canvas.drawLine(
      Offset(dx, avatar.height),
      Offset(dx, size.height),
      _paint,
    );
  }

  /// Determines if the painter should repaint.
  /// 
  /// **Returns:** Always true to ensure proper repainting
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter that draws vertical lines for root comments.
/// 
/// This painter draws vertical lines from the avatar bottom to the
/// widget bottom for root comments that have children.
class RootPainter extends CustomPainter {
  /// Size of the root comment's avatar.
  final Size avatar;

  /// Color of the connecting lines.
  final Color pathColor;

  /// Width of the connecting lines.
  final double strokeWidth;

  /// Divider value for line position calculations.
  final double divider;

  /// Text direction for RTL support.
  final TextDirection textDirection;

  /// Whether to draw the connecting line.
  final bool drawLine;

  /// Paint object for drawing lines.
  late Paint _paint;

  /// Creates a RootPainter.
  /// 
  /// **Parameters:**
  /// - `avatar`: Size of the avatar
  /// - `pathColor`: Color of lines
  /// - `strokeWidth`: Width of lines
  /// - `textDirection`: Text direction for RTL support
  /// - `divider`: Line position calculation factor
  /// - `drawLine`: Whether to draw the line
  RootPainter(
    this.avatar,
    this.pathColor,
    this.strokeWidth,
    this.textDirection,
    this.divider,
    this.drawLine
  ) {
    _paint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  /// Paints vertical lines if drawLine is true.
  /// 
  /// **Drawing Logic:**
  /// 1. Return early if drawLine is false
  /// 2. Calculate line position based on avatar size and divider
  /// 3. Draw vertical line from avatar bottom to widget bottom
  /// 4. Handle RTL by translating canvas and inverting X coordinates
  @override
  void paint(Canvas canvas, Size size) {
    if (!drawLine) return;

    // Handle RTL text direction
    if (textDirection == TextDirection.rtl) {
      canvas.translate(size.width, 0);
    }

    // Calculate line position
    double dx = avatar.width / divider;
    if (textDirection == TextDirection.rtl) {
      dx *= -1;
    }

    // Draw vertical line
    canvas.drawLine(
      Offset(dx, avatar.height),
      Offset(dx, size.height),
      _paint,
    );
  }

  /// Determines if the painter should repaint.
  /// 
  /// **Returns:** Always true to ensure proper repainting
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}