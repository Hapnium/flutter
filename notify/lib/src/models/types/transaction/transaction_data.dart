class TransactionData {
  TransactionData({
    required this.id,
    required this.name,
    required this.header,
    required this.description,
    required this.reference,
    required this.mode,
    required this.date,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String header;
  final String description;
  final String reference;
  final String mode;
  final String date;
  final String updatedAt;

  TransactionData copyWith({
    String? id,
    String? name,
    String? header,
    String? description,
    String? reference,
    String? mode,
    String? date,
    String? updatedAt,
  }) {
    return TransactionData(
      id: id ?? this.id,
      name: name ?? this.name,
      header: header ?? this.header,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      mode: mode ?? this.mode,
      date: date ?? this.date,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      header: json["header"] ?? "",
      description: json["description"] ?? "",
      reference: json["reference"] ?? "",
      mode: json["mode"] ?? "",
      date: json["date"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "header": header,
    "description": description,
    "reference": reference,
    "mode": mode,
    "date": date,
    "updated_at": updatedAt,
  };
}