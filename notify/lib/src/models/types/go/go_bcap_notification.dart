class GoBCapNotification {
  final String id;
  final String activity;
  final String title;
  final String message;
  final int interest;

  // Constructor
  GoBCapNotification({
    required this.id,
    required this.activity,
    required this.title,
    required this.message,
    required this.interest,
  });

  // copyWith method
  GoBCapNotification copyWith({
    String? id,
    String? activity,
    String? title,
    String? message,
    int? interest,
  }) {
    return GoBCapNotification(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      title: title ?? this.title,
      message: message ?? this.message,
      interest: interest ?? this.interest,
    );
  }

  // fromJson factory method
  factory GoBCapNotification.fromJson(Map<String, dynamic> json) {
    return GoBCapNotification(
      id: json['id'],
      activity: json['activity'],
      title: json['title'],
      message: json['message'],
      interest: json['interest'],
    );
  }

  // toJson method
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