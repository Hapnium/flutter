import 'dart:convert';

import '../definitions.dart';
import '../enums/socket_type.dart';

/// Represents a generic message passed through the socket connection.
///
/// This model is used to encode and decode JSON socket payloads in a single,
/// unified structure that can be extended as needed.
class SocketMessenger {
  /// The type of the socket message (e.g., connect, send, receive, ping, etc.).
  final SocketType type;

  /// A unique or descriptive event name, typically used for routing (e.g., 'chat:new', 'user:status').
  final String? event;

  /// The actual payload of the message.
  ///
  /// This can be a nested object or map and is stored as dynamic for flexibility.
  final dynamic data;

  /// An optional identifier for tracking or matching responses.
  final String? messageId;

  /// The timestamp when the message was created (server or client time).
  final DateTime? timestamp;

  /// The endpoint to which the message is being sent.
  final String? endpoint;

  /// The headers associated with the message.
  final Headers? headers;

  /// The topic associated with the message.
  final String? topic;

  SocketMessenger({
    required this.type,
    this.event,
    this.data,
    this.messageId,
    this.timestamp,
    this.endpoint,
    this.headers,
    this.topic,
  });

  /// Creates a `SocketMessenger` instance from a JSON map.
  factory SocketMessenger.fromJson(Map<String, dynamic> json) {
    return SocketMessenger(
      type: json['type'] ?? '',
      event: json['event'] ?? '',
      data: json['data'],
      messageId: json['messageId'],
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      endpoint: json['endpoint'],
      headers: json['headers'],
      topic: json['topic'],
    );
  }

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => {
    'type': type.name,
    if (event != null) 'event': event,
    if (data != null) 'data': data,
    if (messageId != null) 'messageId': messageId,
    if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    if (endpoint != null) 'endpoint': endpoint,
    if (headers != null) 'headers': headers,
    if (topic != null) 'topic': topic,
  };

  /// Encodes the object as a JSON string.
  String encode() => jsonEncode(toJson());

  /// Decodes a JSON string into a `SocketMessenger`.
  static SocketMessenger decode(String jsonStr) => SocketMessenger.fromJson(jsonDecode(jsonStr));

  factory SocketMessenger.simple({required SocketType command, required dynamic data}) {
    return SocketMessenger(
      type: command,
      data: data,
    );
  }

  @override
  String toString() => 'SocketMessenger(type: $type, event: $event, data: $data, messageId: $messageId, timestamp: $timestamp, endpoint: $endpoint, headers: $headers)';
}