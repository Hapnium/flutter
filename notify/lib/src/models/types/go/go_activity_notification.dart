class GoActivityNotification {
  final String id;
  final String title;
  final String message;
  final String summary;
  final String status;
  final String username;
  final String contact;
  final double latitude;
  final double longitude;
  final String address;
  final int interest;

  // Constructor
  GoActivityNotification({
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

  // copyWith method
  GoActivityNotification copyWith({
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
    return GoActivityNotification(
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

  // fromJson factory method
  factory GoActivityNotification.fromJson(Map<String, dynamic> json) {
    return GoActivityNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      summary: json['summary'],
      status: json['status'],
      username: json['username'],
      contact: json['contact'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      interest: json['interest'],
    );
  }

  // toJson method
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