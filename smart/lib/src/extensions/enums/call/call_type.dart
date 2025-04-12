import '../../../enums/call/call_type.dart';

/// Provides quick comparisons for [CallType].
///
/// Example:
/// ```dart
/// if (callType.isVoice) {
///   print("User is making a voice call.");
/// }
/// ```
extension CallTypeExtension on CallType {
  /// Returns `true` if the call type is set to [CallType.voice].
  ///
  /// This indicates that this is a voice call.
  bool get isVoice => this == CallType.voice;

  /// Returns `true` if the call type is set to [CallType.tip2fix].
  ///
  /// This indicates that this is a tip2fix call.
  bool get isTip2Fix => this == CallType.tip2fix;
}