import '../config/tappy_event.dart';

/// Extension on [TappyEvent] to provide convenient boolean checks
/// for specific notification event types.
///
/// This allows for easier and more readable conditionals like:
/// ```dart
/// if (event.isReplyMessage) { ... }
/// if (event.isCallRelated) { ... }
/// ```
extension TappyEventX on String {
  /// Returns `true` if the event is a reply to a message.
  bool get isReplyMessage => this == TappyEvent.REPLY_MESSAGE.getKey();

  /// Returns `true` if the event marks a message as read.
  bool get isMarkMessageAsRead => this == TappyEvent.MARK_MESSAGE_AS_READ.getKey();

  /// Returns `true` if the event is to answer an incoming call.
  bool get isAnswerIncomingCall => this == TappyEvent.ANSWER_INCOMING_CALL.getKey();

  /// Returns `true` if the event is to decline an incoming call.
  bool get isDeclineIncomingCall => this == TappyEvent.DECLINE_INCOMING_CALL.getKey();

  /// Returns `true` if the event is to view a transaction.
  bool get isViewTransaction => this == TappyEvent.VIEW_TRANSACTION.getKey();

  /// Returns `true` if the event is to view a schedule.
  bool get isViewSchedule => this == TappyEvent.VIEW_SCHEDULE.getKey();

  /// Returns `true` if the event is to accept a schedule.
  bool get isAcceptSchedule => this == TappyEvent.ACCEPT_SCHEDULE.getKey();

  /// Returns `true` if the event is to decline a schedule.
  bool get isDeclineSchedule => this == TappyEvent.DECLINE_SCHEDULE.getKey();

  /// Returns `true` if the event is to start a scheduled trip.
  bool get isStartScheduledTrip => this == TappyEvent.START_SCHEDULED_TRIP.getKey();

  /// Returns `true` if the event is to view trip details.
  bool get isViewTripDetails => this == TappyEvent.VIEW_TRIP_DETAILS.getKey();

  /// Returns `true` if the event is to view nearby BCAP details.
  bool get isViewNearbyBCapDetails => this == TappyEvent.VIEW_NEARBY_BCAP_DETAILS.getKey();

  /// Returns `true` if the event is to view nearby event details.
  bool get isViewNearbyEventDetails => this == TappyEvent.VIEW_NEARBY_EVENT_DETAILS.getKey();

  /// Returns `true` if the event is to view nearby tournament details.
  bool get isViewNearbyTournamentDetails => this == TappyEvent.VIEW_NEARBY_TOURNAMENT_DETAILS.getKey();

  /// Returns `true` if the event is to view a chat screen.
  bool get isViewChat => this == TappyEvent.VIEW_CHAT.getKey();

  /// Returns `true` if the event is to open the call screen.
  bool get isViewCall => this == TappyEvent.VIEW_CALL.getKey();

  // ----------------------
  // Grouped/Composite Checks
  // ----------------------

  /// Returns `true` if the event is related to any "VIEW_NEARBY_*" action.
  bool get isNearbyView => isViewNearbyBCapDetails || isViewNearbyEventDetails || isViewNearbyTournamentDetails;

  /// Returns `true` if the event is related to schedule actions
  /// such as view, accept, decline, or start.
  bool get isScheduleRelated => isViewSchedule || isAcceptSchedule || isDeclineSchedule || isStartScheduledTrip;

  /// Returns `true` if the event is related to a call (incoming or viewing).
  bool get isCallRelated => isAnswerIncomingCall || isDeclineIncomingCall || isViewCall;

  /// Returns `true` if the event is related to messaging (chat, reply, or mark as read).
  bool get isMessageRelated => isReplyMessage || isMarkMessageAsRead || isViewChat;
}