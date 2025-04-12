/// Enum representing different types of notification events.
///
/// This is used to identify the type of notification being handled
/// by the notification service.
///
/// - `transaction`: A notification related to a transaction.
/// - `trip`: A notification related to a trip.
/// - `schedule`: A notification related to a schedule or calendar event.
/// - `chat`: A notification for chat or messaging.
/// - `call`: A notification for an incoming or ongoing call.
/// - `others`: Any other type of notification not covered above.
enum NotifyType {
  /// Notification related to a transaction.
  transaction("transaction"),
  /// Notification related to a trip.
  trip("trip"),
  /// Notification related to a goBCap.
  goBCap("goBCap"),
  /// Notification related to a goEvent.
  goActivity("goActivity"),
  /// Notification related to a goTrend.
  goTrend("goTrend"),
  /// Notification related to a schedule or calendar event.
  schedule("schedule"),
  /// Notification for chat or messaging.
  chat("chat"),
  /// Notification for an incoming or ongoing call.
  call("call"),
  /// Any other type of notification not covered above.
  others("others");

  final String value;
  const NotifyType(this.value);

  static NotifyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'transaction':
        return NotifyType.transaction;
      case 'trip':
        return NotifyType.trip;
      case 'schedule':
        return NotifyType.schedule;
      case 'chat':
        return NotifyType.chat;
      case 'call':
        return NotifyType.call;
      case 'gobcap':
        return NotifyType.goBCap;
      case 'goactivity':
        return NotifyType.goActivity;
      case 'gotrend':
      return NotifyType.goTrend;
      default:
        return NotifyType.others;
    }
  }
}