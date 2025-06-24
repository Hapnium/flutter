import 'dart:convert';

import '../config/utility.dart';

/// {@template remote_notification_android}
/// Represents Android-specific options for a remote notification.
///
/// These options determine how the notification behaves on Android devices,
/// including behavior during direct boot mode (before user unlock).
/// 
/// {@endtemplate}
class RemoteNotificationAndroid {
  /// Whether the notification is allowed during Android's direct boot mode.
  ///
  /// Defaults to `true`. Direct boot mode occurs before the user has unlocked the device
  /// after a reboot. Notifications in this state must meet additional Android requirements.
  final bool directBootOk;

  /// Constructs an instance of [RemoteNotificationAndroid].
  ///
  /// The [directBootOk] flag determines if the notification can be displayed during direct boot.
  /// 
  /// {@macro remote_notification_android}
  const RemoteNotificationAndroid({
    this.directBootOk = true,
  });

  /// Creates an instance from a JSON [Map].
  ///
  /// The key `'direct_boot_ok'` is expected to be a boolean value.
  /// If it's not present, it defaults to `true`.
  /// 
  /// {@macro remote_notification_android}
  factory RemoteNotificationAndroid.fromJson(Map<String, dynamic> json) {
    return RemoteNotificationAndroid(
      directBootOk: json['direct_boot_ok'] ?? true,
    );
  }

  /// Converts this object to a JSON-compatible [Map].
  /// 
  /// {@macro remote_notification_android}
  Map<String, dynamic> toJson() {
    return {
      'direct_boot_ok': directBootOk,
    };
  }

  /// Returns a copy of this instance with optional modifications.
  /// 
  /// {@macro remote_notification_android}
  RemoteNotificationAndroid copyWith({
    bool? directBootOk,
  }) {
    return RemoteNotificationAndroid(
      directBootOk: directBootOk ?? this.directBootOk,
    );
  }
}

/// {@template remote_notification_message}
/// Represents a generic remote notification message with platform-specific options.
///
/// This class allows flexible typing of the notification's payload data through [T],
/// while also encapsulating Android-specific configuration via [RemoteNotificationAndroid].
///
/// Type parameter:
/// - [T]: The type of the notification's data payload (e.g., `Map<String, dynamic>`, `String`, or a custom model).
/// 
/// {@endtemplate}
class RemoteNotificationMessage<T> {
  /// The actual data payload of the notification.
  final T data;

  /// Android-specific options related to the notification's behavior.
  final RemoteNotificationAndroid android;

  /// Constructs a [RemoteNotificationMessage] instance.
  ///
  /// The [data] is required and represents the core content of the message.
  /// The optional [android] parameter provides Android-specific settings.
  /// 
  /// {@macro remote_notification_message}
  RemoteNotificationMessage({
    required this.data,
    RemoteNotificationAndroid? android,
  }) : android = android ?? RemoteNotificationAndroid();

  /// Creates an instance from a JSON [Map].
  ///
  /// Expects the map to contain:
  /// - `"data"`: The data payload (must match type [T] when deserialized externally).
  /// - `"android"`: (Optional) Android-specific settings.
  /// 
  /// {@macro remote_notification_message}
  factory RemoteNotificationMessage.fromJson(Map<String, dynamic> json) {
    return RemoteNotificationMessage(
      data: json["data"],
      android: json['android'] != null
          ? RemoteNotificationAndroid.fromJson(json['android'])
          : RemoteNotificationAndroid(),
    );
  }

  /// Converts this object to a JSON-compatible [Map].
  /// 
  /// {@macro remote_notification_message}
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'android': android.toJson(),
    };
  }

  /// Returns a copy of this instance with optional modifications.
  /// 
  /// {@macro remote_notification_message}
  RemoteNotificationMessage<T> copyWith({
    T? data,
    RemoteNotificationAndroid? android,
  }) {
    return RemoteNotificationMessage(
      data: data ?? this.data,
      android: android ?? this.android,
    );
  }
}

/// {@template remote_notification}
/// Represents a remote notification payload received from a push notification service.
///
/// This class is designed to be generic with a flexible `data` payload of type [T],
/// and supports additional metadata such as sender information, notification type, image, etc.
/// 
/// {@endtemplate}
class RemoteNotification<T> {
  /// Title of the notification.
  final String title;

  /// Body text of the notification.
  final String body;

  /// Token associated with the device or recipient of the notification.
  final String token;

  /// Optional image URL included in the notification.
  final String? image;

  /// Payload data associated with the notification.
  ///
  /// This can be any type (e.g. `Map<String, dynamic>`, custom object, etc.).
  final T? data;

  /// Notification type identifier or source, often used to route logic (e.g. "chat", "call").
  final String snt;

  /// Identifier for the sender of the notification.
  final String sender;

  /// Constructs a [RemoteNotification] instance with optional data and image.
  /// 
  /// {@macro remote_notification}
  const RemoteNotification({
    this.title = "",
    this.body = "",
    this.image,
    this.data,
    required this.snt,
    this.sender = "",
    required this.token,
  });

  /// Creates a [RemoteNotification] from a JSON [Map].
  ///
  /// The `data` field is decoded using a custom [Utility.instance.decodeToJson] method.
  /// 
  /// {@macro remote_notification}
  factory RemoteNotification.fromJson(Map<String, dynamic> json) {
    return RemoteNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: Utility.instance.decodeToJson(json['data']),
      snt: json['snt'] ?? '',
      sender: json['sender'] ?? '',
      token: json['token'] ?? '',
    );
  }

  /// Creates a [RemoteNotification] from JSON and a provided token.
  ///
  /// Used when the token is not embedded within the JSON but obtained externally.
  /// Attempts to decode the `data` field from a JSON string if needed.
  /// 
  /// {@macro remote_notification}
  factory RemoteNotification.fromJsonWithToken(Map<String, dynamic> json, String token) {
    dynamic data = json['data'];
    try {
      if (data != null) {
        data = jsonDecode(data);
      }
    } catch (_) {
      // Fallback: keep data as-is if not a valid JSON string
    }

    return RemoteNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: data,
      snt: json['snt'] ?? '',
      sender: json['sender'] ?? '',
      token: token,
    );
  }

  /// Returns an empty notification with all fields initialized to default values.
  /// 
  /// {@macro remote_notification}
  factory RemoteNotification.empty() {
    return const RemoteNotification(
      title: '',
      body: '',
      image: '',
      data: null,
      snt: '',
      sender: '',
      token: '',
    );
  }

  /// Converts this object to a JSON-compatible [Map].
  /// 
  /// {@macro remote_notification}
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'data': data != null ? jsonEncode(data) : null,
      'snt': snt,
      'sender': sender,
      'token': token,
    };
  }

  /// Returns a new instance of this notification with modified fields.
  /// 
  /// {@macro remote_notification}
  RemoteNotification<T> copyWith({
    String? title,
    String? body,
    String? image,
    T? data,
    String? snt,
    String? sender,
    String? token,
  }) {
    return RemoteNotification(
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      data: data ?? this.data,
      snt: snt ?? this.snt,
      sender: sender ?? this.sender,
      token: token ?? this.token,
    );
  }
}