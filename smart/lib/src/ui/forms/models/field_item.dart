import 'package:flutter/widgets.dart';
import 'package:hapnium/hapnium.dart';

import '../../typedefs.dart';

/// Represents a single field within a form.
/// 
/// This class encapsulates the properties of a form field, 
/// such as the controller, hint text, label, input type, 
/// validation logic, and more.
class FieldItem {
  /// The controller that manages the text within the field.
  final TextEditingController? controller;

  /// The hint text displayed within the field.
  final String? hint;

  /// The label displayed above or beside the field.
  final String? label;

  /// The type of keyboard to display for input.
  final TextInputType? type;

  /// A function that validates the input and returns an error message 
  /// if the input is invalid.
  final FieldValidator? validator;

  /// A callback function that is triggered whenever the user changes the text.
  final Consumer<String>? onChanged;

  /// The focus node for the field.
  final FocusNode? focus;

  /// Whether to obscure the text entered in the field (e.g., for passwords).
  final bool obscureText;

  /// Whether to replace the hint text with the label when the field has focus.
  final bool replaceHintWithLabel;

  /// Whether to use a password form field
  final bool isPassword;

  /// The onPressed function to call when the field password visibility button is tapped.
  final VoidCallback? onVisibilityTapped;

  /// Creates a new instance of [FieldItem].
  const FieldItem({
    this.controller,
    this.hint,
    this.label,
    this.type,
    this.validator,
    this.onChanged,
    this.focus,
    this.obscureText = false,
    this.replaceHintWithLabel = false,
    this.isPassword = false,
    this.onVisibilityTapped
  });

  /// Creates a copy of this [FieldItem] with the given fields replaced.
  FieldItem copyWith({
    TextEditingController? controller,
    String? hint,
    String? label,
    TextInputType? type,
    FieldValidator? validator,
    Consumer<String>? onChanged,
    FocusNode? focus,
    bool? obscureText,
    bool? replaceHintWithLabel,
    bool? isPassword,
    VoidCallback? onVisibilityTapped,
  }) {
    return FieldItem(
      controller: controller ?? this.controller,
      hint: hint ?? this.hint,
      label: label ?? this.label,
      type: type ?? this.type,
      validator: validator ?? this.validator,
      onChanged: onChanged ?? this.onChanged,
      focus: focus ?? this.focus,
      obscureText: obscureText ?? this.obscureText,
      replaceHintWithLabel: replaceHintWithLabel ?? this.replaceHintWithLabel,
      isPassword: isPassword ?? this.isPassword,
      onVisibilityTapped: onVisibilityTapped ?? this.onVisibilityTapped,
    );
  }
}