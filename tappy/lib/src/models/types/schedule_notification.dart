/// {@template schedule_notification}
/// Represents a scheduled task or event notification within the app.
///
/// This model is used to handle scheduling events such as services or appointments,
/// along with their metadata (e.g., status, rating, participants, and timing).
///
/// It supports tracking whether an event was accepted or closed on time,
/// and provides convenient methods to construct and manipulate the notification.
///
/// Example usage:
///
/// ```dart
/// final notification = ScheduleNotification(
///   id: "123",
///   time: "10:00 AM",
///   avatar: "https://example.com/avatar.png",
///   name: "John Doe",
///   category: "Plumbing",
///   image: "https://example.com/image.png",
///   status: "PENDING",
///   reason: "",
///   closedBy: "",
///   closedAt: "",
///   closedOnTime: true,
///   label: "Urgent Repair",
///   rating: 4.5,
///   createdAt: DateTime.now(),
///   snt: "notification_id",
/// );
///
/// if (notification.isPending) {
///   print("You have a pending task from ${notification.name}");
/// }
/// ```
/// {@endtemplate}
class ScheduleNotification {
  /// Unique identifier of the notification.
  ///
  /// Default: `""`
  final String id;

  /// Scheduled time for the event or task.
  ///
  /// Example: `"10:00 AM"`, Default: `""`
  final String time;

  /// URL of the avatar image associated with the sender or initiator.
  ///
  /// Default: `""`
  final String avatar;

  /// Display name of the person who scheduled or is involved in the task.
  ///
  /// Default: `""`
  final String name;

  /// Category of the task (e.g., Cleaning, Plumbing).
  ///
  /// Default: `""`
  final String category;

  /// Image URL representing the task or notification.
  ///
  /// Default: `""`
  final String image;

  /// Status of the task. Possible values: `"PENDING"`, `"ACCEPTED"`, etc.
  ///
  /// Default: `"PENDING"`
  final String status;

  /// Reason for task closure or cancellation, if any.
  ///
  /// Default: `""`
  final String reason;

  /// Identifier of the person who closed the task.
  ///
  /// Default: `""`
  final String closedBy;

  /// Time when the task was marked as closed.
  ///
  /// Default: `""`
  final String closedAt;

  /// Whether the task was closed within the scheduled time window.
  ///
  /// Default: `true`
  final bool closedOnTime;

  /// Label associated with the task (e.g., `"Urgent"`).
  ///
  /// Default: `""`
  final String label;

  /// Rating given for the completed task, ranging from 0.0 to 5.0.
  ///
  /// Default: `0.0`
  final double rating;

  /// Date and time when this schedule notification was created.
  ///
  /// Default: `DateTime.now()` if not parsed from JSON
  final DateTime createdAt;

  /// Unique system notification token or ID.
  ///
  /// Default: `""`
  final String snt;

  /// {@macro schedule_notification}
  ScheduleNotification({
    required this.id,
    required this.time,
    required this.avatar,
    required this.name,
    required this.category,
    required this.image,
    required this.status,
    required this.reason,
    required this.closedBy,
    required this.closedAt,
    required this.closedOnTime,
    required this.label,
    required this.rating,
    required this.createdAt,
    required this.snt,
  });

  /// Creates a modified copy of the current instance with optional overrides.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = ScheduleNotification(
  ///   id: "123",
  ///   time: "10:00 AM",
  ///   avatar: "https://example.com/avatar.png",
  ///   name: "John Doe",
  ///   category: "Plumbing",
  ///   image: "https://example.com/image.png",
  ///   status: "PENDING",
  ///   reason: "",
  ///   closedBy: "",
  ///   closedAt: "",
  ///   closedOnTime: true,
  ///   label: "Urgent Repair",
  ///   rating: 4.5,
  ///   createdAt: DateTime.now(),
  ///   snt: "notification_id",
  /// );
  /// 
  /// final updatedNotification = notification.copyWith(
  ///   status: "ACCEPTED",
  ///   closedOnTime: false,
  /// );
  /// ```
  /// 
  /// {@macro schedule_notification}
  ScheduleNotification copyWith({
    String? id,
    String? time,
    String? avatar,
    String? name,
    String? category,
    String? image,
    String? status,
    String? reason,
    String? closedBy,
    String? closedAt,
    bool? closedOnTime,
    String? label,
    double? rating,
    DateTime? createdAt,
    String? snt,
  }) {
    return ScheduleNotification(
      id: id ?? this.id,
      time: time ?? this.time,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      closedBy: closedBy ?? this.closedBy,
      closedAt: closedAt ?? this.closedAt,
      closedOnTime: closedOnTime ?? this.closedOnTime,
      label: label ?? this.label,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      snt: snt ?? this.snt,
    );
  }

  /// Constructs a [ScheduleNotification] instance from a JSON map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = ScheduleNotification.fromJson({
  ///   "id": "123",
  ///   "time": "10:00 AM",
  ///   "avatar": "https://example.com/avatar.png",
  ///   "name": "John Doe",
  ///   "category": "Plumbing",
  ///   "image": "https://example.com/image.png",
  ///   "status": "PENDING",
  ///   "reason": "",
  ///   "closed_by": "",
  ///   "closed_at": "",
  ///   "closed_on_time": true,
  ///   "label": "Urgent Repair",
  ///   "rating": 4.5,
  ///   "created_at": "2023-01-01T00:00:00.000Z",
  ///   "snt": "notification_id",
  /// });
  /// ```
  /// 
  /// {@macro schedule_notification}
  factory ScheduleNotification.fromJson(Map<String, dynamic> json) {
    return ScheduleNotification(
      id: json["id"] ?? "",
      time: json["time"] ?? "",
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      status: json["status"] ?? "",
      reason: json["reason"] ?? "",
      closedBy: json["closed_by"] ?? "",
      closedAt: json["closed_at"] ?? "",
      closedOnTime: json["closed_on_time"] ?? false,
      label: json["label"] ?? "",
      rating: json["rating"] ?? 0.0,
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      snt: json["snt"] ?? "",
    );
  }

  /// Creates an empty default [ScheduleNotification] instance with preset values.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = ScheduleNotification.empty();
  /// ```
  /// 
  /// {@macro schedule_notification}
  factory ScheduleNotification.empty() {
    return ScheduleNotification.fromJson({
      "id": "",
      "time": "",
      "avatar": "",
      "name": "",
      "category": "",
      "image": "",
      "status": "PENDING",
      "reason": "",
      "closed_by": "",
      "closed_at": "",
      "closed_on_time": true,
      "rating": 0.0,
      "label": "",
      "created_at": "",
      "snt": "",
    });
  }

  /// Converts this object to a JSON map.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = ScheduleNotification.empty();
  /// final json = notification.toJson();
  /// ```
  /// 
  /// {@macro schedule_notification}
  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "avatar": avatar,
    "name": name,
    "category": category,
    "image": image,
    "status": status,
    "reason": reason,
    "closed_by": closedBy,
    "closed_at": closedAt,
    "closed_on_time": closedOnTime,
    "rating": rating,
    "label": label,
    "created_at": createdAt.toIso8601String(),
    "snt": snt,
  };

  /// Returns true if the status is `PENDING`.
  bool get isPending => status == "PENDING";

  /// Returns true if the status is `ACCEPTED`.
  bool get isAccepted => status == "ACCEPTED";
}