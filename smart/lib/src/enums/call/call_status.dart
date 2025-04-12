/// Represents the different statuses a call can have.
///
/// These statuses help track the current state of a call session.
enum CallStatus {
  /// The call is currently ringing.
  ringing("Ringing", "RINGING"),

  /// The call is in progress.
  calling("Calling", "CALLING"),

  /// The call has been disconnected.
  disconnected("Disconnected", "DISCONNECTED"),

  /// The call is trying to reconnect.
  reconnecting("Reconnecting", "RECONNECTING"),

  /// The call was closed.
  closed("Closed", "CLOSED"),

  /// The call was declined by the recipient.
  declined("Declined", "DECLINED"),

  /// The user is currently on a call.
  onCall("On Call", "ON_CALL"),

  /// The call was missed.
  missed("Missed", "MISSED");

  /// A user-friendly label for the call status.
  final String type;

  /// A backend identifier for the call status.
  final String value;

  /// Creates a [CallStatus] with both a display name and backend identifier.
  const CallStatus(this.type, this.value);
}