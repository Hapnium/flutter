import '../device_engine.dart';
import '../models/device_validator.dart';

/// Handles core validation logic for device checks based on provided values.
abstract class BaseDeviceValidator {
  DeviceValidator checkRootedOrJailBroken(bool isRooted) {
    if (DeviceEngine.instance.isWeb) return DeviceValidator.valid();

    if (isRooted) {
      return DeviceValidator.invalid([
        "Your device appears to be jail broken or rooted.",
        "This indicates that restrictions imposed by the manufacturer or operating system have been bypassed.",
        "Such modifications compromise the device's security, exposing it to potential malware and attacks.",
        "For security reasons, this application does not allow its use on modified devices."
      ].join(" "));
    }
    return DeviceValidator.valid();
  }

  DeviceValidator checkDeveloperMode(bool isEnabled) {
    if (DeviceEngine.instance.isWeb) return DeviceValidator.valid();

    if (isEnabled) {
      return DeviceValidator.invalid([
        "Developer mode is currently enabled on your device, which may expose it to vulnerabilities.",
        "Please disable developer mode to proceed."
      ].join(" "));
    }
    return DeviceValidator.valid();
  }

  DeviceValidator checkMockLocation(bool isMocked) {
    if (DeviceEngine.instance.isWeb) return DeviceValidator.valid();

    if (isMocked) {
      return DeviceValidator.invalid([
        "Your device seems to be using mock locations.",
        "This feature can compromise the integrity of location-based services.",
        "Please disable mock location to continue."
      ].join(" "));
    }
    return DeviceValidator.valid();
  }

  DeviceValidator checkRealDevice(bool isReal) {
    if (DeviceEngine.instance.isWeb) return DeviceValidator.valid();

    if (!isReal) {
      return DeviceValidator.invalid([
        "It seems like you're using an emulator or virtual device.",
        "This application requires a real physical device for full functionality.",
        "Please switch to a compatible device."
      ].join(" "));
    }
    return DeviceValidator.valid();
  }
}