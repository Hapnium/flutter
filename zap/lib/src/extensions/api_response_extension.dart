import '../http/response/response.dart';
import '../models/response/api_response.dart';

/// An extension on [Response<ApiResponse>] that provides convenient accessors
/// for common properties used in API response handling.
extension ApiResponseExtension on Response<ApiResponse> {
  /// Retrieves the most relevant message from the API response.
  ///
  /// This getter prioritizes the `message` field inside the [ApiResponse] body.
  /// If the body is `null` or does not contain a message, it falls back to the
  /// top-level `message` property of the [Response] object itself.
  ///
  /// This is especially useful when you want to display user-friendly messages
  /// in UI or logs without needing to manually check multiple levels.
  ///
  /// Example:
  /// ```dart
  /// final message = response.detailedMessage;
  /// print(message); // Outputs either ApiResponse.message or Response.message
  /// ```
  String get detailedMessage => body?.message ?? message;
}