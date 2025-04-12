import 'package:notify/notify.dart';

import 'definitions.dart';

/// A utility class to check the type of a notification based on its JSON data.
///
/// This class provides methods to identify specific notification types, such as
/// ChatNotification, CallNotification, TripNotification, TransactionNotification, and ScheduleNotification.
class NotifyTypeChecker {
  /// Private constructor to enforce singleton pattern.
  NotifyTypeChecker._internal();

  /// The singleton instance of the class.
  static final NotifyTypeChecker _instance = NotifyTypeChecker._internal();

  /// Returns the singleton instance of the class.
  static NotifyTypeChecker get instance => _instance;

  /// Checks if the given data represents a [ChatNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a ChatNotification, otherwise `false`.
  bool isChat(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.CHAT;
  }

  /// Checks if the given data represents a [CallNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a CallNotification, otherwise `false`.
  bool isCall(Data data) {
    return (data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.CALL) ||
        (data.containsKey(NotifyKey.CALL_NOTIFY) && data[NotifyKey.CALL_NOTIFY] == NotifyKey.CALL);
  }

  /// Checks if the given data represents a [TransactionNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a TransactionNotification, otherwise `false`.
  bool isTransaction(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.TRANSACTION;
  }

  /// Checks if the given data represents a [TripNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a TripNotification, otherwise `false`.
  bool isTrip(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.TRIP;
  }

  /// Checks if the given data represents a [ScheduleNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a ScheduleNotification, otherwise `false`.
  bool isSchedule(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.SCHEDULE;
  }

  /// Checks if the given data represents a [GoActivityNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a GoEventNotification, otherwise `false`.
  bool isGoActivity(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.GO_ACTIVITY;
  }

  /// Checks if the given data represents a [GoBCapNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a GoBCapNotification, otherwise `false`.
  bool isGoBCap(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.GO_BCAP;
  }

  /// Checks if the given data represents a [GoTrendNotification].
  ///
  /// - [data]: The JSON data to check.
  /// - Returns `true` if the data corresponds to a GoTrendNotification, otherwise `false`.
  bool isGoTrend(Data data) {
    return data.containsKey(NotifyKey.NOTIFY) && data[NotifyKey.NOTIFY] == NotifyKey.GO_TREND;
  }
}