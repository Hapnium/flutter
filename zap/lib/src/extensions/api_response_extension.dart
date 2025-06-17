import '../models/api_response.dart';


extension ApiResponseExtension on ApiResponse<dynamic> {
  /// Extension on [ApiResponse] that allows converting a generic
  /// `ApiResponse<dynamic>` into a more strongly typed `ApiResponse<T>`.
  ///
  /// This is useful when the response data is parsed dynamically (e.g. from JSON)
  /// but the consuming code requires a specific data type. Instead of manually
  /// creating a new `ApiResponse<T>`, this extension simplifies the conversion.
  ///
  /// ### Example
  /// ```dart
  /// final rawResponse = ApiResponse<dynamic>(
  ///   status: true,
  ///   message: "Success",
  ///   data: rawJsonData, // dynamic at this point
  ///   code: 200,
  /// );
  ///
  /// final typedResponse = rawResponse.resolvedAs<User>();
  /// final user = typedResponse.data; // Now typed as User
  /// ```
  ///
  /// ⚠️ **Important:** Ensure that the dynamic `data` can be safely cast to type `T`.
  /// A runtime error will occur if the cast is invalid.
  ApiResponse<T> resolvedAs<T>() {
    return ApiResponse<T>(
      status: status,
      message: message,
      data: data as T,
      code: code,
    );
  }
}