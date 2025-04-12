class RemoteNotificationAndroid {
  final bool directBootOk;

  RemoteNotificationAndroid({
    this.directBootOk = true,
  });

  factory RemoteNotificationAndroid.fromJson(Map<String, dynamic> json) {
    return RemoteNotificationAndroid(
      directBootOk: json['direct_boot_ok'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direct_boot_ok': directBootOk,
    };
  }

  RemoteNotificationAndroid copyWith({
    bool? directBootOk,
  }) {
    return RemoteNotificationAndroid(
      directBootOk: directBootOk ?? this.directBootOk,
    );
  }
}
