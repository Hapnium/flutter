/// Defines the type of call a user can make.
///
/// This includes standard voice calls and Tip2Fix (T2F) calls.
enum CallType {
  /// Standard voice call.
  voice("Voice", "VOICE"),

  /// Specialized call type for Tip2Fix (T2F) support.
  tip2fix("Tip2Fix", "T2F");

  /// A user-friendly label for the call type.
  final String type;

  /// A backend identifier for the call type.
  final String value;

  /// Creates a [CallType] with both a display name and backend identifier.
  const CallType(this.type, this.value);
}