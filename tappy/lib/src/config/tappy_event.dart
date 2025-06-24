/// {@template tappy_event_key}
/// A class containing keys for various notification events.
///
/// These keys are used to identify specific actions or events triggered 
/// through notifications, such as replying to a message, marking a message as read, 
/// or interacting with calls, schedules, and transactions.
///
/// This class acts as a centralized repository for event keys, ensuring consistency 
/// and reducing hardcoded strings in the notification logic.
/// 
/// {@endtemplate}
class TappyEvent {
  /// The key for the notification event.
  final String _key;

  /// Creates a new [TappyEvent] instance.
  const TappyEvent._(this._key);

  /// Returns the key for the notification event.
  String getKey() => _key;

  /// Key for replying to a message from a notification.
  ///
  /// This action is typically associated with an inline reply functionality.
  static const TappyEvent REPLY_MESSAGE = TappyEvent._("REPLY_MESSAGE");

  /// Key for marking a message as read from a notification.
  ///
  /// This action may update the message status to "read" without opening the app.
  static const TappyEvent MARK_MESSAGE_AS_READ = TappyEvent._("MARK_AS_READ");

  /// Key for answering an incoming call from a notification.
  ///
  /// This action is used in call notifications to accept an incoming call.
  static const TappyEvent ANSWER_INCOMING_CALL = TappyEvent._("ANSWER_INCOMING_CALL");

  /// Key for declining an incoming call from a notification.
  ///
  /// This action is used in call notifications to reject an incoming call.
  static const TappyEvent DECLINE_INCOMING_CALL = TappyEvent._("DECLINE_INCOMING_CALL");

  /// Key for viewing a transaction from a notification.
  ///
  /// This action navigates the user to the transaction details screen.
  static const TappyEvent VIEW_TRANSACTION = TappyEvent._("VIEW_TRANSACTION");

  /// Key for viewing a schedule from a notification.
  ///
  /// This action navigates the user to the schedule details screen.
  static const TappyEvent VIEW_SCHEDULE = TappyEvent._("VIEW_SCHEDULE");

  /// Key for accepting a schedule from a notification.
  ///
  /// This action confirms acceptance of a scheduled activity or task.
  static const TappyEvent ACCEPT_SCHEDULE = TappyEvent._("ACCEPT_SCHEDULE");

  /// Key for declining a schedule from a notification.
  ///
  /// This action indicates a rejection of a scheduled activity or task.
  static const TappyEvent DECLINE_SCHEDULE = TappyEvent._("DECLINE_SCHEDULE");

  /// Key for starting a scheduled trip from a notification.
  ///
  /// This action is used to initiate a trip or journey that was previously scheduled.
  static const TappyEvent START_SCHEDULED_TRIP = TappyEvent._("START_SCHEDULED_TRIP");

  /// Key for viewing trip details from a notification.
  ///
  /// This action navigates the user to the trip details screen.
  static const TappyEvent VIEW_TRIP_DETAILS = TappyEvent._("VIEW_TRIP");

  /// Key for viewing nearby-bcap details from a notification.
  ///
  /// This action navigates the user to the nearby-bcap details screen.
  static const TappyEvent VIEW_NEARBY_BCAP_DETAILS = TappyEvent._("VIEW_NEARBY_BCAP");

  /// Key for viewing nearby-event details from a notification.
  ///
  /// This action navigates the user to the nearby-event details screen.
  static const TappyEvent VIEW_NEARBY_EVENT_DETAILS = TappyEvent._("VIEW_NEARBY_EVENT");

  /// Key for viewing nearby-tournament details from a notification.
  ///
  /// This action navigates the user to the nearby-tournament details screen.
  static const TappyEvent VIEW_NEARBY_TOURNAMENT_DETAILS = TappyEvent._("VIEW_NEARBY_TOURNAMENT");

  /// Key for viewing chat from a notification.
  ///
  /// This action navigates the user to the chat room screen.
  static const TappyEvent VIEW_CHAT = TappyEvent._("VIEW_CHAT");

  /// Key for viewing call from a notification.
  ///
  /// This action navigates the user to the call screen.
  static const TappyEvent VIEW_CALL = TappyEvent._("OPEN_CALL");

  /// Key for custom actions from a notification.
  ///
  /// This action is used to handle custom actions that are not covered by the other keys.
  static TappyEvent CUSTOM(String key) => TappyEvent._(key);
}