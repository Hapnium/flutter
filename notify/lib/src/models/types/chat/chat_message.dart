import 'chat_reply.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.label,
    required this.room,
    required this.message,
    required this.status,
    required this.type,
    required this.duration,
    required this.reply,
    required this.fileSize,
    required this.isSentByCurrentUser,
    required this.sentAt,
    required this.name,
  });

  final String id;
  final String label;
  final String room;
  final String message;
  final String status;
  final String type;
  final String duration;
  final ChatReply? reply;
  final String fileSize;
  final bool isSentByCurrentUser;
  final DateTime sentAt;
  final String name;

  ChatMessage copyWith({
    String? id,
    String? label,
    String? room,
    String? message,
    String? status,
    String? type,
    String? duration,
    ChatReply? reply,
    String? fileSize,
    bool? isSentByCurrentUser,
    DateTime? sentAt,
    String? name,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      label: label ?? this.label,
      room: room ?? this.room,
      message: message ?? this.message,
      status: status ?? this.status,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      reply: reply ?? this.reply,
      fileSize: fileSize ?? this.fileSize,
      isSentByCurrentUser: isSentByCurrentUser ?? this.isSentByCurrentUser,
      sentAt: sentAt ?? this.sentAt,
      name: name ?? this.name,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["id"] ?? "",
      label: json["label"] ?? "",
      room: json["room"] ?? "",
      message: json['message'] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      type: json["type"] ?? "",
      duration: json["duration"] ?? "",
      reply: json["reply"] == null ? null : ChatReply.fromJson(json["reply"]),
      fileSize: json["file_size"] ?? "",
      isSentByCurrentUser: json["is_sent_by_current_user"] ?? false,
      sentAt: DateTime.tryParse(json["sent_at"] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "room": room,
    "message": message,
    "name": name,
    "status": status,
    "type": type,
    "duration": duration,
    "reply": reply?.toJson(),
    "file_size": fileSize,
    "is_sent_by_current_user": isSentByCurrentUser,
    "sent_at": sentAt.toIso8601String(),
  };
}