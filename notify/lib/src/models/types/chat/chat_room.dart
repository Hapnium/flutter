import 'dart:convert';

import 'package:notify/notify.dart';

import 'chat_group_message.dart';

class ChatRoom extends ChatResponse {
  ChatRoom({
    required this.room,
    required this.roommate,
    required this.name,
    required this.avatar,
    required this.category,
    required this.image,
    required this.label,
    required this.message,
    required this.messageId,
    required this.status,
    required this.count,
    required this.groups,
    required this.lastSeen,
    required this.sentAt,
    required this.isBookmarked,
    required this.bookmark,
    required this.schedule,
    required this.isActive,
    required this.trip,
    this.isBookmarking = false,
    required this.total,
    required this.publicEncryptionKey,
    required this.type,
    required this.summary
  }) : super(ChatDataType.room);

  final String room;
  final String roommate;
  final String name;
  final String avatar;
  final String category;
  final String image;
  final String label;
  final String message;
  final String messageId;
  final String status;
  final int count;
  final List<ChatGroupMessage> groups;
  final String lastSeen;
  final DateTime sentAt;
  final bool isBookmarked;
  final String bookmark;
  final ScheduleNotification? schedule;
  final bool isActive;
  final String trip;
  final bool isBookmarking;
  final int total;
  final String publicEncryptionKey;
  final String type;
  final String summary;

  ChatRoom copyWith({
    String? room,
    String? roommate,
    String? name,
    String? avatar,
    String? category,
    String? image,
    String? label,
    String? message,
    String? messageId,
    String? status,
    int? count,
    List<ChatGroupMessage>? groups,
    String? lastSeen,
    DateTime? sentAt,
    bool? isBookmarked,
    String? bookmark,
    ScheduleNotification? schedule,
    bool? isActive,
    String? trip,
    bool? isBookmarking,
    int? total,
    String? publicEncryptionKey,
    String? type,
    String? summary
  }) {
    return ChatRoom(
      room: room ?? this.room,
      roommate: roommate ?? this.roommate,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      category: category ?? this.category,
      image: image ?? this.image,
      label: label ?? this.label,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      status: status ?? this.status,
      count: count ?? this.count,
      groups: groups ?? this.groups,
      lastSeen: lastSeen ?? this.lastSeen,
      sentAt: sentAt ?? this.sentAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      bookmark: bookmark ?? this.bookmark,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
      trip: trip ?? this.trip,
      isBookmarking: isBookmarking ?? this.isBookmarking,
      total: total ?? this.total,
      publicEncryptionKey: publicEncryptionKey ?? this.publicEncryptionKey,
      type: type ?? this.type,
      summary: summary ?? this.summary
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      room: json["room"] ?? "",
      roommate: json["roommate"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      label: json["label"] ?? "",
      message: json["message"] ?? "",
      messageId: json["message_id"] ?? "",
      status: json["status"] ?? "",
      bookmark: json["bookmark"] ?? "",
      schedule: json["schedule"] != null ? ScheduleNotification.fromJson(json["schedule"]) : null,
      count: json["count"] ?? 0,
      groups: json["groups"] == null
          ? []
          : List<ChatGroupMessage>.from(json["groups"]!.map((x) => ChatGroupMessage.fromJson(x))),
      lastSeen: json["last_seen"] ?? "",
      sentAt: DateTime.tryParse(json["sent_at"] ?? "") ?? DateTime.now(),
      isBookmarked: json["is_bookmarked"] ?? false,
      isActive: json["is_active"] ?? false,
      trip: json["trip"] ?? "",
      isBookmarking: json["is_bookmarking"] ?? false,
      total: json["total"] ?? 0,
      publicEncryptionKey: json["public_encryption_key"] ?? "",
      type: json["type"] ?? "",
      summary: json["summary"] ?? ""
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "room": room,
    "roommate": roommate,
    "name": name,
    "avatar": avatar,
    "category": category,
    "image": image,
    "label": label,
    "message": message,
    "message_id": messageId,
    "bookmark": bookmark,
    "schedule": schedule?.toJson(),
    "status": status,
    "count": count,
    "groups": groups.map((x) => x.toJson()).toList(),
    "last_seen": lastSeen,
    "sent_at": sentAt.toIso8601String(),
    "is_bookmarked": isBookmarked,
    "is_active": isActive,
    "trip": trip,
    "is_bookmarking": isBookmarking,
    "total": total,
    "public_encryption_key": publicEncryptionKey,
    "type": type,
    "summary": summary
  };

  @override
  String toString() => jsonEncode(this.toJson());

  @override
  ChatRoom fromString(String source) => ChatRoom.fromJson(jsonDecode(source));
}