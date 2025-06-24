/// {@template device_validator}
/// A utility class that represents the result of device validation. 
/// It holds whether the validation was successful and includes a message 
/// in case of failure.
///
/// This is useful when validating device-specific constraints, and it provides 
/// factory constructors for quickly constructing valid or invalid responses.
///
/// ### Example usage:
/// ```dart
/// final result = someDeviceIsAllowed
///   ? DeviceValidator.valid()
///   : DeviceValidator.invalid("Unsupported device.");
///
/// if (!result.isValid) {
///   print(result.message);
/// }
/// ```
/// {@endtemplate}
class DeviceValidator {
  /// Whether the validation result is valid.
  ///
  /// Default: `null` (required)
  final bool isValid;

  /// Message to be used when validation fails.
  ///
  /// Default: `null` (required)
  final String message;

  /// {@macro device_validator}
  DeviceValidator({required this.isValid, required this.message});

  /// Creates a [DeviceValidator] instance that represents a valid state.
  factory DeviceValidator.valid() {
    return DeviceValidator(isValid: true, message: "");
  }

  /// Creates a [DeviceValidator] instance that represents an invalid state with a custom [message].
  factory DeviceValidator.invalid(String message) {
    return DeviceValidator(isValid: false, message: message);
  }
}