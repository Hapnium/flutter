import '../definitions.dart';
import '../enums/socket_type.dart';

/// {@template zync_response}
/// Represents a message response from the WebSocket connection.
/// 
/// {@endtemplate}
class ZyncResponse {
  /// The event type or command.
  final SocketType? type;
  
  /// Headers associated with the message.
  final Headers? headers;
  
  /// Raw message body as string.
  final String? body;
  
  /// Parsed data from the message body.
  final dynamic data;
  
  /// Whether the message has a body.
  final bool hasBody;
  
  /// Whether the message has parsed data.
  final bool hasData;
  
  /// Timestamp when the message was received.
  final DateTime timestamp;

  /// Creates a new instance of [ZyncResponse].
  /// 
  /// {@macro zync_response}
  ZyncResponse({
    this.type,
    this.headers,
    this.body,
    this.data,
    this.hasBody = false,
    this.hasData = false,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'type': type,
    'headers': headers,
    'body': body,
    'data': data,
    'hasBody': hasBody,
    'hasData': hasData,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() => 'ZyncResponse[${type ?? 'unknown'}]: $data';
}