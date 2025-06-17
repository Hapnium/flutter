import '../definitions.dart';
import '../models/response/api_response.dart';
import '../models/cancel_token.dart';
import '../http/response/response.dart';

/// Interface defining the contract for Flux HTTP operations.
/// 
/// This interface ensures consistent method signatures across different
/// implementations of the Flux client.
abstract class FluxInterface {
  /// Performs a GET request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for download tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [Response] containing an [ApiResponse] with parsed data of type T.
  Future<Response<ApiResponse>> get({required String endpoint, RequestParam? query, bool useAuth = true, CancelToken? token});

  /// Performs a POST request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [Response] containing an [ApiResponse] with parsed data of type T.
  Future<Response<ApiResponse>> post({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    CancelToken? token,
  });

  /// Performs a PUT request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [Response] containing an [ApiResponse] with parsed data of type T.
  Future<Response<ApiResponse>> put({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    CancelToken? token,
  });

  /// Performs a PATCH request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [Response] containing an [ApiResponse] with parsed data of type T.
  Future<Response<ApiResponse>> patch({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    CancelToken? token,
  });

  /// Performs a DELETE request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [query]: Optional query parameters
  /// - [body]: Optional request body data
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [Response] containing an [ApiResponse] with parsed data of type T.
  Future<Response<ApiResponse>> delete({required String endpoint, RequestParam? query, RequestBody body, bool useAuth = true, CancelToken? token});
}