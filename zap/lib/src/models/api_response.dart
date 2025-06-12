import 'response_parser.dart';

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

  /// A factory method to create an [ApiResponse] object from a JSON map.
  /// The [json] parameter is expected to contain the keys `status`, `code`,
  /// `message`, and optionally `data`.
  /// 
  /// The [parser] parameter is an optional [DataParser] function that can be used to parse the `data` field.
  factory ApiResponse.fromJson(Map<String, dynamic> json, [DataParser<T>? parser]) {
    ApiResponse<T> response = ApiResponse(
      status: json['status'] ?? "",
      code: json['code'] ?? 400,
      message: json['message'] ?? "Couldn't validate request",
      data: parser != null && json['data'] != null ? parser(json['data']) : json['data'],
    );

    return response;
  }

  /// Creates a copy of this [ApiResponse] with the specified properties replaced.
  /// 
  /// This method returns a new [ApiResponse] instance with the same properties
  /// as this instance, except for the properties that are specified in the
  /// [copyWith] method.
  ApiResponse<T> copyWith({
    String? status,
    int? code,
    String? message,
    T? data,
  }) {
    return ApiResponse(
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// Creates an [ApiResponse] object with a status of "error" and the specified message.
  /// 
  /// This factory method is a convenience method for creating an [ApiResponse]
  /// with a status of "error" and the specified message.
  factory ApiResponse.error(String message) =>  ApiResponse(status: "", code: 400, message: message);

  /// Creates an [ApiResponse] object with a status of "unauthorized" and the specified message.
  /// 
  /// This factory method is a convenience method for creating an [ApiResponse]
  /// with a status of "unauthorized" and the specified message.
  factory ApiResponse.unauthorized(String message) =>  ApiResponse(status: "", code: 401, message: message);

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