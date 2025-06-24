/// {@template session_response}
/// A data model representing a session response, typically returned from an
/// authentication endpoint. The session response includes both an access token
/// and a refresh token.
///
/// JSON structure:
/// ```json
/// {
///   "access_token": "string",
///   "refresh_token": "string"
/// }
/// ```
/// 
/// {@endtemplate}
class SessionResponse {
  /// Constructs a [SessionResponse] object with the required [accessToken]
  /// and [refreshToken].
  ///
  /// Both tokens are necessary for managing user sessions. The access token
  /// is used for authenticated requests, and the refresh token is used to
  /// obtain a new access token when the current one expires.
  /// 
  /// {@macro session_response}
  SessionResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  /// The access token used for making authenticated requests.
  final String accessToken;

  /// The refresh token used to obtain a new access token when the current one expires.
  final String refreshToken;

  /// Creates a copy of the current [SessionResponse] object with the option to
  /// override the values of [accessToken] and [refreshToken].
  ///
  /// If a value is not provided, it defaults to the current instance's value.
  ///
  /// Example usage:
  /// ```dart
  /// SessionResponse updatedResponse = sessionResponse.copyWith(accessToken: "newAccessToken");
  /// ```
  /// 
  /// {@macro session_response}
  SessionResponse copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return SessionResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  /// A factory constructor that creates a [SessionResponse] object from a JSON map.
  ///
  /// The [json] parameter is expected to contain keys for "access_token" and "refresh_token".
  ///
  /// If either token is missing from the JSON, it defaults to an empty string.
  /// 
  /// {@macro session_response}
  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      accessToken: json["access_token"] ?? "",
      refreshToken: json["refresh_token"] ?? "",
    );
  }

  /// Converts the current [SessionResponse] object into a JSON map that can
  /// be serialized.
  ///
  /// The resulting JSON map contains the keys "access_token" and "refresh_token".
  /// 
  /// {@macro session_response}
  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };

  /// A factory constructor that returns an empty [SessionResponse] object.
  ///
  /// Both the access token and refresh token are set to empty strings, which
  /// can be useful for initializing empty states.
  /// 
  /// {@macro session_response}
  factory SessionResponse.empty() {
    return SessionResponse(accessToken: "", refreshToken: "");
  }
}