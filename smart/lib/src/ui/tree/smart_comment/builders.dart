// ============================================================================
// HELPER WIDGET CLASSES
// ============================================================================

import 'package:flutter/material.dart';

import 'painters.dart';

/// A widget that wraps child comments with proper padding and connecting lines.
/// 
/// This widget:
/// - Calculates proper indentation for child comments
/// - Draws connecting lines using `ChildPainter`
/// - Handles RTL text direction
/// - Aligns child avatars with parent content
class ChildBuilder extends StatelessWidget {
  /// The child widget (typically a nested `SmartCommentThread`).
  final Widget child;

  /// Whether this is the last child in the current level.
  /// 
  /// Used to determine if vertical continuation lines should be drawn.
  final bool isLast;

  /// The size of the parent comment's avatar.
  /// 
  /// Used to calculate proper indentation and line positioning.
  final Size parentAvatarSize;

  /// The color of the connecting lines.
  final Color lineColor;

  /// The width of the connecting lines.
  final double lineWidth;

  /// The divider value for line position calculations.
  final double divider;

  /// The current nesting level.
  /// 
  /// Can be used for styling differences at different depths.
  final int nestingLevel;

  /// Creates a ChildBuilder widget.
  /// 
  /// **Parameters:**
  /// - `isLast`: Whether this is the last child at this level
  /// - `child`: The child widget to wrap
  /// - `parentAvatarSize`: Size of the parent's avatar for alignment
  /// - `lineColor`: Color of connecting lines
  /// - `lineWidth`: Width of connecting lines
  /// - `divider`: Line position calculation factor
  /// - `nestingLevel`: Current nesting depth
  const ChildBuilder({
    super.key,
    required this.isLast,
    required this.child,
    required this.parentAvatarSize,
    required this.lineColor,
    required this.lineWidth,
    required this.divider,
    required this.nestingLevel,
  });

  /// Builds the child widget with proper padding and connecting lines.
  /// 
  /// **Behavior:**
  /// - Calculates indentation based on parent avatar size
  /// - Handles RTL text direction by swapping left/right padding
  /// - Uses `ChildPainter` to draw connecting lines
  /// - Aligns child avatars with parent content start position
  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    
    // Calculate padding to align child avatars with parent content
    final EdgeInsets padding = EdgeInsets.only(
      left: isRTL ? 0 : parentAvatarSize.width + 8.0,
      right: isRTL ? parentAvatarSize.width + 8.0 : 0,
    );

    return CustomPaint(
      painter: ChildPainter(
        isLast: isLast,
        divider: divider,
        padding: padding,
        textDirection: Directionality.of(context),
        parentAvatarSize: parentAvatarSize,
        pathColor: lineColor,
        strokeWidth: lineWidth,
        nestingLevel: nestingLevel,
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// A widget that renders nested comments (non-root comments).
/// 
/// This widget is used for all comments except the root comment.
/// It renders the avatar and content in a row layout and uses
/// `NestedPainter` to draw vertical continuation lines.
class NestedCommentBuilder extends StatelessWidget {
  /// The avatar widget for this comment.
  final PreferredSizeWidget avatar;

  /// The content widget for this comment.
  final Widget content;

  /// The color of connecting lines.
  final Color lineColor;

  /// The width of connecting lines.
  final double lineWidth;

  /// The divider value for line calculations.
  final double divider;

  /// The current nesting level.
  final int nestingLevel;

  /// Whether this comment has children.
  /// 
  /// Used to determine if vertical lines should be drawn.
  final bool hasChildren;

  /// Creates a NestedCommentBuilder widget.
  /// 
  /// **Parameters:**
  /// - `avatar`: The avatar widget
  /// - `content`: The content widget
  /// - `lineColor`: Color of connecting lines
  /// - `lineWidth`: Width of connecting lines
  /// - `divider`: Line position calculation factor
  /// - `nestingLevel`: Current nesting depth
  /// - `hasChildren`: Whether this comment has child comments
  const NestedCommentBuilder({
    super.key,
    required this.avatar,
    required this.content,
    required this.lineColor,
    required this.lineWidth,
    required this.divider,
    required this.nestingLevel,
    required this.hasChildren,
  });

  /// Builds the nested comment with avatar, content, and connecting lines.
  /// 
  /// **Layout:**
  /// - Avatar on the left (8px spacing from content)
  /// - Content takes remaining horizontal space
  /// - Vertical lines drawn by `NestedPainter` if has children
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NestedPainter(
        avatar.preferredSize,
        lineColor,
        lineWidth,
        Directionality.of(context),
        divider,
        hasChildren,
        nestingLevel,
      ),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          Expanded(child: content)
        ],
      ),
    );
  }
}

/// A widget that renders the root comment (top-level comment).
/// 
/// This widget is used only for the root comment in each thread.
/// It renders the avatar and content in a row layout and uses
/// `RootPainter` to draw vertical lines to children.
class RootBuilder extends StatelessWidget {
  /// The avatar widget for the root comment.
  final PreferredSizeWidget avatar;

  /// The color of connecting lines.
  final Color lineColor;

  /// The width of connecting lines.
  final double lineWidth;

  /// The content widget for the root comment.
  final Widget content;

  /// The divider value for line calculations.
  final double divider;

  /// Whether to draw connecting lines to children.
  /// 
  /// Set to false if there are no children or children are hidden.
  final bool drawLine;

  /// Creates a RootBuilder widget.
  /// 
  /// **Parameters:**
  /// - `avatar`: The avatar widget
  /// - `content`: The content widget
  /// - `lineColor`: Color of connecting lines
  /// - `lineWidth`: Width of connecting lines
  /// - `divider`: Line position calculation factor
  /// - `drawLine`: Whether to draw lines to children (default: true)
  const RootBuilder({
    super.key,
    required this.avatar,
    required this.content,
    required this.lineColor,
    required this.lineWidth,
    required this.divider,
    this.drawLine = true,
  });

  /// Builds the root comment with avatar, content, and connecting lines.
  /// 
  /// **Layout:**
  /// - Avatar on the left (8px spacing from content)
  /// - Content takes remaining horizontal space
  /// - Vertical lines drawn by `RootPainter` if drawLine is true
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RootPainter(
        avatar.preferredSize,
        lineColor,
        lineWidth,
        Directionality.of(context),
        divider,
        drawLine
      ),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          Expanded(child: content)
        ],
      ),
    );
  }
}