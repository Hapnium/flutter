// Define an enum for data types
import 'dart:convert';

import '../../../../notify.dart';
import 'transaction.dart';

enum TransactionDataType { notification, transaction }

// Sealed union class
abstract class TransactionResponse {
  final TransactionDataType dataType;

  TransactionResponse(this.dataType);

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("id") && json.containsKey("sender_name") && json.containsKey("sender_id")) {
      return TransactionNotification.fromJson(json);
    } else {
      // Parse transaction data based on other keys
      return Transaction.fromJson(json);
    }
  }

  /// This is a [TransactionNotification] data response
  bool get isNotification => dataType == TransactionDataType.notification;

  /// [TransactionResponse] current type as [TransactionNotification]
  TransactionNotification get notification => isNotification
      ? this as TransactionNotification
      : throw NotifyException("This is not a TransactionNotification data");

  /// [TransactionResponse] current type as [Transaction]
  Transaction get transaction => isTransaction
      ? this as Transaction
      : throw NotifyException("This is not a Transaction data");

  /// This is a [Transaction] data response
  bool get isTransaction => dataType == TransactionDataType.transaction;

  /// Foreign identifier
  String get foreign => isNotification ? notification.id : transaction.data.id;

  Map<String, dynamic> toJson() => isNotification ? notification.toJson() : transaction.toJson();

  @override
  String toString() => jsonEncode(this.toJson());

  TransactionResponse fromString(String source) => TransactionResponse.fromJson(jsonDecode(source));
}