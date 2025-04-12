class PendingRegistrationResponse {
  final String token;
  final String errorCode;

  PendingRegistrationResponse({required this.errorCode, required this.token});

  factory PendingRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return PendingRegistrationResponse(
      errorCode: json["error_code"] ?? "",
      token: json["token"] ?? ""
    );
  }

  factory PendingRegistrationResponse.empty() => PendingRegistrationResponse(errorCode: "", token: "");

  Map<String, dynamic> toJson() {
    return {
      "error_code": errorCode,
      "token": token
    };
  }

  /// Returns `true` if the error errorCode indicates that the category is not set.
  bool get isCategoryNotSet => errorCode == "S96";

  /// Returns `true` if the error errorCode indicates that the account has not been created.
  bool get isAccountNotCreated => errorCode == "S92";
}