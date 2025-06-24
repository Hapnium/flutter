import 'package:flutter/material.dart';
import 'package:smart/utilities.dart';

import '../loading/loading.dart';
import '../text/text_builder.dart';

/// {@template interactive_button}
/// A customizable button widget with a built-in loading indicator.
///
/// The `LoadingButton` supports different styles, icons, custom padding, and auto-sizing.
/// It can display a loading indicator while an action is in progress.
///
/// Example usage:
/// ```dart
/// LoadingButton(
///   text: "Submit",
///   onClick: () => print("Button clicked"),
///   loading: true,
/// )
/// ```
/// 
/// {@endtemplate}
class InteractiveButton extends StatelessWidget {
  /// The background color of the button.
  final Color? buttonColor;

  /// The text color of the button.
  final Color? textColor;

  /// The font size of the button text.
  final double textSize;

  /// Whether the button is in a loading state.
  ///
  /// If `true`, the button will display a loading indicator instead of text.
  final bool loading;

  /// The widget used as a loading indicator.
  ///
  /// If `null`, defaults to a circular loading indicator.
  final Widget? loader;

  /// The font weight of the button text.
  final FontWeight textWeight;

  /// The border radius of the button.
  ///
  /// Controls the corner roundness of the button.
  final double borderRadius;

  /// The font family for the button text.
  final String? fontFamily;

  /// The callback function triggered when the button is pressed.
  ///
  /// If `loading` or `notEnabled` is `true`, the button is disabled.
  final VoidCallback? onClick;

  /// The text displayed inside the button.
  final String text;

  /// The padding around the button content.
  final EdgeInsetsGeometry? padding;

  /// An optional prefix icon displayed before the text.
  final IconData? prefixIcon;

  /// An optional suffix icon displayed after the text.
  final IconData? suffixIcon;

  /// The size of the prefix icon.
  final double? prefixIconSize;

  /// The size of the suffix icon.
  final double? suffixIconSize;

  /// The size of the loading indicator.
  final double? loadingSize;

  /// Whether the button is disabled.
  ///
  /// If `true`, the button is styled differently and cannot be clicked.
  final bool notEnabled;

  /// Whether the button has circular corners.
  ///
  /// If `false`, only the left side will be rounded.
  final bool isCircular;

  /// The width of the button.
  ///
  /// If `null`, the button adjusts based on its content size.
  final double? width;

  /// Whether the text should automatically resize to fit the button width.
  final bool autoSize;

  /// A customizable button widget with a built-in loading indicator.
  ///
  /// The `LoadingButton` supports different styles, icons, custom padding, and auto-sizing.
  /// It can display a loading indicator while an action is in progress.
  ///
  /// Creates a `LoadingButton` widget.
  ///
  /// Example:
  /// ```dart
  /// LoadingButton(
  ///   text: "Submit",
  ///   onClick: () => print("Clicked"),
  ///   loading: true,
  /// )
  /// ```
  /// 
  /// {@macro interactive_button}
  InteractiveButton({
    super.key,
    this.buttonColor,
    this.textColor,
    this.textSize = 14,
    this.loading = false,
    this.textWeight = FontWeight.normal,
    this.borderRadius = 8,
    this.onClick,
    required this.text,
    this.padding,
    this.fontFamily,
    this.loadingSize,
    this.prefixIcon,
    this.prefixIconSize = 20,
    this.suffixIcon,
    this.suffixIconSize,
    this.notEnabled = false,
    this.isCircular = true,
    this.width,
    this.autoSize = true,
    this.loader,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text color based on button state
    final color = notEnabled
        ? buttonColor ?? Theme.of(context).primaryColor
        : textColor ?? Theme.of(context).splashColor;

    // Determine padding or use default spacing
    final paddingValue = padding ?? EdgeInsets.all(Sizing.space(14));

    // Calculate the width of the text label
    double labelWidth = 0;
    if (text.isNotEmpty) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: textSize,
          fontWeight: textWeight,
        ),
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout(maxWidth: double.infinity);
      labelWidth = textPainter.width;
    }

    // Calculate the total width of the button content
    double contentWidth = labelWidth + paddingValue.horizontal;

    // Default loader widget if no custom one is provided
    Widget loaderWidget = loader ??
        Loading.circular(
          color: textColor ?? Theme.of(context).splashColor,
          size: loadingSize ?? Loading.circular().size,
        );

    return ClipRRect(
      borderRadius: isCircular
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      ),
      child: Material(
        color: notEnabled
            ? textColor ?? Theme.of(context).splashColor
            : buttonColor ?? Theme.of(context).primaryColor,
        child: InkWell(
          onTap: loading || notEnabled ? null : onClick,
          child: Padding(
            padding: paddingValue,
            child: SizedBox(
              width: width ?? contentWidth,
              child: Row(
                mainAxisAlignment: _getAlignment(),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, size: prefixIconSize, color: color),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Center(
                      child: loading
                          ? loaderWidget
                          : TextBuilder.center(
                        text: text,
                        color: color,
                        size: textSize,
                        weight: textWeight,
                        fontFamily: fontFamily,
                        autoSize: autoSize,
                      ),
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 10),
                    Icon(suffixIcon, size: suffixIconSize, color: color),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Determines the alignment of the row based on icons.
  MainAxisAlignment _getAlignment() {
    if (prefixIcon != null && suffixIcon != null) {
      return MainAxisAlignment.spaceBetween;
    } else if (prefixIcon != null || suffixIcon != null) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.center;
    }
  }
}