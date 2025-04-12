import 'dart:convert';

import '../../utilities/utility.dart';

class RemoteNotification<T> {
  final String title;
  final String body;
  final String token;
  final String? image;
  final T? data;
  final String snt;
  final String sender;

  RemoteNotification({
    this.title = "",
    this.body = "",
    this.image,
    this.data,
    required this.snt,
    this.sender = "",
    required this.token,
  });

  factory RemoteNotification.fromJson(Map<String, dynamic> json) {
    return RemoteNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: Utility.instance.decodeToJson(json['data']),
      snt: json['snt'] ?? '',
      sender: json['sender'] ?? "",
      token: json['token'] ?? "",
    );
  }

  factory RemoteNotification.fromJsonWithToken(Map<String, dynamic> json, String token) {
    dynamic data = json['data'];
    try {
      if(data != null) {
        data = jsonDecode(data);
      }
    } catch (_) { }

    return RemoteNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: data,
      snt: json['snt'] ?? '',
      sender: json['sender'] ?? "",
      token: token,
    );
  }

  factory RemoteNotification.empty() {
    return RemoteNotification(
      title: '',
      body: '',
      image: '',
      data: null,
      snt: '',
      sender: '',
      token: ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'data': data != null ? jsonEncode(data) : null,
      'snt': snt,
      'sender': sender,
      'token': this.token,
    };
  }

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