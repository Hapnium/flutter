import '../models/device_validator.dart';

/// An abstract class representing a service for validating the state and authenticity of a device.
///
/// This service provides methods to check for various conditions that may indicate
/// potential security risks or tampering with the device.
abstract class DeviceValidatorService {
  /// Checks if the device is jail broken (for iOS) or rooted (for Android).
  ///
  /// Returns a [Future] that completes with a [DeviceValidator] object.
  /// The `isValid` property of the object will be `false` if the device
  /// is jail broken/rooted, and `true` otherwise.
  ///
  /// If any errors occur during the check, the `error` property of
  /// the [DeviceValidator] object will be populated with an error message.
  Future<DeviceValidator> isJailBroken();

  /// Checks if the application is running on a real physical device.
  ///
  /// Returns a [Future] that completes with a [DeviceValidator] object.
  /// The `isValid` property of the object will be `false` if the device
  /// is an emulator or simulator, and `true` otherwise.
  ///
  /// If any errors occur during the check, the `error` property of
  /// the [DeviceValidator] object will be populated with an error message.
  Future<DeviceValidator> isRealDevice();

  /// Checks if the device is in developer mode.
  ///
  /// Returns a [Future] that completes with a [DeviceValidator] object.
  /// The `isValid` property of the object will be `false` if developer mode
  /// is enabled on the device, and `true` otherwise.
  ///
  /// If any errors occur during the check, the `error` property of
  /// the [DeviceValidator] object will be populated with an error message.
  Future<DeviceValidator> isDeveloperMode();

  /// Checks if the device's location is being mocked.
  ///
  /// Returns a [Future] that completes with a [DeviceValidator] object.
  /// The `isValid` property of the object will be `false` if the device
  /// is reporting a mocked location, and `true` otherwise.
  ///
  /// If any errors occur during the check, the `error` property of
  /// the [DeviceValidator] object will be populated with an error message.
  Future<DeviceValidator> isMockedLocation();
}