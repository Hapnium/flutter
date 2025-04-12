class GoTrendNotification {
  GoTrendNotification({
    required this.interest,
    required this.title,
    required this.message,
  });

  final int interest;
  final String title;
  final String message;

  GoTrendNotification copyWith({
    int? interest,
    String? title,
    String? message,
  }) {
    return GoTrendNotification(
      interest: interest ?? this.interest,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  factory GoTrendNotification.fromJson(Map<String, dynamic> json){
    return GoTrendNotification(
      interest: json["interest"] ?? 0,
      title: json["title"] ?? "",
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "interest": interest,
    "title": title,
    "message": message,
  };

  @override
  String toString(){
    return "$interest, $title, $message, ";
  }
}
