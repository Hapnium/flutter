import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';
import 'text_auto_sizing.dart';

/// A customizable text widget that supports auto-sizing.
///
/// This widget allows defining text properties such as font size, weight, alignment,
/// color, and optional text auto-sizing.
class TextBuilder extends StatelessWidget {
  /// The text to be displayed.
  final String text;

  /// The font size of the text. Default is `14.0`.
  final Double size;

  /// The font weight of the text. Default is `FontWeight.normal`.
  final FontWeight weight;

  /// The text alignment. Default is `TextAlign.left`.
  final TextAlign align;

  /// The font style (normal or italic). Default is `FontStyle.normal`.
  final FontStyle style;

  /// The overflow behavior of the text.
  final TextOverflow? flow;

  /// The text color. Default is `Colors.white`.
  final Color color;

  /// Determines whether text wrapping is enabled.
  final Boolean? wrap;

  /// The maximum number of lines the text can occupy.
  final Integer? lines;

  /// The font family used for the text.
  final String? fontFamily;

  /// The text decoration (e.g., underline, strikethrough).
  final TextDecoration? decoration;

  /// Enables or disables automatic text sizing.
  final Boolean autoSize;

  /// A customizable text widget that supports auto-sizing.
  ///
  /// This widget allows defining text properties such as font size, weight, alignment,
  /// color, and optional text auto-sizing.
  ///
  /// Creates a `TextBuilder` widget with left alignment.
  const TextBuilder({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.fontFamily,
    this.align = TextAlign.left,
    this.color = Colors.white,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.autoSize = true,
  });

  /// A customizable text widget that supports auto-sizing.
  ///
  /// This widget allows defining text properties such as font size, weight, alignment,
  /// color, and optional text auto-sizing.
  ///
  /// Creates a `TextBuilder` widget with justified text alignment.
  const TextBuilder.justify({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = Colors.white,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true,
  }) : align = TextAlign.justify;

  /// A customizable text widget that supports auto-sizing.
  ///
  /// This widget allows defining text properties such as font size, weight, alignment,
  /// color, and optional text auto-sizing.
  ///
  /// Creates a `TextBuilder` widget with right-aligned text.
  const TextBuilder.right({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = Colors.white,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true,
  }) : align = TextAlign.right;

  /// A customizable text widget that supports auto-sizing.
  ///
  /// This widget allows defining text properties such as font size, weight, alignment,
  /// color, and optional text auto-sizing.
  ///
  /// Creates a `TextBuilder` widget with center-aligned text.
  const TextBuilder.center({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = Colors.white,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true,
  }) : align = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    if (autoSize) {
      return TextAutoSizing(
        text,
        textAlign: align,
        overflow: flow,
        softWrap: wrap,
        maxLines: lines,
        style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontStyle: style,
          decoration: decoration,
        ),
      );
    } else {
      return Text(
        text,
        textAlign: align,
        overflow: flow,
        softWrap: wrap,
        maxLines: lines,
        style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontStyle: style,
          decoration: decoration,
        ),
      );
    }
  }
}