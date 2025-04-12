import 'package:flutter/cupertino.dart';

/// Configuration class for customizing field input styles.
/// 
/// This class allows you to define styles for labels, hints, and text within an input field.
/// It provides options for font weight, color, and size.
class FieldInputConfig {
  /// Font weight for the label text.
  final FontWeight? labelWeight;

  /// Font weight for the hint text.
  final FontWeight? hintWeight;

  /// Font weight for the main input text.
  final FontWeight? textWeight;

  /// Color of the label text.
  final Color? labelColor;

  /// Color of the hint text.
  final Color? hintColor;

  /// Color of the main input text.
  final Color? textColor;

  /// Size of the label text.
  final double? labelSize;

  /// Size of the hint text.
  final double? hintSize;

  /// Size of the main input text.
  final double textSize;

  /// Creates an instance of [FieldInputConfig] with optional styling parameters.
  const FieldInputConfig({
    this.labelWeight,
    this.hintWeight,
    this.textWeight,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.labelSize,
    this.hintSize,
    this.textSize = 14,
  });

  /// Returns a copy of this [FieldInputConfig] instance with updated values.
  /// 
  /// If any parameter is not provided, it retains its original value.
  FieldInputConfig copyWith({
    FontWeight? labelWeight,
    FontWeight? hintWeight,
    FontWeight? textWeight,
    Color? labelColor,
    Color? hintColor,
    Color? textColor,
    double? labelSize,
    double? hintSize,
    double? textSize,
  }) {
    return FieldInputConfig(
      labelWeight: labelWeight ?? this.labelWeight,
      hintWeight: hintWeight ?? this.hintWeight,
      textWeight: textWeight ?? this.textWeight,
      labelColor: labelColor ?? this.labelColor,
      hintColor: hintColor ?? this.hintColor,
      textColor: textColor ?? this.textColor,
      labelSize: labelSize ?? this.labelSize,
      hintSize: hintSize ?? this.hintSize,
      textSize: textSize ?? this.textSize,
    );
  }
}