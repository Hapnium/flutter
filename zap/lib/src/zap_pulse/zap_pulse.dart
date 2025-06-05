import 'package:tracing/tracing.dart' show console;
import 'package:zap/src/definitions.dart';
import 'package:zap/src/models/api_response.dart';
import '../exceptions/exceptions.dart';
import '../http/response/response.dart';
import '../models/zap_pulse_config.dart';
import '../models/session_response.dart';
import '../models/zap_cancel_token.dart';
import '../zap.dart';
import 'zap_pulse_interface.dart';

/// Type definition for request executor function with cancellation support
typedef _RequestExecutor<T> = Future<ZapResponse<ApiResponse<T>>> Function(Headers headers, ZapCancelToken? cancelToken);

/// ZapPulse is a high-level HTTP client wrapper that provides authentication,
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
/// final cancelToken = ZapCancelToken();
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
class ZapPulse implements ZapPulseInterface {
  /// Configuration object containing all settings for the ZapPulse client.
  /// 
  /// This includes authentication settings, logging preferences, session callbacks,
  /// timeout configurations, and the underlying Zap client configuration.
  /// The config is immutable after initialization to ensure consistent behavior.
  final ZapPulseConfig config;

  /// Private constructor to enforce singleton pattern
  ZapPulse._internal({required this.config});

  /// Static instance holder for singleton pattern
  static ZapPulse? _instance;

  /// Factory constructor that implements singleton pattern.
  /// 
  /// Throws [ZapException] if an instance already exists with different configuration.
  /// This ensures that only one ZapPulse instance exists throughout the application.
  factory ZapPulse({required ZapPulseConfig config}) {
    if (_instance != null) {
      throw ZapException(
        "Multiple instances of ZapPulse detected. Only one instance is allowed. "
        "Use ZapPulse.instance to access the existing instance or call ZapPulse.dispose() "
        "before creating a new instance."
      );
    }
    _instance = ZapPulse._internal(config: config);
    return _instance!;
  }

  /// Gets the current singleton instance.
  /// 
  /// Throws [ZapException] if no instance has been created yet.
  static ZapPulse get instance {
    if (_instance == null) {
      throw ZapException(
        "No ZapPulse instance found. Create an instance first using ZapPulse(config: config)."
      );
    }
    return _instance!;
  }

  /// Disposes the current singleton instance, allowing a new one to be created.
  static void dispose() {
    _instance?._client?.dispose();
    _instance = null;
  }

  /// Cancels all active requests using Zap's cancellation mechanism.
  static void cancelAllRequests([String reason = 'All requests cancelled']) {
    if (_instance != null) {
      _instance!._zapClient.cancelAllRequests(reason);
    }
  }

  /// Lazy-initialized Zap client instance
  Zap? _client;

  /// Gets the underlying Zap HTTP client, initializing it if necessary
  Zap get _zapClient => _client ??= Zap(config: config.zapConfig);

  /// Gets the current session, always fetching the latest from the session factory.
  /// 
  /// This ensures that the session is always up-to-date by calling the session
  /// callback function if provided, otherwise returns the static session from config.
  SessionResponse? get _currentSession {
    if (config.sessionFactory != null) {
      return config.sessionFactory!();
    }
    return config.session;
  }

  /// Validates authentication requirements for the request.
  /// 
  /// Throws [ZapException] if authentication is required but no session is available.
  void _checkAuth(bool useAuth) {
    if (useAuth && _currentSession == null) {
      throw ZapException(
        "Session is required to continue with authenticated requests. "
        "Please provide a valid session in the config or through sessionFactory callback."
      );
    }
  }

  /// Builds authentication headers based on the configuration.
  /// 
  /// This method supports three modes:
  /// 1. Custom header builder function (highest priority)
  /// 2. Configurable header name and token prefix
  /// 3. Default Authorization: Bearer format
  /// 
  /// Examples of generated headers:
  /// - `Authorization: Bearer abc123` (default)
  /// - `Authorization: Goog abc123` (Google style)
  /// - `X-API-Key: abc123` (API key style with empty prefix)
  /// - Multiple custom headers via customAuthHeaderBuilder
  Map<String, String> _buildAuthHeaders(SessionResponse session) {
    // Use custom auth header builder if provided
    if (config.customAuthHeaderBuilder != null) {
      return config.customAuthHeaderBuilder!(session);
    }
    
    // Use configurable header name and token prefix
    final token = session.accessToken;
    if (token.isEmpty) {
      return {};
    }
    
    final headerValue = config.tokenPrefix.isEmpty ? token : '${config.tokenPrefix} $token';
    
    return {config.authHeaderName: headerValue};
  }

  /// Adds authentication headers to the request if authentication is enabled.
  /// 
  /// This method fetches the current session and builds the appropriate auth headers
  /// based on the configuration. It also includes any additional headers from config.
  Map<String, String> _buildHeaders(bool useAuth, [Map<String, String>? additionalHeaders]) {
    final headers = <String, String>{};
    
    // Add base headers from config
    if (config.headers != null) {
      headers.addAll(config.headers!);
    }
    
    // Add authentication headers if required
    if (useAuth) {
      final session = _currentSession;
      if (session != null) {
        final authHeaders = _buildAuthHeaders(session);
        headers.addAll(authHeaders);
        
        if (config.showRequestLogs && authHeaders.isNotEmpty) {
          console.log('ZapPulse: Added auth headers: ${authHeaders.keys.join(', ')}');
        }
      }
    }
    
    // Add any additional headers passed to the method
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  /// Handles session refresh when authentication fails.
  /// 
  /// This method is called when a request returns 401 Unauthorized.
  /// It attempts to refresh the session using the provided callback.
  Future<SessionResponse?> _handleSessionRefresh() async {
    if (config.onSessionRefreshed != null) {
      try {
        final newSession = await config.onSessionRefreshed!();
        if (config.showResponseLogs) {
          console.log('ZapPulse: Session refreshed successfully');
        }
        return newSession;
      } catch (e) {
        if (config.showErrorLogs) {
          console.log('ZapPulse: Session refresh failed: $e');
        }
        return null;
      }
    }
    return null;
  }

  /// Logs request information if request logging is enabled.
  void _logRequest(String method, String endpoint, Map<String, dynamic>? query) {
    if (config.showRequestLogs) {
      console.log('ZapPulse Request: $method $endpoint');
      if (query != null && query.isNotEmpty) {
        console.log('ZapPulse Query: $query');
      }
    }
  }

  /// Logs response information if response logging is enabled.
  void _logResponse<T>(ZapResponse<ApiResponse<T>> response) {
    if (config.showResponseLogs) {
      console.log('ZapPulse Response: ${response.statusCode} - ${response.body?.status} - ${response.body?.message}');
    }
  }

  /// Creates a decoder function for ApiResponse with custom data parsing.
  ResponseDecoder<ApiResponse<T>> _createDecoder<T>(DataParser<T>? parser) {
    return (dynamic responseData) {
      final response = ApiResponse.fromJson(responseData);
      
      if (parser != null && response.data != null) {
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
            console.log('ZapPulse Parser Error: $e');
          }
          return ApiResponse<T>.error('Failed to parse response data: $e');
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

  /// Retries a request after session refresh.
  Future<ZapResponse<ApiResponse<T>>> _retryRequest<T>(bool useAuth, _RequestExecutor<T> requestExecutor, ZapCancelToken? cancelToken) async {
    final newSession = await _handleSessionRefresh();

    if (newSession != null) {
      // Retry the request with new session
      final headers = _buildHeaders(useAuth);
      final response = await requestExecutor(headers, cancelToken);
      _logResponse(response);
      return response;
    }

    // Create unauthorized response
    return ZapResponse<ApiResponse<T>>(
      statusCode: 401,
      statusText: 'Unauthorized',
      headers: {},
      body: ApiResponse<T>.error('Unable to complete request due to authentication failure'),
    );
  }

  /// Executes an HTTP request with authentication and error handling.
  /// 
  /// This method handles the common flow for all HTTP methods:
  /// 1. Validates authentication requirements
  /// 2. Builds headers with configurable authentication
  /// 3. Executes the request
  /// 4. Handles 401 errors with session refresh
  /// 5. Logs request/response if enabled
  /// 6. Parses response data using provided parser
  Future<ZapResponse<ApiResponse<T>>> _execute<T>(_RequestExecutor<T> requestExecutor, String method, String endpoint, bool useAuth, ZapCancelToken? cancelToken) async {
    _checkAuth(useAuth);
    _logRequest(method, endpoint, null);

    try {
      final headers = _buildHeaders(useAuth);
      final response = await requestExecutor(headers, cancelToken);
      
      // Handle 401 Unauthorized - attempt session refresh
      if (response.statusCode == 401 && useAuth) {
        return await _retryRequest(useAuth, requestExecutor, cancelToken);
      }

      _logResponse(response);
      return response;
    } catch (e) {
      if (config.showErrorLogs) {
        console.log('ZapPulse Error: $e');
      }
      
      // Return error response
      return ZapResponse<ApiResponse<T>>(
        statusCode: 500,
        statusText: 'Internal Error',
        body: ApiResponse<T>.error(e is ZapException ? e.message : e.toString()),
      );
    }
  }

  @override
  Future<ZapResponse<ApiResponse<T>>> delete<T>({required String endpoint, RequestParam? query, dynamic body, bool useAuth = true, DataParser<T>? parser, ZapCancelToken? token}) async {
    return _execute<T>((headers, cancelToken) => _zapClient.delete<ApiResponse<T>>(endpoint, headers: headers, query: query, decoder: _createDecoder<T>(parser), cancelToken: cancelToken), 'DELETE', endpoint, useAuth, token);
  }

  @override
  Future<ZapResponse<ApiResponse<T>>> get<T>({required String endpoint, RequestParam? query, bool useAuth = true, DataParser<T>? parser, ZapCancelToken? token}) async {
    return _execute<T>((headers, cancelToken) => _zapClient.get<ApiResponse<T>>(endpoint, headers: headers, query: query, decoder: _createDecoder<T>(parser), cancelToken: cancelToken), 'GET', endpoint, useAuth, token);
  }

  @override
  Future<ZapResponse<ApiResponse<T>>> patch<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, DataParser<T>? parser, ZapCancelToken? token}) async {
    return _execute<T>((headers, cancelToken) => _zapClient.patch<ApiResponse<T>>(endpoint, body, headers: headers, query: query, decoder: _createDecoder<T>(parser), uploadProgress: onProgress, cancelToken: cancelToken), 'PATCH', endpoint, useAuth, token);
  }

  @override
  Future<ZapResponse<ApiResponse<T>>> post<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, DataParser<T>? parser, ZapCancelToken? token}) async {
    return _execute<T>((headers, cancelToken) => _zapClient.post<ApiResponse<T>>(endpoint, body, headers: headers, query: query, decoder: _createDecoder<T>(parser), uploadProgress: onProgress, cancelToken: cancelToken), 'POST', endpoint, useAuth, token);
  }

  @override
  Future<ZapResponse<ApiResponse<T>>> put<T>({required String endpoint, dynamic body, RequestParam? query, Progress? onProgress, bool useAuth = true, DataParser<T>? parser, ZapCancelToken? token}) async {
    return _execute<T>((headers, cancelToken) => _zapClient.put<ApiResponse<T>>(endpoint, body, headers: headers, query: query, decoder: _createDecoder<T>(parser), uploadProgress: onProgress, cancelToken: cancelToken), 'PUT', endpoint, useAuth, token);
  }
}