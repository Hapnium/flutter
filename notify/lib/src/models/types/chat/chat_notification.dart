import 'dart:convert';

import 'chat_response.dart';

class ChatNotification extends ChatResponse {
  final String roommate;
  final String id;
  final String room;
  final String snt;
  final String image;
  final String category;
  final String summary;
  final String ePubKey;
  final String name;

  ChatNotification({
    required this.roommate,
    required this.id,
    required this.room,
    required this.snt,
    required this.image,
    required this.category,
    required this.summary,
    required this.ePubKey,
    required this.name
  }) : super(ChatDataType.notification);

  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    return ChatNotification(
      roommate: json['roommate'] ?? '',
      id: json['id'] ?? '',
      room: json['room'] ?? '',
      snt: json['snt'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      summary: json['summary'] ?? '',
      ePubKey: json['e_pub_key'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'roommate': roommate,
      'id': id,
      'room': room,
      'snt': snt,
      'image': image,
      'category': category,
      'summary': summary,
      'e_pub_key': ePubKey,
      'name': name,
    };
  }

  ChatNotification copyWith({
    String? roommate,
    String? id,
    String? room,
    String? snt,
    String? image,
    String? category,
    String? summary,
    String? ePubKey,
    String? name,
  }) {
    return ChatNotification(
      roommate: roommate ?? this.roommate,
      id: id ?? this.id,
      room: room ?? this.room,
      snt: snt ?? this.snt,
      image: image ?? this.image,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      ePubKey: ePubKey ?? this.ePubKey,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => jsonEncode(this.toJson());

  @override
  ChatNotification fromString(String source) => ChatNotification.fromJson(jsonDecode(source));
}