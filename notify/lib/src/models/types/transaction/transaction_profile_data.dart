class TransactionProfileData {
  TransactionProfileData({
    required this.name,
    required this.category,
    required this.rating,
    required this.avatar,
    required this.image,
  });

  final String name;
  final String category;
  final double rating;
  final String avatar;
  final String image;

  TransactionProfileData copyWith({
    String? name,
    String? category,
    double? rating,
    String? avatar,
    String? image,
  }) {
    return TransactionProfileData(
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      avatar: avatar ?? this.avatar,
      image: image ?? this.image,
    );
  }

  factory TransactionProfileData.fromJson(Map<String, dynamic> json) {
    return TransactionProfileData(
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      rating: json["rating"] ?? 0.0,
      avatar: json["avatar"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "category": category,
    "rating": rating,
    "avatar": avatar,
    "image": image,
  };
}