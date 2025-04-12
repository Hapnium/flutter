import 'package:connectify/connectify.dart';

/// A generic class to handle API responses. This class encapsulates the
/// structure of a standard API response, including a status, code, message,
/// and optional data of type [T].
class ApiResponse<T> {
  /// The status of the API response, typically a string that describes the
  /// outcome (e.g., "success", "error").
  String status;

  /// The HTTP status code returned by the API (e.g., 200 for OK, 404 for Not Found).
  int code;

  /// A message providing more details about the response, such as an error
  /// description or success message.
  String message;

  /// The actual data returned by the API. The type of this data is determined by [T].
  /// It can be `null` if no data is returned or in case of an error.
  T? data;

  /// Constructor for creating an [ApiResponse] instance with the provided
  /// [status], [code], [message], and optional [data].
  ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  /// Returns `true` if the HTTP status code is 200, indicating a successful response.
  bool get isOk => code == 200 || isCreated;

  /// Returns `true` if the HTTP status code is 201, indicating that a resource
  /// has been successfully created.
  bool get isCreated => code == 201;

  /// Returns `true` if the HTTP status code is between 200 and 299, inclusive,
  /// indicating a successful response.
  bool get isSuccessful => code >= 200 && code <= 299;

  /// Returns `true` if the error data indicates that the session has expired.
  bool get isExpiredSession => data != null && data == "S10";

  /// Returns `true` if the error data indicates that the token provided is incorrect.
  bool get isIncorrectToken => data != null && data == "S20";

  /// Returns `true` if the error data indicates that access has been denied.
  bool get isAccessDenied => data != null && data == "S50";

  /// Returns `true` if the error data indicates that the user was not found.
  bool get isUserNotFound => data != null && data == "S40";

  /// Returns `true` if the error data indicates that the email has not been verified.
  bool get isEmailNotVerified => data != null && data == "S80";

  /// Returns `true` if the error data indicates that the user's profile is not set.
  bool get isProfileNotSet => data != null && data == "S90";

  /// Returns `true` if the error data indicates that the user's signup is incomplete.
  bool get isSignupIncomplete => data != null && data == "S900";

  /// Returns `true` if the error data indicates that the account is disabled.
  bool get isAccountDisabled => data != null && data == "S12";

  /// Returns `true` if the error data indicates that the account is locked.
  bool get isAccountLocked => data != null && data == "S11";

  /// Returns `true` if the error data indicates that the user is currently
  /// on an active guest trip.
  bool get isGuestOnTrip => data != null && data == "S111";

  /// Returns `true` if the error data indicates that the user can end the call.
  bool get canEndCall => data != null && data == "S65";

  /// A factory method to create an [ApiResponse] object from a JSON map.
  /// The [json] parameter is expected to contain the keys `status`, `code`,
  /// `message`, and optionally `data`.
  ///
  /// Throws a [ConnectifyException] if the response indicates that the account
  /// is disabled or locked.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    ApiResponse<T> response = ApiResponse(
      status: json['status'] ?? "",
      code: json['code'] ?? 400,
      message: json['message'] ?? "Couldn't validate request",
      data: json['data'],
    );

    // Throw an exception if the account is either disabled or locked.
    if (response.isAccountDisabled || response.isAccountLocked) {
      throw ConnectifyException(response.message, isLocked: true);
    }

    return response;
  }

  factory ApiResponse.error(String message) {
    ApiResponse<T> response = ApiResponse(status: "", code: 400, message: message);

    // Throw an exception if the account is either disabled or locked.
    if (response.isAccountDisabled || response.isAccountLocked) {
      throw ConnectifyException(response.message, isLocked: true);
    }

    return response;
  }

  /// Converts the [ApiResponse] object into a JSON map, including the `status`,
  /// `code`, `message`, and `data` fields.
  ///
  /// Returns a `Map<String, dynamic>` that can be serialized to JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}