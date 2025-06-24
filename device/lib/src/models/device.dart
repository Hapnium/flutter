import 'package:hapnium/hapnium.dart';

/// {@template device}
/// A model class that holds structured information about the current device,
/// including platform, identifiers, IP address, and OS details.
///
/// This class can be serialized to and from JSON, copied with new values,
/// and used across platforms to standardize device data.
///
/// ### Example usage:
/// ```dart
/// final device = Device(
///   name: "iPhone 14",
///   id: "ABCD1234",
///   ipAddress: "192.168.0.101",
///   platform: "iOS",
///   sdk: 17,
///   host: "device-host",
///   operatingSystem: "iOS",
///   operatingSystemVersion: "17.0",
///   localHostName: "iPhone-14.local",
/// );
///
/// print(device.toJson());
/// ```
/// {@endtemplate}
class Device {
  /// The device name or model.
  ///
  /// Default: `null` (required)
  final String name;

  /// Unique device identifier.
  ///
  /// Default: `null` (required)
  final String id;

  /// Device's local or public IP address.
  ///
  /// Default: `null` (required)
  final String ipAddress;

  /// Platform the device is running on (e.g., Android, iOS, Web).
  ///
  /// Default: `null` (required)
  final String platform;

  /// Software Development Kit (SDK) version.
  ///
  /// Default: `0`
  final Integer sdk;

  /// Host name or machine name of the device.
  ///
  /// Default: `null` (required)
  final String host;

  /// Name of the operating system (e.g., "Android", "iOS").
  ///
  /// Default: `null` (required)
  final String operatingSystem;

  /// Operating system version (e.g., "13.3.1").
  ///
  /// Default: `null` (required)
  final String operatingSystemVersion;

  /// Local hostname assigned to the device.
  ///
  /// Default: `null` (required)
  final String localHostName;

  /// {@macro device}
  Device({
    required this.name,
    required this.id,
    required this.ipAddress,
    required this.platform,
    this.sdk = 0,
    required this.host,
    required this.operatingSystem,
    required this.operatingSystemVersion,
    required this.localHostName,
  });

  /// Creates a copy of this [Device] instance with overridden values.
  /// 
  /// {@macro device}
  Device copyWith({
    String? name,
    String? id,
    String? ipAddress,
    String? platform,
    Integer? sdk,
    String? host,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostName,
  }) {
    return Device(
      name: name ?? this.name,
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      platform: platform ?? this.platform,
      sdk: sdk ?? this.sdk,
      host: host ?? this.host,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      operatingSystemVersion: operatingSystemVersion ?? this.operatingSystemVersion,
      localHostName: localHostName ?? this.localHostName,
    );
  }

  /// Returns an empty [Device] instance with default values.
  /// 
  /// {@macro device}
  factory Device.empty() {
    return Device(
      name: "",
      id: "",
      ipAddress: "",
      platform: "",
      sdk: 0,
      host: "",
      operatingSystem: "",
      operatingSystemVersion: "",
      localHostName: ""
    );
  }

  /// Creates a [Device] instance from a JSON map.
  /// 
  /// {@macro device}
  factory Device.fromJson(JsonMap json) {
    return Device(
      name: json["name"] ?? "",
      id: json["id"] ?? "",
      ipAddress: json["ip_address"] ?? "",
      platform: json["platform"] ?? "",
      sdk: json["sdk"] ?? 0,
      host: json["host"] ?? "",
      operatingSystem: json["operating_system"] ?? "",
      operatingSystemVersion: json["operating_system_version"] ?? "",
      localHostName: json["local_host_name"] ?? "",
    );
  }

  /// Converts the [Device] instance to a JSON map.
  JsonMap toJson() => {
    "name": name,
    "id": id,
    "ip_address": ipAddress,
    "platform": platform,
    "sdk": sdk,
    "host": host,
    "operating_system": operatingSystem,
    "operating_system_version": operatingSystemVersion,
    "local_host_name": localHostName,
  };
}