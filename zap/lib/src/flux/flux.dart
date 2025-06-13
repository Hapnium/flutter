import 'package:tracing/tracing.dart' show console;

import '../definitions.dart';
import '../models/api_response.dart';
import '../core/zap_interface.dart';
import '../exceptions/exceptions.dart';
import '../http/response/response.dart';
import '../http/utils/http_status.dart';
import '../models/response_parser.dart';
import '../models/flux_config.dart';
import '../models/cancel_token.dart';
import 'flux_interface.dart';
import 'extension.dart';
import 'client.dart';

/// Flux is a high-level HTTP client wrapper that provides authentication,
/// session management, and standardized API response handling.
/// 
/// This class implements a singleton pattern and leverages Zap's built-in
/// cancellation support for robust request management.
/// 
/// Key features:
/// - Singleton pattern implementation
/// - Configurable authentication headers
/// - Generic type support with custom parsers
/// - Automatic session token management
/// - Request/response logging
/// - Error handling with session refresh
/// - Progress tracking for uploads/downloads
/// - Request cancellation support (via Zap)
/// 
/// Example usage:
/// ```dart
/// // Simple string response
/// final response = await pulse.get<String>(
///   endpoint: '/users/profile',
///   parser: (data) => data.toString(),
/// );
/// 
/// // Custom model parsing
/// final userResponse = await pulse.get<User>(
///   endpoint: '/users/profile',
///   parser: (data) => User.fromJson(data),
/// );
/// 
/// // Simple request with cancellation
/// final cancelToken = CancelToken();
/// final response = await pulse.get<String>(
///   endpoint: '/users/profile',
///   parser: (data) => data.toString(),
///   cancelToken: cancelToken,
/// );
/// 
/// // Cancel the request if needed
/// cancelToken.cancel('User navigated away');
/// 
/// // With progress tracking
/// final uploadResponse = await pulse.post<UploadResult>(
///   endpoint: '/upload',
///   body: fileData,
///   parser: (data) => UploadResult.fromJson(data),
///   onProgress: (uploaded) {
///     console.log('Progress: ${(uploaded*100).toStringAsFixed(1)}%');
///   },
/// );
/// ```
final class Flux implements FluxInterface {
  /// Configuration object containing all settings for the Flux client.
  /// 
  /// This includes authentication settings, logging preferences, session callbacks,
  /// timeout configurations, and the underlying Zap client configuration.
  /// The config is immutable after initialization to ensure consistent behavior.
  final FluxConfig config;

  /// Private constructor to enforce singleton pattern
  Flux._internal({required this.config});

  /// Static instance holder for singleton pattern
  static Flux? _instance;

  /// Factory constructor that implements singleton pattern.
  /// 
  /// Throws [ZapException] if an instance already exists with different configuration.
  /// This ensures that only one Flux instance exists throughout the application.
  factory Flux({required FluxConfig config}) {
    if (_instance != null) {
      throw ZapException(
        "Multiple instances of Flux detected. Only one instance is allowed. "
        "Use Flux.instance to access the existing instance or call Flux.dispose() "
        "before creating a new instance."
      );
    }
    _instance = Flux._internal(config: config);
    return _instance!;
  }

  /// Gets the current singleton instance.
  /// 
  /// Throws [ZapException] if no instance has been created yet.
  static Flux get instance {
    if (_instance == null) {
      throw ZapException("No Flux instance found. Create an instance first using Flux(config: config).");
    }
    return _instance!;
  }

  /// Disposes the current singleton instance, allowing a new one to be created.
  static void dispose() {
    _instance?._client().onDelete();
    _instance?._client().dispose();
    _instance = null;
  }

  /// Cancels all active requests using Zap's cancellation mechanism.
  static void cancelAllRequests([String reason = 'All requests cancelled']) {
    if (_instance != null) {
      _instance!._client().cancelAllRequests(reason);
    }
  }

  /// Gets the underlying Zap HTTP client
  ZapInterface _client([bool useAuth = false]) => fluxClient(config, useAuth);

  /// Creates a decoder function for ApiResponse with custom data parsing.
  ResponseDecoder<ApiResponse<T>> _createDecoder<T>(ResponseParser<T>? parserConfig) {
    return (HttpStatus status, dynamic responseData) {
      final response = ApiResponse.fromJson(responseData);

      if (parserConfig != null && response.data != null) {
        // Use the getParser helper method to find the appropriate parser
        final parser = parserConfig.getParser(HttpStatus.fromCode(response.code));

        if (parser != null) {
          try {
            final parsedData = parser(response.data);
            return ApiResponse<T>(
              status: response.status,
              message: response.message,
              data: parsedData,
              code: response.code,
            );
          } catch (e) {
            if (config.showErrorLogs) {
              console.log('Flux Parser Error for status ${response.code}: $e');
            }
            return ApiResponse<T>.error('Failed to parse response data for status ${response.code}: $e');
          }
        }
      }

      return ApiResponse<T>(
        status: response.status,
        message: response.message,
        data: response.data as T?,
        code: response.code,
      );
    };
  }

  @override
  Future<Response<ApiResponse<T>>> delete<T>({required String endpoint, RequestParam? query, dynamic body, bool useAuth = true, ResponseParser<T>? parser, CancelToken? token}) async {
    try {
      return config.execute<T>((Headers? headers, CancelToken? cancelToken) => _client(useAuth).delete<ApiResponse<T>>(
        endpoint,
        headers: headers, 
        query: query, 
        decoder: _createDecoder<T>(parser), 
        cancelToken: cancelToken
      ), 'DELETE', endpoint, useAuth, token);
    } finally {
      if(config.disposeOnCompleted) {
        dispose();
      }
    }
  }

  @override
  Future<Response<ApiResponse<T>>> get<T>({required String endpoint, RequestParam? query, bool useAuth = true, ResponseParser<T>? parser, CancelToken? token}) async {
    try {
      return config.execute<T>((Headers? headers, CancelToken? cancelToken) => _client(useAuth).get<ApiResponse<T>>(
        endpoint,
        headers: headers, 
        query: query, 
        decoder: _createDecoder<T>(parser), 
        cancelToken: cancelToken
      ), 'GET', endpoint, useAuth, token);
    } finally {
      if(config.disposeOnCompleted) {
        dispose();
      }
    }
  }

  @override
  Future<Response<ApiResponse<T>>> patch<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, ResponseParser<T>? parser, CancelToken? token}) async {
    try {
      return config.execute<T>((Headers? headers, CancelToken? cancelToken) => _client(useAuth).patch<ApiResponse<T>>(
        endpoint, 
        body, 
        headers: headers, 
        query: query, 
        decoder: _createDecoder<T>(parser), 
        uploadProgress: onProgress, 
        cancelToken: cancelToken
      ), 'PATCH', endpoint, useAuth, token);
    } finally {
      if(config.disposeOnCompleted) {
        dispose();
      }
    }
  }

  @override
  Future<Response<ApiResponse<T>>> post<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, ResponseParser<T>? parser, CancelToken? token}) async {
    try {
      return config.execute<T>((Headers? headers, CancelToken? cancelToken) => _client(useAuth).post<ApiResponse<T>>(
        endpoint, 
        body, 
        headers: headers, 
        query: query, 
        decoder: _createDecoder<T>(parser), 
        uploadProgress: onProgress, 
        cancelToken: cancelToken
      ), 'POST', endpoint, useAuth, token);
    } finally {
      if(config.disposeOnCompleted) {
        dispose();
      }
    }
  }

  @override
  Future<Response<ApiResponse<T>>> put<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, ResponseParser<T>? parser, CancelToken? token}) async {
    try {
      return config.execute<T>((Headers? headers, CancelToken? cancelToken) => _client(useAuth).put<ApiResponse<T>>(
        endpoint, 
        body, 
        headers: headers, 
        query: query, 
        decoder: _createDecoder<T>(parser), 
        uploadProgress: onProgress, 
        cancelToken: cancelToken
      ), 'PUT', endpoint, useAuth, token);
    } finally {
      if(config.disposeOnCompleted) {
        dispose();
      }
    }
  }
}