import 'package:flutter/material.dart';

/// Configuration class for customizing text field appearance and behavior.
///
/// The [FieldDecorationConfig] class allows customization of borders, border radii, and other  
/// styling properties used in text field decorations.
///
/// ## Example Usage:
/// ```dart
/// FieldConfig config = FieldConfig(
///   borderRadius: 8.0,
///   focusedBorderSide: BorderSide(color: Colors.blue, width: 2),
/// );
///
/// FieldConfig updatedConfig = config.copyWith(
///   errorBorderSide: BorderSide(color: Colors.red, width: 2),
/// );
/// ```
class FieldDecorationConfig {
  /// Determines whether the field should use the "not enabled" state.
  final bool useNotEnabled;

  /// The border radius of the text field.
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The numeric value for the border radius.
  final double? borderRadius;

  /// The border style when the field is enabled.
  final BorderSide? enabledBorderSide;

  /// The border style when the field is disabled.
  final BorderSide? disabledBorderSide;

  /// The border style when the field is focused.
  final BorderSide? focusedBorderSide;

  /// The border style when the field has an error.
  final BorderSide? errorBorderSide;

  /// The border style when the field is both focused and has an error.
  final BorderSide? focusedErrorBorderSide;

  /// The default border style for the field.
  final BorderSide? inputBorderSide;

  /// The input border when the field is enabled.
  final InputBorder? enabledBorder;

  /// The input border when the field is disabled.
  final InputBorder? disabledBorder;

  /// The input border when the field is focused.
  final InputBorder? focusedBorder;

  /// The input border when the field has an error.
  final InputBorder? errorBorder;

  /// The input border when the field is both focused and has an error.
  final InputBorder? focusedErrorBorder;

  /// The default input border.
  final InputBorder? inputBorder;

  /// Creates a new instance of [FieldDecorationConfig] with customizable field decoration properties.
  const FieldDecorationConfig({
    this.useNotEnabled = false,
    this.borderRadiusGeometry,
    this.borderRadius,
    this.enabledBorderSide,
    this.disabledBorderSide,
    this.focusedBorderSide,
    this.errorBorderSide,
    this.focusedErrorBorderSide,
    this.inputBorderSide,
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.inputBorder,
  });

  /// Creates a copy of this [FieldDecorationConfig] with modified properties.
  ///
  /// If a parameter is `null`, the current value will be retained.
  FieldDecorationConfig copyWith({
    bool? useNotEnabled,
    BorderRadiusGeometry? borderRadiusGeometry,
    double? borderRadius,
    BorderSide? enabledBorderSide,
    BorderSide? disabledBorderSide,
    BorderSide? focusedBorderSide,
    BorderSide? errorBorderSide,
    BorderSide? focusedErrorBorderSide,
    BorderSide? inputBorderSide,
    InputBorder? enabledBorder,
    InputBorder? disabledBorder,
    InputBorder? focusedBorder,
    InputBorder? errorBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? inputBorder,
  }) {
    return FieldDecorationConfig(
      useNotEnabled: useNotEnabled ?? this.useNotEnabled,
      borderRadiusGeometry: borderRadiusGeometry ?? this.borderRadiusGeometry,
      borderRadius: borderRadius ?? this.borderRadius,
      enabledBorderSide: enabledBorderSide ?? this.enabledBorderSide,
      disabledBorderSide: disabledBorderSide ?? this.disabledBorderSide,
      focusedBorderSide: focusedBorderSide ?? this.focusedBorderSide,
      errorBorderSide: errorBorderSide ?? this.errorBorderSide,
      focusedErrorBorderSide: focusedErrorBorderSide ?? this.focusedErrorBorderSide,
      inputBorderSide: inputBorderSide ?? this.inputBorderSide,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      focusedErrorBorder: focusedErrorBorder ?? this.focusedErrorBorder,
      inputBorder: inputBorder ?? this.inputBorder,
    );
  }
}