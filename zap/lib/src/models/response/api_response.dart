/// {@template api_response}
/// A generic class to handle API responses. This class encapsulates the
/// structure of a standard API response, including a status, code, message,
/// and optional data of type [T].
///
/// This class can be used for both successful and error responses, and it
/// includes utility methods for checking response status and parsing JSON data.
/// 
/// {@endtemplate}
class ApiResponse {
  /// The status of the API response, typically a string that describes the
  /// outcome (e.g., "success", "error").
  final String status;

  /// The HTTP status code returned by the API (e.g., 200 for OK, 404 for Not Found).
  final int code;

  /// A message providing more details about the response, such as an error
  /// description or success message.
  final String message;

  /// The actual data returned by the API. The type of this data is determined by [T].
  /// It can be `null` if no data is returned or in case of an error.
  final dynamic data;

  /// Constructor for creating an [ApiResponse] instance with the provided
  /// [status], [code], [message], and optional [data].
  /// 
  /// {@macro api_response}
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

  /// A factory method to create an [ApiResponse] object from a JSON map.
  ///
  /// The [json] parameter is expected to contain the keys `status`, `code`,
  /// `message`, and optionally `data`.
  ///
  /// Returns an [ApiResponse] instance with parsed fields from the map.
  /// 
  /// {@macro api_response}
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? "",
      code: json['code'] ?? 400,
      message: json['message'] ?? "Couldn't validate request",
      data: json['data'],
    );
  }

  /// Creates a copy of this [ApiResponse] with the specified properties replaced.
  ///
  /// This method is useful for creating a modified copy of an existing response
  /// without altering the original instance.
  ///
  /// Returns a new [ApiResponse] instance with updated fields where provided.
  /// 
  /// {@macro api_response}
  ApiResponse copyWith({
    String? status,
    int? code,
    String? message,
    dynamic data,
  }) {
    return ApiResponse(
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// Creates an [ApiResponse] instance representing an error.
  ///
  /// This is a convenience factory for quickly returning a generic error response.
  ///
  /// - [message]: A description of the error.
  /// 
  /// {@macro api_response}
  factory ApiResponse.error(String message) =>
      ApiResponse(status: "error", code: 400, message: message);

  /// Creates an [ApiResponse] instance representing an unauthorized access attempt.
  ///
  /// This is a convenience factory for returning an unauthorized error response (HTTP 401).
  ///
  /// - [message]: A message indicating the unauthorized access.
  /// 
  /// {@macro api_response}
  factory ApiResponse.unauthorized(String message) =>
      ApiResponse(status: "unauthorized", code: 401, message: message);

  /// Converts the [ApiResponse] object into a JSON map.
  ///
  /// Returns a `Map<String, dynamic>` suitable for encoding into JSON.
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data,
    };
  }

  /// Parses and returns the `data` field using a custom parser function.
  ///
  /// This is useful when you expect the `data` to be of a specific type [T] and
  /// want to transform it accordingly.
  ///
  /// - [parser]: A function that takes a `dynamic` value and returns a value of type [T].
  ///
  /// Example:
  /// ```dart
  /// final user = response.resolvedAs<User>((json) => User.fromJson(json));
  /// ```
  T resolvedAs<T>(T Function(dynamic) parser) {
    return parser(data);
  }

  /// Parses and returns the `data` field as a list of items of type [T].
  ///
  /// If the `data` is not a list, an empty list is returned.
  ///
  /// - [parser]: A function that takes a `dynamic` item and returns an item of type [T].
  ///
  /// Example:
  /// ```dart
  /// final users = response.resolvedListAs<User>((json) => User.fromJson(json));
  /// ```
  List<T> resolvedListAs<T>(T Function(dynamic) parser) {
    if (data is List) {
      return (data as List).map((e) => parser(e)).toList();
    }
    return [];
  }
}