import 'package:dio/src/dio_exception.dart';

import '../../exception/connectify_exception.dart';
import '../../models/api_response.dart';
import '../error_handler_service.dart';

class ConnectifyErrorHandler<T> implements ErrorHandlerService<T> {
  @override
  ApiResponse<T> handleDioException(DioException exception) {
    String message = "";
    int? statusCode = exception.response?.statusCode;
    String? statusMessage = exception.response?.statusMessage;

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        message = "Connection timed out. Please try again.";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send request timed out. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Response timed out. Please try again.";
        break;
      case DioExceptionType.badResponse:
        int? statusCode = exception.response?.statusCode;
        message = exception.response?.statusMessage ?? "An error occurred.";

        if (statusCode == 400) {
          message = "Bad request. Please check your input.";
        } else if (statusCode == 401) {
          message = "Unauthorized. Please log in again.";
        } else if (statusCode == 403) {
          message = "Forbidden. You do not have access to this resource.";
        } else if (statusCode == 404) {
          message = "Resource not found.";
        } else if (statusCode == 500) {
          message = "Server error. Please try again later.";
        }

        break;
      case DioExceptionType.cancel:
        message = "Request was cancelled.";
        break;
      case DioExceptionType.connectionError:
        message = "Network error. Please check your internet connection.";
        break;
      case DioExceptionType.unknown:
      default:
        message = "An unexpected error occurred.";
        break;
    }

    if(exception.response != null) {
      try {
        return ApiResponse<T>.fromJson(exception.response?.data);
      } catch (_) {
        return ApiResponse<T>(status: statusMessage ?? "", code: statusCode ?? 400, message: message);
      }
    }

    return ApiResponse<T>(status: statusMessage ?? "", code: statusCode ?? 400, message: message);
  }

  @override
  ApiResponse<T> handleError(Object error) {
    return ApiResponse<T>(
      status: error.toString(),
      code: 400,
      message: "An error occurred while sending your request. If this continues, contact support"
    );
  }

  @override
  ApiResponse<T> handleException(Exception exception) {
    return ApiResponse<T>(
      status: exception.toString(),
      code: 400,
      message: "An error occurred while sending your request. If this continues, contact support"
    );
  }

  @override
  ApiResponse<T> handleStackTrace(StackTrace trace) {
    return ApiResponse<T>(
      status: trace.toString(),
      code: 400,
      message: "An error occurred while sending your request. If this continues, contact support"
    );
  }

  @override
  ApiResponse<T> handleConnectifyException(ConnectifyException exception) {
    return ApiResponse<T>(
      status: exception.toString(),
      code: 400,
      message: exception.message,
    );
  }
}