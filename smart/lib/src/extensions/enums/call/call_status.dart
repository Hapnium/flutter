import '../../../enums/call/call_status.dart';

/// Provides expressive boolean checks for [CallStatus].
///
/// This extension simplifies status checks by replacing `==` comparisons with readable getters.
/// Example:
/// ```dart
/// if (callStatus.isRinging) {
///   print("The call is currently ringing.");
/// }
/// ```
extension CallStatusExtension on CallStatus {
  /// Returns `true` if the call status is set to [CallStatus.ringing].
  ///
  /// This indicates that call is ringing.
  bool get isRinging => this == CallStatus.ringing;

  /// Returns `true` if the call status is set to [CallStatus.disconnected].
  ///
  /// This indicates that call is disconnected.
  bool get isDisconnected => this == CallStatus.disconnected;

  /// Returns `true` if the call status is set to [CallStatus.calling].
  ///
  /// This indicates that call is connecting.
  bool get isCalling => this == CallStatus.calling;

  /// Returns `true` if the call status is set to [CallStatus.closed].
  ///
  /// This indicates that call is closed/ended.
  bool get isClosed => this == CallStatus.closed;

  /// Returns `true` if the call status is set to [CallStatus.reconnecting].
  ///
  /// This indicates that call is reconnecting.
  bool get isReconnecting => this == CallStatus.reconnecting;

  /// Returns `true` if the call status is set to [CallStatus.declined].
  ///
  /// This indicates that call is declined.
  bool get isDeclined => this == CallStatus.declined;

  /// Returns `true` if the call status is set to [CallStatus.onCall].
  ///
  /// This indicates that call is active.
  bool get isOnCall => this == CallStatus.onCall;

  /// Returns `true` if the call status is set to [CallStatus.missed].
  ///
  /// This indicates that call is missed.
  bool get isMissed => this == CallStatus.missed;
}