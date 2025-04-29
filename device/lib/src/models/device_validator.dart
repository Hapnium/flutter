class DeviceValidator {
  final bool isValid;
  final String message;

  DeviceValidator({required this.isValid, required this.message});

  factory DeviceValidator.valid() {
    return DeviceValidator(isValid: true, message: "");
  }

  factory DeviceValidator.invalid(String message) {
    return DeviceValidator(isValid: false, message: message);
  }
}