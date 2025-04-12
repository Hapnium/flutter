/// A class containing keys for various notification events.
///
/// These keys are used to identify specific actions or events triggered 
/// through notifications, such as replying to a message, marking a message as read, 
/// or interacting with calls, schedules, and transactions.
///
/// This class acts as a centralized repository for event keys, ensuring consistency 
/// and reducing hardcoded strings in the notification logic.
class NotifyEventKey {
  /// Key for replying to a message from a notification.
  ///
  /// This action is typically associated with an inline reply functionality.
  static String get REPLY_MESSAGE => "REPLY_MESSAGE";

  /// Key for marking a message as read from a notification.
  ///
  /// This action may update the message status to "read" without opening the app.
  static String get MARK_MESSAGE_AS_READ => "MARK_AS_READ";

  /// Key for answering an incoming call from a notification.
  ///
  /// This action is used in call notifications to accept an incoming call.
  static String get ANSWER_INCOMING_CALL => "ANSWER_INCOMING_CALL";

  /// Key for declining an incoming call from a notification.
  ///
  /// This action is used in call notifications to reject an incoming call.
  static String get DECLINE_INCOMING_CALL => "DECLINE_INCOMING_CALL";

  /// Key for viewing a transaction from a notification.
  ///
  /// This action navigates the user to the transaction details screen.
  static String get VIEW_TRANSACTION => "VIEW_TRANSACTION";

  /// Key for viewing a schedule from a notification.
  ///
  /// This action navigates the user to the schedule details screen.
  static String get VIEW_SCHEDULE => "VIEW_TRANSACTION";

  /// Key for accepting a schedule from a notification.
  ///
  /// This action confirms acceptance of a scheduled activity or task.
  static String get ACCEPT_SCHEDULE => "ACCEPT_SCHEDULE";

  /// Key for declining a schedule from a notification.
  ///
  /// This action indicates a rejection of a scheduled activity or task.
  static String get DECLINE_SCHEDULE => "DECLINE_SCHEDULE";

  /// Key for starting a scheduled trip from a notification.
  ///
  /// This action is used to initiate a trip or journey that was previously scheduled.
  static String get START_SCHEDULED_TRIP => "START_SCHEDULED_TRIP";

  /// Key for viewing trip details from a notification.
  ///
  /// This action navigates the user to the trip details screen.
  static String get VIEW_TRIP_DETAILS => "VIEW_TRIP";

  /// Key for viewing go-bcap details from a notification.
  ///
  /// This action navigates the user to the go-bcap details screen.
  static String get VIEW_GO_BCAP_DETAILS => "VIEW_GO_BCAP";

  /// Key for viewing go-event details from a notification.
  ///
  /// This action navigates the user to the go-event details screen.
  static String get VIEW_GO_EVENT_DETAILS => "VIEW_GO_EVENT";

  /// Key for viewing chat from a notification.
  ///
  /// This action navigates the user to the chat room screen.
  static String get VIEW_CHAT => "VIEW_CHAT";

  /// Key for viewing call from a notification.
  ///
  /// This action navigates the user to the call screen.
  static String get VIEW_CALL => "OPEN_CALL";
}