/// {@template trip_notification}
/// Represents a notification related to a trip request, update, or status change.
///
/// This class is used to deliver structured data about trips—such as sender information,
/// trip status, and permissions—to be consumed by the app's notification system.
///
/// Example usage:
///
/// ```dart
/// final notification = TripNotification(
///   snt: "notif_001",
///   name: "Driver John",
///   id: "user_123",
///   canAct: true,
///   status: "WAITING",
///   trip: "trip_789",
///   type: "REQUEST",
/// );
///
/// if (notification.isRequest && notification.canAct) {
///   print("You have a trip request from ${notification.name}");
/// }
/// ```
/// {@endtemplate}
class TripNotification {
  /// Unique identifier for the system notification token.
  ///
  /// Default: `""`
  final String snt;

  /// Display name of the sender (e.g., driver or dispatcher).
  ///
  /// Default: `""`
  final String name;

  /// Unique ID of the sender.
  ///
  /// Default: `""`
  final String id;

  /// Indicates whether the recipient can act on this notification (e.g., accept or reject).
  ///
  /// Default: `false`
  final bool canAct;

  /// Current status of the trip.
  ///
  /// Possible values: `"WAITING"`, `"ACTIVE"`, `"CLOSED"`, `"UNFULFILLED"`
  ///
  /// Default: `""`
  final String status;

  /// Identifier of the associated trip.
  ///
  /// Default: `""`
  final String trip;

  /// The type of notification, e.g., `"REQUEST"`, `"UPDATE"`
  ///
  /// Default: `""`
  final String type;

  /// {@macro trip_notification}
  TripNotification({
    required this.snt,
    required this.name,
    required this.id,
    required this.canAct,
    required this.status,
    required this.trip,
    required this.type,
  });

  /// Creates a [TripNotification] from a JSON map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = TripNotification.fromJson({
  ///   "snt": "notif_001",
  ///   "sender_name": "Driver John",
  ///   "sender_id": "user_123",
  ///   "can_act": true,
  ///   "status": "WAITING",
  ///   "trip_id": "trip_789",
  ///   "type": "REQUEST",
  /// });
  /// ```
  /// 
  /// {@macro trip_notification}
  factory TripNotification.fromJson(Map<String, dynamic> json) {
    return TripNotification(
      snt: json["snt"] ?? "",
      name: json['sender_name'] ?? "",
      id: json["sender_id"] ?? "",
      canAct: json["can_act"] ?? false,
      status: json["status"] ?? "",
      trip: json["trip_id"] ?? json["trip"] ?? "",
      type: json["type"] ?? "",
    );
  }

  /// Converts the instance into a JSON map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = TripNotification(
  ///   snt: "notif_001",
  ///   name: "Driver John",
  ///   id: "user_123",
  ///   canAct: true,
  ///   status: "WAITING",
  ///   trip: "trip_789",
  ///   type: "REQUEST",
  /// );
  /// final json = notification.toJson();
  /// ```
  /// 
  /// {@macro trip_notification}
  Map<String, dynamic> toJson() {
    return {
      "snt": snt,
      "sender_name": name,
      "sender_id": id,
      "can_act": canAct,
      "status": status,
      "trip_id": trip,
      "type": type,
    };
  }

  /// Returns a copy of the current instance with optional overrides.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = TripNotification(
  ///   snt: "notif_001",
  ///   name: "Driver John",
  ///   id: "user_123",
  ///   canAct: true,
  ///   status: "WAITING",
  ///   trip: "trip_789",
  ///   type: "REQUEST",
  /// );
  /// final updatedNotification = notification.copyWith(
  ///   status: "ACTIVE",
  /// );
  /// ```
  /// 
  /// {@macro trip_notification}
  TripNotification copyWith({
    String? snt,
    String? name,
    String? id,
    bool? canAct,
    String? status,
    String? trip,
    String? type,
  }) {
    return TripNotification(
      snt: snt ?? this.snt,
      name: name ?? this.name,
      id: id ?? this.id,
      canAct: canAct ?? this.canAct,
      status: status ?? this.status,
      trip: trip ?? this.trip,
      type: type ?? this.type,
    );
  }

  /// Returns true if the trip status is `"WAITING"`.
  bool get isWaiting => status == "WAITING";

  /// Returns true if the trip status is `"CLOSED"`.
  bool get isClosed => status == "CLOSED";

  /// Returns true if the trip status is `"UNFULFILLED"`.
  bool get isUnfulfilled => status == "UNFULFILLED";

  /// Returns true if the trip status is `"ACTIVE"`.
  bool get isActive => status == "ACTIVE";

  /// Returns true if the type of the notification is `"REQUEST"`.
  bool get isRequest => type == "REQUEST";
}