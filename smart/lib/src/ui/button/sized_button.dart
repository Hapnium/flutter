import 'package:flutter/material.dart';
import 'package:smart/smart.dart' show TextBuilder, ButtonView, Sizing;

/// A customizable button widget with an icon and text, allowing for various sizing and styling options.
///
/// This widget combines an icon and text into a button-like component, providing
/// flexibility in terms of size, appearance, and behavior. It's designed to be
/// easily customizable to fit different UI requirements.
class SizedButton extends StatelessWidget {
  /// The [ButtonView] object containing the icon and text for the button.
  final ButtonView option;

  /// The callback function to be executed when the button is tapped.
  final VoidCallback? onTap;

  /// The width of the button.
  ///
  /// Defaults to 80
  final double? width;

  /// The height of the button.
  final double? height;

  /// Whether to ignore the specified width and use the intrinsic width of the content.
  ///
  /// Defaults to [false]
  final bool ignoreSize;

  /// The border radius of the button's corners.
  ///
  /// Defaults to [BorderRadius.circular(8)]
  final BorderRadius? borderRadius;

  /// The background color of the button.
  ///
  /// Defaults to [Theme.of(context).scaffoldBackgroundColor]
  final Color? backgroundColor;

  /// The padding around the button's content.
  ///
  /// Defaults to [EdgeInsets.all(8.0)]
  final EdgeInsetsGeometry? padding;

  /// The vertical spacing between the icon and text.
  ///
  /// Defaults to 10
  final double? spacing;

  /// The main axis size of the button's content (e.g., `MainAxisSize.min`).
  ///
  /// Defaults to [MainAxisSize.min]
  final MainAxisSize? mainAxisSize;

  /// The cross-axis alignment of the button's content (e.g., `CrossAxisAlignment.center`).
  ///
  /// Defaults to [CrossAxisAlignment.center]
  final CrossAxisAlignment? crossAxisAlignment;

  /// The color of the icon.
  ///
  /// Defaults to [Theme.of(context).primaryColorDark]
  final Color? iconColor;

  /// The size of the icon.
  ///
  /// Defaults to 18
  final double? iconSize;

  /// The cross-axis alignment of the text (e.g., `CrossAxisAlignment.center`).
  ///
  /// Defaults to [CrossAxisAlignment.center]
  final CrossAxisAlignment? textCrossAxisAlignment;

  /// The main-axis alignment of the text (e.g., `MainAxisAlignment.center`).
  ///
  /// Defaults to [MainAxisAlignment.center]
  final MainAxisAlignment? textMainAxisAlignment;

  /// Whether to automatically size the text to fit within the available space.
  ///
  /// Defaults to [false]
  final bool? autoSize;

  /// The color of the text.
  ///
  /// Defaults to [Theme.of(context).primaryColor]
  final Color? textColor;

  /// The size of the text.
  ///
  /// Defaults to [Sizing.font(12)]
  final double? textSize;

  /// How overflowing text should be handled.
  ///
  /// Defaults to [TextOverflow.ellipsis]
  final TextOverflow? textOverflow;

  /// Creates a [SizedButton] widget.
  const SizedButton({
    super.key,
    required this.option,
    this.onTap,
    this.width,
    this.height,
    this.ignoreSize = false,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.spacing,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.iconColor,
    this.iconSize,
    this.textCrossAxisAlignment,
    this.textMainAxisAlignment,
    this.autoSize,
    this.textColor,
    this.textSize,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ignoreSize ? null : (width ?? 80),
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Material(
          color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  spacing: spacing ?? 10,
                  mainAxisSize: mainAxisSize ?? MainAxisSize.min,
                  crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    Icon(
                      option.icon,
                      color: iconColor ?? Theme.of(context).primaryColorDark,
                      size: iconSize ?? 18,
                    ),
                    Row(
                      crossAxisAlignment: textCrossAxisAlignment ?? CrossAxisAlignment.center,
                      mainAxisAlignment: textMainAxisAlignment ?? MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextBuilder.center(
                            text: option.header,
                            autoSize: autoSize ?? false,
                            color: textColor ?? Theme.of(context).primaryColor,
                            size: textSize ?? Sizing.font(12),
                            flow: textOverflow ?? TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}