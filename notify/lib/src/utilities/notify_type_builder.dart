import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify/notify.dart';

import 'definitions.dart';

/// A builder class to create specific notification types from JSON data.
///
/// This class provides methods to create instances of various notification types,
/// such as ChatNotification, CallNotification, TripNotification, TransactionNotification, and ScheduleNotification.
class NotifyTypeBuilder {
  /// Private constructor to enforce singleton pattern.
  NotifyTypeBuilder._internal();

  /// The singleton instance of the class.
  static final NotifyTypeBuilder _instance = NotifyTypeBuilder._internal();

  /// Returns the singleton instance of the class.
  static NotifyTypeBuilder get instance => _instance;

  /// Creates a [ChatResponse] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [ChatResponse].
  ChatResponse chat(Data json) {
    return ChatResponse.fromJson(json);
  }

  /// Creates a [CallNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [CallNotification].
  CallNotification call(Data json) {
    return CallNotification.fromJson(json);
  }

  /// Creates a [TripNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [TripNotification].
  TripNotification trip(Data json) {
    return TripNotification.fromJson(json);
  }

  /// Creates a [TransactionResponse] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [TransactionResponse].
  TransactionResponse transaction(Data json) {
    return TransactionResponse.fromJson(json);
  }

  /// Creates a [ScheduleNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [ScheduleNotification].
  ScheduleNotification schedule(Data json) {
    return ScheduleNotification.fromJson(json);
  }

  /// Creates a [GoActivityNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [GoActivityNotification].
  GoActivityNotification goActivity(Data json) {
    return GoActivityNotification.fromJson(json);
  }

  /// Creates a [GoBCapNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [GoBCapNotification].
  GoBCapNotification goBCap(Data json) {
    return GoBCapNotification.fromJson(json);
  }

  /// Creates a [GoTrendNotification] from the given JSON data.
  ///
  /// - [json]: The JSON data to parse into a [GoTrendNotification].
  GoTrendNotification goTrend(Data json) {
    return GoTrendNotification.fromJson(json);
  }

  /// Creates a [Notifier] from the given [NotificationResponse] data.
  ///
  /// - [response]: The [NotificationResponse] data to parse into a [Notifier] payload.
  Notifier parse(NotificationResponse response) {
    Notifier notifier;

    if(response.payload != null) {
      notifier = Notifier.fromString(response.payload!);
    } else {
      notifier = Notifier.empty();
    }
    notifier = notifier.copyWith(action: response.actionId, input: response.input, id: response.id);

    return notifier;
  }
}