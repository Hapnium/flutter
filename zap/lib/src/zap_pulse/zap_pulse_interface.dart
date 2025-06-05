import 'package:zap/src/definitions.dart';
import 'package:zap/src/models/api_response.dart';
import 'package:zap/src/models/zap_cancel_token.dart';

import '../http/response/response.dart';
import '../models/zap_parser_config.dart';

/// Interface defining the contract for ZapPulse HTTP operations.
/// 
/// This interface ensures consistent method signatures across different
/// implementations of the ZapPulse client.
abstract class ZapPulseInterface {
  /// Performs a GET request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for download tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [parser]: Optional function to parse the response data to type T
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [ZapResponse] containing an [ApiResponse] with parsed data of type T.
  Future<ZapResponse<ApiResponse<T>>> get<T>({required String endpoint, RequestParam? query, bool useAuth = true, ZapDataParser<T>? parser, ZapCancelToken? token});

  /// Performs a POST request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [parser]: Optional function to parse the response data to type T
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [ZapResponse] containing an [ApiResponse] with parsed data of type T.
  Future<ZapResponse<ApiResponse<T>>> post<T>({
    required String endpoint,
    dynamic body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    ZapDataParser<T>? parser,
    ZapCancelToken? token,
  });

  /// Performs a PUT request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [parser]: Optional function to parse the response data to type T
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [ZapResponse] containing an [ApiResponse] with parsed data of type T.
  Future<ZapResponse<ApiResponse<T>>> put<T>({
    required String endpoint,
    dynamic body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    ZapDataParser<T>? parser,
    ZapCancelToken? token,
  });

  /// Performs a PATCH request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [body]: The request body data
  /// - [query]: Optional query parameters
  /// - [onProgress]: Optional progress callback for upload tracking
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [parser]: Optional function to parse the response data to type T
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [ZapResponse] containing an [ApiResponse] with parsed data of type T.
  Future<ZapResponse<ApiResponse<T>>> patch<T>({
    required String endpoint,
    dynamic body,
    RequestParam? query,
    Progress? onProgress,
    bool useAuth = true,
    ZapDataParser<T>? parser,
    ZapCancelToken? token,
  });

  /// Performs a DELETE request.
  /// 
  /// - [endpoint]: The API endpoint to call
  /// - [query]: Optional query parameters
  /// - [body]: Optional request body data
  /// - [useAuth]: Whether to include authentication headers (default: true)
  /// - [parser]: Optional function to parse the response data to type T
  /// - [token]: Optional cancellation token for request cancellation
  /// 
  /// Returns a [ZapResponse] containing an [ApiResponse] with parsed data of type T.
  Future<ZapResponse<ApiResponse<T>>> delete<T>({required String endpoint, RequestParam? query, dynamic body, bool useAuth = true, ZapDataParser<T>? parser, ZapCancelToken? token  });
}