import 'dart:convert';

import '../config/notify_event_key.dart';
import '../enums/notify_type.dart';

/// A class representing a notification event.
///
/// The `Notifier` class encapsulates all the details about a notification, including
/// its type, associated data, action, and input. It provides utility methods for checking
/// specific notification types and actions, making it easier to handle various scenarios.
///
/// This class supports serialization and deserialization for easier integration with APIs
/// and local storage.
class Notifier<T> {
  final int id;
  final String action;
  final String input;
  final NotifyType type;
  final String from;
  final String foreign;
  final T data;

  /// Constructor for creating a [Notifier] instance.
  Notifier({
    required this.type,
    required this.id,
    required this.data,
    this.action = "",
    this.input = "",
    required this.foreign,
    required this.from
  });

  /// Creates a copy of the current instance with optional changes.
  Notifier copyWith({
    NotifyType? type,
    T? data,
    int? id,
    String? action,
    String? input,
    String? from,
    String? foreign
  }) {
    return Notifier(
      type: type ?? this.type,
      data: data ?? this.data,
      id: id ?? this.id,
      action: action ?? this.action,
      input: input ?? this.input,
      from: from ?? this.from,
      foreign: foreign ?? this.foreign
    );
  }

  /// Factory constructor to create a [Notifier] from a JSON object.
  factory Notifier.fromJson(Map<String, dynamic> json) {
    return Notifier(
      id: json["id"] ?? -1,
      type: NotifyType.fromString(json["type"] ?? ""),
      data: json["data"],
      action: json["action"] ?? "",
      input: json["input"] ?? "",
      from: json["from"] ?? "",
      foreign: json["foreign"] ?? ""
    );
  }

  /// Factory constructor to create an empty [Notifier].
  factory Notifier.empty() {
    return Notifier(
      id: -1,
      type: NotifyType.others,
      data: null as T,
      action: "",
      input: "",
      from: "",
      foreign: ""
    );
  }

  /// Factory constructor to create a [Notifier] from a JSON string.
  factory Notifier.fromString(String source) {
    Map<String, dynamic> json = jsonDecode(source);
    return Notifier.fromJson(json);
  }

  /// Converts the [Notifier] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type.value,
      "data": data,
      "action": action,
      "input": input,
      "from": from,
      "foreign": foreign
    };
  }

  /// Converts the [Notifier] instance to a JSON string.
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Checks if the notification is a transaction type.
  bool get isTransaction => type == NotifyType.transaction;

  /// Checks if the notification is a call type.
  bool get isCall => type == NotifyType.call;

  /// Checks if the notification is a chat type.
  bool get isChat => type == NotifyType.chat;

  /// Checks if the notification is a schedule type.
  bool get isSchedule => type == NotifyType.schedule;

  /// Checks if the notification is a trip type.
  bool get isTrip => type == NotifyType.trip;

  /// Checks if the notification is of "others" type.
  bool get isOthers => type == NotifyType.others;

  /// Checks if the notification is of "goActivity" type.
  bool get isGoActivity => type == NotifyType.goActivity;

  /// Checks if the notification is of "goBCap" type.
  bool get isGoBCap => type == NotifyType.goBCap;

  /// Checks if the notification is of "goTrend" type.
  bool get isGoTrend => type == NotifyType.goTrend;

  /// Checks if the notification has an associated action.
  bool get hasAction => action.isNotEmpty;

  /// Checks if the action is to reply to a message.
  bool get replyMessage => hasAction && action == NotifyEventKey.REPLY_MESSAGE;

  /// Checks if the action is to mark a message as read.
  bool get markMessageAsRead => hasAction && action == NotifyEventKey.MARK_MESSAGE_AS_READ;

  /// Checks if the action is to answer an incoming call.
  bool get answerIncomingCall => hasAction && action == NotifyEventKey.ANSWER_INCOMING_CALL;

  /// Checks if the action is to decline an incoming call.
  bool get declineIncomingCall => hasAction && action == NotifyEventKey.DECLINE_INCOMING_CALL;

  /// Checks if the action is to view a transaction.
  bool get viewTransaction => hasAction && action == NotifyEventKey.VIEW_TRANSACTION;

  /// Checks if the action is to view a schedule.
  bool get viewSchedule => hasAction && action == NotifyEventKey.VIEW_SCHEDULE;

  /// Checks if the action is to view a call.
  bool get viewCall => hasAction && action == NotifyEventKey.VIEW_CALL;

  /// Checks if the action is to view a chat.
  bool get viewChat => hasAction && action == NotifyEventKey.VIEW_CHAT;

  /// Checks if the action is to accept a schedule.
  bool get acceptSchedule => hasAction && action == NotifyEventKey.ACCEPT_SCHEDULE;

  /// Checks if the action is to decline a schedule.
  bool get declineSchedule => hasAction && action == NotifyEventKey.DECLINE_SCHEDULE;

  /// Checks if the action is to start a scheduled trip.
  bool get startScheduledTrip => hasAction && action == NotifyEventKey.START_SCHEDULED_TRIP;

  /// Checks if the action is to view a trip.
  bool get viewTrip => hasAction && action == NotifyEventKey.VIEW_TRIP_DETAILS;
}