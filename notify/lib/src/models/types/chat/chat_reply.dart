class ChatReply {
  ChatReply({
    required this.id,
    required this.label,
    required this.message,
    required this.status,
    required this.fileSize,
    required this.type,
    required this.sender,
    required this.duration,
    required this.isSentByCurrentUser
  });

  final String id;
  final String label;
  final String message;
  final String status;
  final String fileSize;
  final String type;
  final String sender;
  final String duration;
  final bool isSentByCurrentUser;

  ChatReply copyWith({
    String? id,
    String? label,
    String? message,
    String? status,
    String? fileSize,
    String? duration,
    String? type,
    String? sender,
    bool? isSentByCurrentUser,
  }) {
    return ChatReply(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      status: status ?? this.status,
      fileSize: fileSize ?? this.fileSize,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isSentByCurrentUser: isSentByCurrentUser ?? this.isSentByCurrentUser,
    );
  }

  factory ChatReply.fromJson(Map<String, dynamic> json) {
    return ChatReply(
      id: json["id"] ?? "",
      label: json["label"] ?? "",
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      fileSize: json["file_size"] ?? "",
      type: json["type"] ?? "",
      sender: json["sender"] ?? "",
      duration: json["duration"] ?? "",
      isSentByCurrentUser: json["is_sent_by_current_user"] ?? false
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "message": message,
    "status": status,
    "file_size": fileSize,
    "type": type,
    "duration": duration,
    "sender": sender,
    "is_sent_by_current_user": isSentByCurrentUser
  };
}