import 'package:connectify/connectify.dart';

/// Abstract class to define the base structure for connecting to a service and performing HTTP requests.
///
/// @param <T> The type of response expected from the service.
abstract class ConnectifyService<T> {
  /// Sends a GET request to the specified endpoint.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param query Optional query parameters to include in the request.
  /// @param onReceiveProgress Optional callback to track the progress of receiving data.
  ///
  /// @return A `Future` that completes with an `ApiResponse` containing the result of the GET request.
  Future<ApiResponse<T>> get({required String endpoint, RequestParam? query, OnProgressCallback? onReceiveProgress});

  /// Sends a POST request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the POST request.
  /// @param query Optional query parameters to include in the request.
  /// @param onSendProgress Optional callback to track the progress of sending data.
  /// @param onReceiveProgress Optional callback to track the progress of receiving data.
  ///
  /// @return A `Future` that completes with an `ApiResponse` containing the result of the POST request.
  Future<ApiResponse<T>> post({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  });

  /// Sends a PATCH request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the PATCH request.
  /// @param query Optional query parameters to include in the request.
  /// @param onSendProgress Optional callback to track the progress of sending data.
  /// @param onReceiveProgress Optional callback to track the progress of receiving data.
  ///
  /// @return A `Future` that completes with an `ApiResponse` containing the result of the PATCH request.
  Future<ApiResponse<T>> patch({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  });

  /// Sends a PUT request to the specified endpoint with the given body.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param body The data to be sent in the body of the PUT request.
  /// @param query Optional query parameters to include in the request.
  /// @param onSendProgress Optional callback to track the progress of sending data.
  /// @param onReceiveProgress Optional callback to track the progress of receiving data.
  ///
  /// @return A `Future` that completes with an `ApiResponse` containing the result of the PUT request.
  Future<ApiResponse<T>> put({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  });

  /// Sends a DELETE request to the specified endpoint.
  ///
  /// @param endpoint The API endpoint to send the request to.
  /// @param query Optional query parameters to include in the request.
  /// @param body Optional data to be sent in the body of the DELETE request.
  /// @param onSendProgress Optional callback to track the progress of sending data.
  /// @param onReceiveProgress Optional callback to track the progress of receiving data.
  ///
  /// @return A `Future` that completes with an `ApiResponse` containing the result of the DELETE request.
  Future<ApiResponse<T>> delete({required String endpoint, RequestParam? query, RequestBody body});
}