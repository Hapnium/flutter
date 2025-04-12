import 'remote_notification_android.dart';

class RemoteNotificationMessage<T> {
  final T data;
  final RemoteNotificationAndroid android;

  RemoteNotificationMessage({
    required this.data,
    RemoteNotificationAndroid? android,
  }) : android = android ?? RemoteNotificationAndroid();

  factory RemoteNotificationMessage.fromJson(Map<String, dynamic> json) {
    return RemoteNotificationMessage(
      data: json["data"],
      android: json['android'] != null ? RemoteNotificationAndroid.fromJson(json['android']) : RemoteNotificationAndroid(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': this.data,
      'android': this.android.toJson(),
    };
  }

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