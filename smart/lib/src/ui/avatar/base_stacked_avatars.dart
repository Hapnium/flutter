import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

import '../export.dart';

/// {@template base_stacked_avatars}
/// A widget that displays a list of avatars in a stacked format.
///
/// - Supports displaying up to 3 avatars side-by-side with overlapping positions.
/// - If more than 3 avatars are provided, a "+X" badge is shown for the remaining count.
/// - Allows full customization of avatar appearance and badge display.
///
/// - [T] is the type of data for the avatars.
/// 
/// {@endtemplate}
abstract class BaseStackedAvatars<T> extends StatelessWidget {
  /// List of avatar items to display.
  final List<T> avatars;

  /// Builder for creating each avatar. Provides metadata about the avatar's position and item.
  final ItemTypeWidgetBuilder<T> itemBuilder;

  /// The size of each avatar (width and height).
  final double avatarSize;

  /// Alignment of the stack. Default is [AlignmentDirectional.topStart].
  final AlignmentGeometry alignment;

  /// The text direction for the stack. Default is inherited from the app context.
  final TextDirection? textDirection;

  /// How to size non-positioned children in the stack. Default is [StackFit.loose].
  final StackFit fit;

  /// Defines how the stack should clip overflowing children. Default is [Clip.none].
  final Clip clipBehavior;

  /// Background color for the remaining count badge. Default is a light gray.
  final Color? backgroundColor;

  /// Text color for the "+X" badge. Default is black.
  final Color? textColor;

  /// Font size for the "+X" badge text. Default is 14.
  final double? fontSize;

  /// Font weight for the "+X" badge text. Default is [FontWeight.bold].
  final FontWeight? fontWeight;

  /// Whether the badge text should auto-size to fit the badge. Default is false.
  final bool autoSize;

  /// The total number of avatars to be rendered.
  ///
  /// Defaults to 3
  final int totalAvatarsInView;

  /// Whether to show the remaining count badge.
  ///
  /// Defaults to true
  final bool showRemainingCount;

  /// Creates a [BaseStackedAvatars] widget.
  /// 
  /// {@macro base_stacked_avatars}
  const BaseStackedAvatars({
    super.key,
    required this.avatars,
    required this.itemBuilder,
    this.avatarSize = 40.0,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.none,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.autoSize = false,
    this.showRemainingCount = true,
    this.totalAvatarsInView = 3
  });

  @override
  @protected
  @nonVirtual
  Widget build(BuildContext context) {
    // Determine the number of displayed avatars (up to 3)
    final displayedAvatars = avatars.length.isGt(totalAvatarsInView)
        ? avatars.sublist(0, totalAvatarsInView)
        : avatars;

    final remainingCount = avatars.length.isGt(totalAvatarsInView)
        ? avatars.length - totalAvatarsInView
        : 0;

    // Calculate width: (number of avatars - 1) * overlap size + avatar size
    // Add extra space if the remaining count badge is displayed
    final containerWidth = (displayedAvatars.length - 1) * (avatarSize / 2) +
        avatarSize + (remainingCount > 0 ? avatarSize / 2 : 0);

    final containerHeight = avatarSize; // Height is just the size of one avatar

    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        alignment: alignment,
        textDirection: textDirection,
        fit: fit,
        clipBehavior: clipBehavior,
        children: [
          ...displayedAvatars.asMap().entries.map((avatar) {
            ItemMetadata<T> metadata = ItemMetadata(
              isFirst: avatar.key == 0,
              isLast: avatar.key == avatars.length - 1,
              totalItems: avatars.length,
              index: avatar.key,
              item: avatar.value,
            );

            return Positioned(
              left: avatar.key * (avatarSize / 2), // Overlapping by half the size
              child: itemBuilder(context, metadata),
            );
          }),

          // If there are more avatars, show a "+X" badge
          if (remainingCount.isGt(0) && showRemainingCount) ...[
            Positioned(
              left: 3 * (avatarSize / 2), // Position after the third avatar
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: backgroundColor ?? Colors.grey[300], // Default badge color
                child: TextBuilder(
                  text: '+$remainingCount',
                  color: textColor ?? Colors.black,
                  weight: fontWeight ?? FontWeight.bold,
                  size: fontSize ?? 14,
                  autoSize: autoSize,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}