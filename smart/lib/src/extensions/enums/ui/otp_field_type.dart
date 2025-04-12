import '../../../enums/ui/otp_field_type.dart';

/// Provides convenience checks for [OtpFieldType].
///
/// This extension provides methods to check the type of a `OtpFieldType` enum value.
///
/// Example:
/// ```dart
/// if (OtpFieldType.isBox) {
///   print("The current otp field type is the box design.");
/// }
/// ```
extension OtpFieldTypeExtension on OtpFieldType {
  /// Returns `true` if the `OtpFieldType` value is set to [OtpFieldType.box].
  bool get isBox => this == OtpFieldType.box;

  /// Returns `true` if the `OtpFieldType` value is set to [OtpFieldType.filled].
  bool get isFilled => this == OtpFieldType.filled;

  /// Returns `true` if the `OtpFieldType` value is set to [OtpFieldType.bottom].
  bool get isBottom => this == OtpFieldType.bottom;
}