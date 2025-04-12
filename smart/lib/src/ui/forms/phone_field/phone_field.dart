import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/src/utilities/country/country_data.dart';
import 'package:smart/utilities.dart';

import '../../export.dart';

part 'phone_field_state.dart';

/// A customizable phone input field with country selection.
/// 
/// This widget provides a user-friendly input field for entering phone numbers 
/// with integrated country selection functionality. It offers a high degree of 
/// customization through various parameters, allowing developers to tailor its 
/// appearance and behavior to specific needs.
class PhoneField extends StatefulWidget {
  /// Called when the phone number is saved.
  /// 
  /// This callback is typically invoked when the form containing the 
  /// `PhoneField` is submitted or validated. 
  final FormFieldSetter<PhoneNumber>? onSaved;

  /// Called when the phone number entered in the field changes.
  /// 
  /// This callback is invoked whenever the user enters or modifies 
  /// the phone number in the field. 
  final ValueChanged<PhoneNumber>? onChanged;

  /// Called when the selected country changes.
  /// 
  /// This callback is invoked when the user selects a different 
  /// country from the country selection dropdown or list.
  final SelectedCountryChanged? onCountryChanged;

  /// Called when the country selection button is clicked.
  /// 
  /// This callback provides a function (`onChanged`) that should be 
  /// used to update the selected country within the country selection 
  /// dialog or component.
  final Function(SelectedCountryChanged onChanged)? onChangeCountryClicked;

  /// A custom builder function for the flag widget.
  /// 
  /// This allows developers to customize the appearance of the 
  /// country flag displayed next to the phone number input.
  final PhoneFlagBuilder? flagBuilder;

  /// A custom builder function for the phone number input field itself.
  /// 
  /// This allows for advanced customization of the phone number 
  /// input field's appearance and behavior.
  final PhoneFieldBuilder? phoneBuilder;

  /// Validates the entered phone number.
  /// 
  /// This function is used to validate the phone number 
  /// based on the selected country's rules.
  final PhoneNumberValidator? validator;

  /// Controls the text input of the phone field.
  final TextEditingController? controller;

  /// Manages the focus of the phone field.
  final FocusNode? focusNode;

  /// Whether to disable length validation of the phone number.
  /// 
  /// If set to `true`, the phone number's length will not be 
  /// validated against the country's minimum and maximum length 
  /// requirements.
  final bool disableLengthCheck;

  /// Placeholder text for the phone input field.
  final String? hint;

  /// Error message displayed when the phone number is invalid.
  final String? phoneNumberErrorMessage;

  /// Defines the text input action (e.g., next, done).
  final TextInputAction? textInputAction;

  /// Constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// Builds a custom input decoration.
  /// 
  /// This function allows for advanced customization of the 
  /// input decoration of the phone field.
  final FieldDecorationConfigBuilder? inputDecorationBuilder;

  /// Builds a custom input configuration.
  /// 
  /// This function allows for advanced customization of the 
  /// input configuration of the phone field.
  final FieldInputConfigBuilder? inputConfigBuilder;

  /// A list of countries available for selection.
  /// 
  /// If not provided, a default list of countries will be used.
  final List<Country>? countries;

  /// Widget displayed as a suffix icon.
  final Widget? suffixIcon;

  /// Decoration for the flag button.
  final BoxDecoration? flagButtonDecoration;

  /// Padding for the flag button.
  final EdgeInsetsGeometry? flagButtonPadding;

  /// Background color of the flag button.
  final Color? flagButtonColor;

  /// Padding inside the flag button box.
  final EdgeInsetsGeometry? flagButtonBoxPadding;

  /// Padding inside the flag button body.
  final EdgeInsetsGeometry? flagButtonBodyPadding;

  /// Whether to use flag emojis instead of images.
  final Boolean useFlagEmoji;

  /// Size of the flag.
  final double? flagSize;

  /// Spacing between the flag and dial code.
  final double? flagSpacing;

  /// Text size of the dial code.
  final double? flagTextSize;

  /// Color of the dial code text.
  final Color? flagTextColor;

  /// Alignment of the flag button contents.
  final MainAxisAlignment? flagMainAxisAlignment;

  /// Size behavior of the flag button.
  final MainAxisSize? flagMainAxisSize;

  /// Cross-axis alignment of the flag button contents.
  final CrossAxisAlignment? flagCrossAxisAlignment;

  /// The default country, identified by code, ISO, dial code, or name.
  final String? country;

  const PhoneField({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onCountryChanged,
    this.onSaved,
    this.textInputAction,
    this.disableLengthCheck = false,
    this.phoneNumberErrorMessage = 'Invalid Mobile Number',
    this.suffixIconConstraints,
    this.suffixIcon,
    this.country,
    this.onChangeCountryClicked,
    this.flagBuilder,
    this.phoneBuilder,
    this.hint,
    this.inputDecorationBuilder,
    this.inputConfigBuilder,
    this.countries,
    this.flagButtonDecoration,
    this.flagButtonPadding,
    this.flagButtonColor,
    this.flagButtonBoxPadding,
    this.flagButtonBodyPadding,
    this.useFlagEmoji = true,
    this.flagSize,
    this.flagSpacing,
    this.flagTextSize,
    this.flagTextColor,
    this.flagMainAxisAlignment,
    this.flagMainAxisSize,
    this.flagCrossAxisAlignment
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}