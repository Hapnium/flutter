class TripNotification {
  final String snt;
  final String name;
  final String id;
  final bool canAct;
  final String status;
  final String trip;
  final String type;

  TripNotification({
    required this.snt,
    required this.name,
    required this.id,
    required this.canAct,
    required this.status,
    required this.trip,
    required this.type
  });

  factory TripNotification.fromJson(Map<String, dynamic> json) {
    return TripNotification(
      snt: json["snt"] ?? "",
      name: json['sender_name'] ?? "",
      id: json["sender_id"] ?? "",
      canAct: json["can_act"] ?? false,
      status: json["status"] ?? "",
      trip: json["trip_id"] ?? json["trip"] ?? "",
      type: json["type"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "snt": snt,
      "sender_name": name,
      "sender_id": id,
      "can_act": canAct,
      "status": status,
      "trip_id": trip,
      "type": type
    };
  }

  TripNotification copyWith({
    String? snt,
    String? name,
    String? id,
    bool? canAct,
    String? status,
    String? trip,
    String? type
  }) {
    return TripNotification(
      snt: snt ?? this.snt,
      name: name ?? this.name,
      id: id ?? this.id,
      canAct: canAct ?? this.canAct,
      status: status ?? this.status,
      trip: trip ?? this.trip,
      type: type ?? this.type
    );
  }

  bool get isWaiting => status == "WAITING";
  bool get isClosed => status == "CLOSED";
  bool get isUnfulfilled => status == "UNFULFILLED";
  bool get isActive => status == "ACTIVE";
  bool get isRequest => type == "REQUEST";
}