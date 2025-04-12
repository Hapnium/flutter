// Define an enum for data types
import 'dart:convert';

import '../../../../notify.dart';
import 'chat_room.dart';

enum ChatDataType { notification, room }

// Sealed union class
abstract class ChatResponse {
  final ChatDataType dataType;

  ChatResponse(this.dataType);

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("e_pub_key") && json.containsKey("id")) {
      return ChatNotification.fromJson(json);
    } else {
      // Parse room data based on other keys
      return ChatRoom.fromJson(json);
    }
  }

  /// This is a [ChatNotification] data response
  bool get isNotification => dataType == ChatDataType.notification;

  /// [ChatResponse] current type as [ChatNotification]
  ChatNotification get notification => isNotification
      ? this as ChatNotification
      : throw NotifyException("This is not a notification response");

  /// [ChatResponse] current type as [ChatRoom]
  ChatRoom get chatRoom => isRoom
      ? this as ChatRoom
      : throw NotifyException("This is not a room response");

  /// This is a [ChatRoom] data response
  bool get isRoom => dataType == ChatDataType.room;

  /// Foreign identifier
  String get foreign => isNotification ? notification.id : chatRoom.messageId;

  /// Notification summary
  String get summary => isNotification ? notification.summary : chatRoom.summary;

  /// Chat room id
  String get room => isNotification ? notification.room : chatRoom.room;

  /// Roommate name
  String get name => isNotification ? notification.name : chatRoom.name;

  Map<String, dynamic> toJson() => isNotification ? notification.toJson() : chatRoom.toJson();

  @override
  String toString() => jsonEncode(this.toJson());

  ChatResponse fromString(String source) => ChatResponse.fromJson(jsonDecode(source));
}