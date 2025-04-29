import 'package:connectify/connectify.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:universal_io/io.dart';
import 'package:tracing/tracing.dart';

import 'models/device.dart';

/// Provides platform identification utilities.
class DeviceEngine {
  // Private constructor for singleton pattern
  DeviceEngine._();

  // The single instance of the Platform
  static final DeviceEngine _instance = DeviceEngine._();

  /// Access the singleton instance of [DeviceEngine].
  static DeviceEngine get instance => _instance;

  /// Cached values for synchronous access
  String _operatingSystem = "";
  String _operatingSystemVersion = "";
  String _deviceInfo = "";
  String _ipAddress = "";
  Device _device = Device.empty();

  /// Initialize the DeviceEngine (must be called once before accessing properties)
  Future<void> initialize({bool debug = false}) async {
    _ipAddress = await _fetchDeviceIpAddress();
    await _prepareDevice();

    if(debug) {
      console.log("Device Engine Initialized", from: "DeviceEngine");
      console.log("Operating System: $_operatingSystem", from: "DeviceEngine");
      console.log("Operating System Version: $_operatingSystemVersion", from: "DeviceEngine");
      console.log("Device Info: $_deviceInfo", from: "DeviceEngine");
      console.log("IP Address: $_ipAddress", from: "DeviceEngine");
      console.log("Device: ${_device.toJson()}", from: "DeviceEngine");
    }
  }

  Future<String> _fetchDeviceIpAddress() async {
    if(isWeb) {
      return ConnectifyUtils.instance.fetchIpAddress();
    }

    var networks = await NetworkInterface.list();
    if(networks.isNotEmpty) {
      var addresses = networks.first.addresses;
      if(addresses.isNotEmpty) {
        return addresses.first.address;
      }
    }

    return "";
  }

  Future<void> _prepareDevice() async {
    final plugin = DeviceInfoPlugin();

    if (isWeb) {
      final info = await plugin.webBrowserInfo;

      _operatingSystem = "Web ${info.appName}";
      _operatingSystemVersion = info.appVersion ?? info.appCodeName ?? "";
      _deviceInfo = "Web: ${info.userAgent ?? "Unknown"}";

      _device = _device.copyWith(
        id: info.userAgent,
        name: info.browserName.name,
        host: info.appCodeName,
        platform: "Web | ${info.platform}",
        operatingSystem: "${info.appName} | ${info.userAgent}",
        operatingSystemVersion: info.appVersion,
        localHostName: info.appName,
        ipAddress: await _fetchDeviceIpAddress()
      );
    } else if (isAndroid) {
      final info = await plugin.androidInfo;

      _operatingSystem = 'Android ${info.version.release}';
      _operatingSystemVersion = info.version.sdkInt.toString();
      _deviceInfo = _operatingSystem;

      _device = _device.copyWith(
        sdk: info.version.sdkInt,
        id: info.id,
        name: info.model,
        host: info.host,
        platform: "Android",
        operatingSystemVersion: Platform.operatingSystemVersion,
        operatingSystem: Platform.operatingSystem,
        ipAddress: await _fetchDeviceIpAddress(),
        localHostName: Platform.localHostname
      );
    } else if (isIOS) {
      final info = await plugin.iosInfo;

      _operatingSystem = 'iOS ${info.systemVersion}';
      _operatingSystemVersion = info.systemVersion;
      _deviceInfo = _operatingSystem;

      _device = _device.copyWith(
        id: info.identifierForVendor,
        name: info.utsname.machine,
        host: info.utsname.nodename,
        platform: "iOS",
        operatingSystemVersion: Platform.operatingSystemVersion,
        operatingSystem: Platform.operatingSystem,
        ipAddress: await _fetchDeviceIpAddress(),
        localHostName: Platform.localHostname
      );
    } else if (isMacOS) {
      final info = await plugin.macOsInfo;

      _operatingSystem = 'macOS ${info.osRelease}';
      _operatingSystemVersion = info.osRelease;
      _deviceInfo = _operatingSystem;

      _device = _device.copyWith(
        id: info.kernelVersion,
        name: info.model,
        host: info.hostName,
        platform: "MacOs",
        operatingSystemVersion: Platform.operatingSystemVersion,
        operatingSystem: Platform.operatingSystem,
        ipAddress: await _fetchDeviceIpAddress(),
        localHostName: Platform.localHostname
      );
    } else if (isWindows) {
      final info = await plugin.windowsInfo;

      _operatingSystem = 'Windows ${info.releaseId}';
      _operatingSystemVersion = info.releaseId;
      _deviceInfo = _operatingSystem;

      _device = _device.copyWith(
        id: info.deviceId,
        name: info.productName,
        host: info.computerName,
        platform: "Windows",
        operatingSystemVersion: Platform.operatingSystemVersion,
        operatingSystem: Platform.operatingSystem,
        ipAddress: await _fetchDeviceIpAddress(),
        localHostName: Platform.localHostname
      );
    } else if (isLinux) {
      final info = await plugin.linuxInfo;

      _operatingSystem = 'Linux ${info.versionCodename}';
      _operatingSystemVersion = info.versionId ?? "Unknown";
      _deviceInfo = _operatingSystem;

      _device = _device.copyWith(
        id: info.id,
        name: info.prettyName,
        host: info.versionCodename,
        platform: "Linux",
        operatingSystemVersion: Platform.operatingSystemVersion,
        operatingSystem: Platform.operatingSystem,
        ipAddress: await _fetchDeviceIpAddress(),
        localHostName: Platform.localHostname
      );
    } else {
      _operatingSystem = "Unknown OS";
      _operatingSystemVersion = "Unknown Version";
      _deviceInfo = "Unknown Device";
    }
  }

  /// Returns `true` if the application is running on a web platform for `wasm`.
  bool get isWebWasm => kIsWasm;

  /// Returns `true` if the application is running on a web platform.
  bool get isWeb => kIsWeb || isWebWasm;

  /// Returns `true` if the application is running on an Android device.
  bool get isAndroid => !isWeb && Platform.isAndroid;

  /// Returns `true` if the application is running on an iOS device.
  bool get isIOS => !isWeb && Platform.isIOS;

  /// Returns `true` if the application is running on an MacOS device.
  bool get isMacOS => !isWeb && Platform.isMacOS;

  /// Returns `true` if the application is running on an Linux device.
  bool get isLinux => !isWeb && Platform.isLinux;

  /// Returns `true` if the application is running on an Windows device.
  bool get isWindows => !isWeb && Platform.isWindows;

  /// Returns `true` if the application is running on an mobile device.
  bool get isMobile => !isWeb && (isAndroid || isIOS);

  /// Returns `true` if the application is running on an desktop device.
  bool get isDesktop => !isWeb && (isLinux || isMacOS || isWindows);

  /// Gets the operating system name.
  String get operatingSystem => _operatingSystem;

  /// Gets the operating system version.
  String get operatingSystemVersion => _operatingSystemVersion;

  /// Gets basic device information.
  String get deviceInfo => _deviceInfo;

  /// Gets the device ipAddress
  String get ipAddress => _ipAddress;

  /// Gets the device payload
  Device get device => _device;

  /// Show debug
  bool get debug => kDebugMode;

  /// The current platform running this application
  String get platform => isWeb ? "Web" : isAndroid ? "Android" : isIOS ? "iOS" : "Unknown";
}