/// {@template call_notification}
/// Represents a notification event for a call (voice or tip2fix).
///
/// This model is typically used to interpret and manage incoming or missed
/// call notifications within the app. It includes metadata such as sender,
/// receiver, channel ID, type of call, and identifiers for participants.
///
/// Example usage:
///
/// ```dart
/// final notification = CallNotification(
///   callDisplayName: "Support Call",
///   createdByDisplayName: "Alice",
///   sender: "alice_id",
///   receiverId: "bob_id",
///   callCid: "voice:SCALL1234",
///   createdById: "alice_id",
///   type: "call.ring",
///   version: "1.0",
/// );
///
/// if (notification.isRinging) {
///   print("Incoming call from ${notification.createdByDisplayName}");
/// }
/// ```
///
/// You can also use utility getters like [notificationTitle] and [notificationBody]
/// to generate UI-friendly strings.
/// {@endtemplate}
class CallNotification {
  /// The display name shown to the receiver for the call.
  ///
  /// Default: `""`
  final String callDisplayName;

  /// The name of the user who initiated the call.
  ///
  /// Default: `""`
  final String createdByDisplayName;

  /// The ID of the sender of the call notification.
  ///
  /// Default: `""`
  final String sender;

  /// The ID of the receiver of the call.
  ///
  /// Default: `""`
  final String receiverId;

  /// The composite call channel ID in the format `type:channel`, e.g. `voice:SCALL1234`.
  ///
  /// Default: `""`
  final String callCid;

  /// The ID of the user who created the call.
  ///
  /// Default: `""`
  final String createdById;

  /// The type of call notification (e.g., `call.ring`, `call.missed`).
  ///
  /// Default: `""`
  final String type;

  /// The version of the notification protocol being used.
  ///
  /// Default: `""`
  final String version;

  /// {@macro call_notification}
  CallNotification({
    required this.callDisplayName,
    required this.createdByDisplayName,
    required this.sender,
    required this.receiverId,
    required this.callCid,
    required this.createdById,
    required this.type,
    required this.version,
  });

  /// Converts this [CallNotification] to a JSON-compatible map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = CallNotification(
  ///   callDisplayName: "Support Call",
  ///   createdByDisplayName: "Alice",
  ///   sender: "alice_id",
  ///   receiverId: "bob_id",
  ///   callCid: "voice:SCALL1234",
  ///   createdById: "alice_id",
  ///   type: "call.ring",
  ///   version: "1.0",
  /// );
  /// 
  /// final json = notification.toJson();
  /// ```
  /// 
  /// {@macro call_notification}
  Map<String, dynamic> toJson() {
    return {
      'call_display_name': callDisplayName,
      'created_by_display_name': createdByDisplayName,
      'sender': sender,
      'receiver_id': receiverId,
      'call_cid': callCid,
      'created_by_id': createdById,
      'type': type,
      'version': version,
    };
  }

  /// Creates a [CallNotification] instance from a JSON map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = CallNotification.fromJson(rawData);
  /// ```
  /// 
  /// {@macro call_notification}
  factory CallNotification.fromJson(Map<String, dynamic> json) {
    return CallNotification(
      callDisplayName: json['call_display_name'] ?? "",
      createdByDisplayName: json['created_by_display_name'] ?? "",
      sender: json['sender'] ?? "",
      receiverId: json['receiver_id'] ?? "",
      callCid: json['call_cid'] ?? "",
      createdById: json['created_by_id'] ?? "",
      type: json['type'] ?? "",
      version: json['version'] ?? "",
    );
  }

  /// Returns a new [CallNotification] with updated fields.
  /// 
  /// {@macro call_notification}
  CallNotification copyWith({
    String? callDisplayName,
    String? createdByDisplayName,
    String? sender,
    String? receiverId,
    String? callCid,
    String? createdById,
    String? type,
    String? version,
  }) {
    return CallNotification(
      callDisplayName: callDisplayName ?? this.callDisplayName,
      createdByDisplayName: createdByDisplayName ?? this.createdByDisplayName,
      sender: sender ?? this.sender,
      receiverId: receiverId ?? this.receiverId,
      callCid: callCid ?? this.callCid,
      createdById: createdById ?? this.createdById,
      type: type ?? this.type,
      version: version ?? this.version,
    );
  }

  /// Returns `true` if this notification indicates a ringing call.
  bool get isRinging => type == "call.ring";

  /// Returns `true` if this notification indicates a missed call.
  bool get isMissed => type == "call.missed";

  /// Extracts the type from [callCid] (e.g., `"voice"` from `"voice:SCALL1234"`).
  String get cid => callCid.split(':').first;

  /// Returns `true` if the call type is `"voice"`.
  bool get isVoiceCall => cid.toLowerCase() == "voice";

  /// Extracts the channel ID from [callCid] (e.g., `"SCALL1234"` from `"voice:SCALL1234"`).
  String get channel => callCid.split(':').last;

  /// A user-facing title string for the call notification.
  ///
  /// Outputs `"Incoming voice call"` or `"Missed voice call"`, depending on context.
  String get notificationTitle => isRinging ? "Incoming ${isVoiceCall ? "voice" : "tip2fix"} call" : "Missed ${isVoiceCall ? "voice" : "tip2fix"} call";

  /// A user-facing body string for the call notification.
  ///
  /// Typically displays the name of the caller or recipient.
  String get notificationBody => isRinging ? createdByDisplayName : callDisplayName;
}