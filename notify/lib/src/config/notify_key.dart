/// A utility class that defines notification-related keys and constants.
///
/// This class provides standardized keys and values used in handling
/// different types of notifications. These keys are typically found
/// in notification payloads and are used to differentiate between
/// notification types or to extract relevant data.
class NotifyKey {
  /// The key used to identify the type of notification.
  static const String NOTIFY = "snt";

  /// The key used to identify the sender of a call notification.
  static const String CALL_NOTIFY = "sender";

  /// The value representing a chat notification type.
  ///
  /// Notifications with this value are related to chat messages.
  static const String CHAT = "CHAT";

  /// The value representing a call notification type.
  ///
  /// Notifications with this value are related to video calls.
  static const String CALL = "stream.video";

  /// The value representing a schedule notification type.
  ///
  /// Notifications with this value are related to scheduled events or appointments.
  static const String SCHEDULE = "SCHEDULE";

  /// The value representing a go-event notification type.
  ///
  /// Notifications with this value are related to go-events.
  static const String GO_ACTIVITY = "GO_ACTIVITY";

  /// The value representing a go-bcap notification type.
  ///
  /// Notifications with this value are related to go-bcaps.
  static const String GO_BCAP = "GO_BCAP";

  /// The value representing a go-trend notification type.
  ///
  /// Notifications with this value are related to go-trends.
  static const String GO_TREND = "GO_TREND";

  /// The value representing a trip notification type.
  ///
  /// Notifications with this value are related to trip updates or messages.
  static const String TRIP = "TRIP_MESSAGE";

  /// The value representing a transaction notification type.
  ///
  /// Notifications with this value are related to transactions, such as payments or financial updates.
  static const String TRANSACTION = "TRANSACTION";
}