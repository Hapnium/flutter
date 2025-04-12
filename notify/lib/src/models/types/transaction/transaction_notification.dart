import 'dart:convert';

import 'transaction_response.dart';

class TransactionNotification extends TransactionResponse {
  final String id;
  final String senderName;
  final String senderId;

  TransactionNotification({
    required this.id,
    required this.senderName,
    required this.senderId,
  }) : super(TransactionDataType.notification);

  factory TransactionNotification.fromJson(Map<String, dynamic> json) {
    return TransactionNotification(
      id: json["id"] ?? "",
      senderName: json['sender_name'] ?? '',
      senderId: json['sender_id'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': senderName,
      'sender_id': senderId,
    };
  }

  TransactionNotification copyWith({
    String? senderName,
    String? senderId,
    String? id,
  }) {
    return TransactionNotification(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      id: id ?? this.id
    );
  }

  @override
  String toString() => jsonEncode(this.toJson());

  @override
  TransactionNotification fromString(String source) => TransactionNotification.fromJson(jsonDecode(source));
}
