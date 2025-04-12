import 'package:dio/dio.dart' show DioException;

import '../../connectify.dart';

/// An abstract service interface for handling errors and exceptions during API calls.
///
/// This interface defines a contract for services that handle various types of
/// errors and exceptions that can occur during network requests, converting
/// them into a standardized [ApiResponse] format.
///
/// Type parameter:
///
/// * [T]: The type of the data expected in a successful API response.
abstract class ErrorHandlerService<T> {
  /// Handles a generic error object.
  ///
  /// This method is used to process errors that are not specifically typed,
  /// such as errors caught in a `catch` block.
  ///
  /// **Parameters:**
  ///
  /// * `error`: The error object to handle.
  ///
  /// **Returns:**
  ///
  /// An [ApiResponse] object representing the error.
  ApiResponse<T> handleError(Object error);

  /// Handles a general Dart [Exception].
  ///
  /// This method is used to process standard Dart exceptions that might occur
  /// during API calls or data processing.
  ///
  /// **Parameters:**
  ///
  /// * `exception`: The exception to handle.
  ///
  /// **Returns:**
  ///
  /// An [ApiResponse] object representing the exception.
  ApiResponse<T> handleException(Exception exception);

  /// Handles a [DioException] specifically.
  ///
  /// This method is used to process exceptions thrown by the Dio HTTP client,
  /// providing detailed information about network errors.
  ///
  /// **Parameters:**
  ///
  /// * `exception`: The Dio exception to handle.
  ///
  /// **Returns:**
  ///
  /// An [ApiResponse] object representing the Dio exception.
  ApiResponse<T> handleDioException(DioException exception);

  /// Handles a [StackTrace] object.
  ///
  /// This method is used to process stack trace information, typically
  /// associated with an error or exception, for debugging and logging purposes.
  ///
  /// **Parameters:**
  ///
  /// * `trace`: The stack trace to handle.
  ///
  /// **Returns:**
  ///
  /// An [ApiResponse] object representing the stack trace.
  ApiResponse<T> handleStackTrace(StackTrace trace);

  /// Handles a [ConnectifyException].
  ///
  /// This method is used to process exceptions specifically related to the
  /// Connectify library or its related operations.
  ///
  /// **Parameters:**
  ///
  /// * `exception`: The Connectify exception to handle.
  ///
  /// **Returns:**
  ///
  /// An [ApiResponse] object representing the Connectify exception.
  ApiResponse<T> handleConnectifyException(ConnectifyException exception);
}