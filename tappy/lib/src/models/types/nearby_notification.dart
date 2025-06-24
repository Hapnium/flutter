/// {@template nearby_activity_notification}
/// Represents a notification for a "Nearby" activity event.
///
/// This model includes detailed information about an activity such as location,
/// sender details, and status.
///
/// ### Example usage:
/// ```dart
/// final notification = NearbyActivityNotification.fromJson(json);
/// print(notification.title);
/// ```
/// {@endtemplate}
class NearbyActivityNotification {
  /// Unique identifier of the notification.
  final String id;

  /// Title of the notification.
  final String title;

  /// Detailed message or body of the notification.
  final String message;

  /// A short summary of the notification content.
  final String summary;

  /// Current status of the activity (e.g., PENDING, ACTIVE, COMPLETED).
  final String status;

  /// Username of the individual who initiated the activity.
  final String username;

  /// Contact information of the user.
  final String contact;

  /// Latitude coordinate of the activity location.
  final double latitude;

  /// Longitude coordinate of the activity location.
  final double longitude;

  /// Human-readable address of the activity.
  final String address;

  /// Number of people interested in the activity.
  final int interest;

  /// {@macro nearby_activity_notification}
  NearbyActivityNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.summary,
    required this.status,
    required this.username,
    required this.contact,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.interest,
  });

  /// Returns a new [NearbyActivityNotification] with optional updated fields.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyActivityNotification.copyWith(id: "new_id");
  /// ```
  /// 
  /// {@macro nearby_activity_notification}
  NearbyActivityNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? summary,
    String? status,
    String? username,
    String? contact,
    double? latitude,
    double? longitude,
    String? address,
    int? interest,
  }) {
    return NearbyActivityNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      username: username ?? this.username,
      contact: contact ?? this.contact,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      interest: interest ?? this.interest,
    );
  }

  /// Creates a [NearbyActivityNotification] from a JSON [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyActivityNotification.fromJson(json);
  /// ```
  /// 
  /// {@macro nearby_activity_notification}
  factory NearbyActivityNotification.fromJson(Map<String, dynamic> json) {
    return NearbyActivityNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      summary: json['summary'],
      status: json['status'],
      username: json['username'],
      contact: json['contact'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
      interest: json['interest'],
    );
  }

  /// Converts this [NearbyActivityNotification] instance into a JSON [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyActivityNotification.toJson();
  /// ```
  /// 
  /// {@macro nearby_activity_notification}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'summary': summary,
      'status': status,
      'username': username,
      'contact': contact,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'interest': interest,
    };
  }
}

/// {@template nearby_bcap_notification}
/// Represents a BCap (Broadcast Capability) notification within the "Nearby" activity context.
///
/// This model contains metadata related to a broadcasted activity update such as
/// its title, message content, related activity, and interest metrics.
///
/// ### Example usage:
/// ```dart
/// final notification = NearbyBCapNotification.fromJson(json);
/// print(notification.title);
/// ```
/// {@endtemplate}
class NearbyBCapNotification {
  /// Unique identifier for the notification.
  final String id;

  /// Identifier or name of the related activity.
  final String activity;

  /// The title or headline of the notification.
  final String title;

  /// Main body message of the notification.
  final String message;

  /// Count of interested participants or viewers.
  final int interest;

  /// {@macro nearby_bcap_notification}
  NearbyBCapNotification({
    required this.id,
    required this.activity,
    required this.title,
    required this.message,
    required this.interest,
  });

  /// Returns a new [NearbyBCapNotification] with any fields optionally replaced.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyBCapNotification.copyWith(id: "new_id");
  /// ```
  /// 
  /// {@macro nearby_bcap_notification}
  NearbyBCapNotification copyWith({
    String? id,
    String? activity,
    String? title,
    String? message,
    int? interest,
  }) {
    return NearbyBCapNotification(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      title: title ?? this.title,
      message: message ?? this.message,
      interest: interest ?? this.interest,
    );
  }

  /// Creates a [NearbyBCapNotification] from a JSON [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyBCapNotification.fromJson(json);
  /// ```
  /// 
  /// {@macro nearby_bcap_notification}
  factory NearbyBCapNotification.fromJson(Map<String, dynamic> json) {
    return NearbyBCapNotification(
      id: json['id'],
      activity: json['activity'],
      title: json['title'],
      message: json['message'],
      interest: json['interest'],
    );
  }

  /// Converts this [NearbyBCapNotification] instance to a JSON [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyBCapNotification.toJson();
  /// ```
  /// 
  /// {@macro nearby_bcap_notification}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'title': title,
      'message': message,
      'interest': interest,
    };
  }
}

/// {@template nearby_trend_notification}
/// Represents a trend-based notification for "Nearby" activities,
/// typically used to highlight growing or popular activity items.
///
/// Contains metadata like interest level, title, and a descriptive message.
///
/// ### Example usage:
/// ```dart
/// final trend = NearbyTrendNotification.fromJson(json);
/// print(trend.title);
/// ```
/// {@endtemplate}
class NearbyTrendNotification {
  /// Number of people who have shown interest in this trend.
  final int interest;

  /// Title or headline of the trend notification.
  final String title;

  /// Descriptive message for the trend.
  final String message;

  /// {@macro nearby_trend_notification}
  NearbyTrendNotification({
    required this.interest,
    required this.title,
    required this.message,
  });

  /// Creates a copy of this notification with the given fields replaced.
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyTrendNotification.copyWith(interest: 10);
  /// ```
  /// 
  /// {@macro nearby_trend_notification}
  NearbyTrendNotification copyWith({
    int? interest,
    String? title,
    String? message,
  }) {
    return NearbyTrendNotification(
      interest: interest ?? this.interest,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  /// Parses a [NearbyTrendNotification] from a JSON [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyTrendNotification.fromJson(json);
  /// ```
  /// 
  /// {@macro nearby_trend_notification}
  factory NearbyTrendNotification.fromJson(Map<String, dynamic> json) {
    return NearbyTrendNotification(
      interest: json["interest"] ?? 0,
      title: json["title"] ?? "",
      message: json["message"] ?? "",
    );
  }

  /// Converts this object into a JSON-compatible [Map].
  /// 
  /// ### Example:
  /// ```dart
  /// final notification = NearbyTrendNotification.toJson();
  /// ```
  /// 
  /// {@macro nearby_trend_notification}
  Map<String, dynamic> toJson() => {
    "interest": interest,
    "title": title,
    "message": message,
  };

  @override
  String toString() {
    return "$interest, $title, $message";
  }
}