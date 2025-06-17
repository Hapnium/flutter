import 'package:tracing/tracing.dart' show console;

import '../definitions.dart';
import '../enums/exception_type.dart';
import '../exceptions/controller_advice.dart';
import '../exceptions/zap_exception.dart';
import '../models/api_response.dart';
import '../http/response/response.dart';
import '../http/utils/http_status.dart';
import '../models/flux_config.dart';
import '../models/session_response.dart';
import '../models/cancel_token.dart';

/// Type definition for request executor function with cancellation support
typedef RequestExecutor<T> = Future<Response<ApiResponse<T>>> Function(Headers? headers, CancelToken? cancelToken);

extension FluxConfigExtension on FluxConfig {
  /// Adviser instance for handling exceptions and logging.
  ControllerAdvice get _adviser => controllerAdvice ?? ControllerAdvice();
  
  /// Gets the current session, always fetching the latest from the session factory.
  /// 
  /// This ensures that the session is always up-to-date by calling the session
  /// callback function if provided, otherwise returns the static session from config.
  SessionResponse? get currentSession {
    if (sessionFactory != null) {
      return sessionFactory!();
    }
    return null;
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
  /// - Multiple custom headers via authHeaderBuilder
  Headers buildHeadersWithAuth({SessionResponse? session}) {
    session ??= currentSession;
    Headers headers = {};

    if (session != null) {
      // Use custom auth header builder if provided
      if (authHeaderBuilder != null) {
        headers = authHeaderBuilder!(session);
      }

      // Use configurable header name and token prefix
      final token = session.accessToken;
      if (token.isEmpty) {
        headers = {};
      }

      final headerValue = tokenPrefix.isEmpty ? token : '$tokenPrefix $token';

      headers = {authHeaderName: headerValue};
    }

    ___log(headers);
    
    return headers;
  }

  /// Validates authentication requirements for the request.
  /// 
  /// Throws [ZapException] if authentication is required but no session is available.
  void checkAuth(bool useAuth) {
    if (useAuth && currentSession == null) {
      throw ZapException(
        "Session is required to continue with authenticated requests. "
        "Please provide a valid session in the config or through sessionFactory callback."
      );
    }
  }

  /// Adds authentication headers to the request if authentication is enabled.
  /// 
  /// This method fetches the current session and builds the appropriate auth headers
  /// based on the configuration. It also includes any additional headers from 
  Headers buildHeaders([Headers? additionalHeaders]) {
    final headers = <String, String>{};
    
    // Add base headers from config
    if (this.headers != null) {
      headers.addAll(this.headers!);
    }
    
    // Add any additional headers passed to the method
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  /// Handles session refresh when authentication fails.
  /// 
  /// This method is called when a request returns HttpStatus.UNAUTHORIZED Unauthorized.
  /// It attempts to refresh the session using the provided callback.
  Future<SessionResponse?> handleSessionRefresh() async {
    if (onSessionRefreshed != null) {
      try {
        final session = await onSessionRefreshed!();
        if(session != null) {
          if (showResponseLogs) {
            console.log('Flux: Session refreshed successfully');
          }

          return session;
        }
      } catch (e) {
        if (showErrorLogs) {
          console.log('Flux: Session refresh failed: $e');
        }

        return null;
      }
    }
    return null;
  }

  /// Logs request information if request logging is enabled.
  void __log(String method, String endpoint, RequestParam? query) {
    if (showRequestLogs) {
      console.log('Flux Request: $method $endpoint');
      if (query != null && query.isNotEmpty) {
        console.log('Flux Query: $query');
      }
    }
  }

  /// Logs header information if header logging is enabled.
  void ___log(Headers headers) {
    if (showRequestLogs) {
      console.log('Flux Headers: $headers');
    }
  }

  /// Logs response information if response logging is enabled.
  void _log<T>(Response<ApiResponse<T>> response) {
    if (showResponseLogs) {
      console.log('Flux Response: ${response.status} - ${response.body?.status} - ${response.body?.message}');
    }
  }

  /// Handles [Exception] and returns a [Response<ApiResponse<T>>] based on exception type.
  /// 
  /// This method handles [Exception] that may be thrown during a request and returns
  /// appropriate responses based on the exception type, similar to the main handler.
  /// 
  /// If [showErrorLogs] is true, the exception is logged.
  /// 
  /// Returns a [Response<ApiResponse<T>>] with appropriate status code and ApiResponse body.
  Response<ApiResponse<T>> handleException<T>(Exception e) {
    ZapException zapException;
    
    // Convert to ZapException if not already
    if (e is ZapException) {
      zapException = e;
    } else {
      zapException = ZapException(e.toString());
    }

    // Log if enabled
    if (showErrorLogs) {
      console.log('[ZAP PULSE] Exception: $zapException');
    }

    // Always notify the adviser about the exception
    _adviser.onException(zapException);

    // Return appropriate response based on exception type
    return _createApiResponseForException<T>(zapException);
  }

  /// Creates appropriate Response<ApiResponse<T>> objects based on ZapException type
  Response<ApiResponse<T>> _createApiResponseForException<T>(ZapException exception) {
    switch (exception.type) {
      case ExceptionType.timeout:
        return Response<ApiResponse<T>>(
          status: HttpStatus.REQUEST_TIMEOUT,
          message: 'Request timed out. Please try again.',
          body: ApiResponse<T>.error('Request timeout: ${exception.message}'),
          headers: {'x-error-type': 'timeout'},
        );

      case ExceptionType.network:
        return Response<ApiResponse<T>>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Network connection unavailable. Check your internet connection.',
          body: ApiResponse<T>.error('Network error: ${exception.message}'),
          headers: {'x-error-type': 'network'},
        );

      case ExceptionType.server:
        return Response<ApiResponse<T>>(
          status: HttpStatus.fromCode(exception.statusCode ?? 500),
          message: 'Server error occurred. Please try again later.',
          body: ApiResponse<T>.error('Server error: ${exception.message}'),
          headers: {
            'x-error-type': 'server',
            'x-status-code': '${exception.statusCode ?? 500}'
          },
        );

      case ExceptionType.client:
        return Response<ApiResponse<T>>(
          status: HttpStatus.fromCode(exception.statusCode ?? 400),
          message: 'Client request error. Please check your request.',
          body: ApiResponse<T>.error('Client error: ${exception.message}'),
          headers: {
            'x-error-type': 'client',
            'x-status-code': '${exception.statusCode ?? 400}'
          },
        );

      case ExceptionType.auth:
        return Response<ApiResponse<T>>(
          status: HttpStatus.UNAUTHORIZED,
          message: 'Authentication required. Please login again.',
          body: ApiResponse<T>.error('Authentication error: ${exception.message}'),
          headers: {
            'x-error-type': 'auth',
            'x-auth-required': 'true'
          },
        );

      case ExceptionType.ssl:
        return Response<ApiResponse<T>>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Secure connection failed. Certificate or SSL error.',
          body: ApiResponse<T>.error('SSL error: ${exception.message}'),
          headers: {
            'x-error-type': 'ssl',
            'x-security-error': 'true'
          },
        );

      case ExceptionType.connection:
        return Response<ApiResponse<T>>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Cannot connect to server. Server may be down.',
          body: ApiResponse<T>.error('Connection error: ${exception.message}'),
          headers: {
            'x-error-type': 'connection',
            'x-retry-after': '30'
          },
        );

      case ExceptionType.dns:
        return Response<ApiResponse<T>>(
          status: HttpStatus.CONNECTION_NOT_REACHABLE,
          message: 'Cannot resolve server address. Check your DNS settings.',
          body: ApiResponse<T>.error('DNS error: ${exception.message}'),
          headers: {
            'x-error-type': 'dns',
            'x-dns-error': 'true'
          },
        );

      case ExceptionType.parsing:
        return Response<ApiResponse<T>>(
          status: HttpStatus.UNPROCESSABLE_ENTITY,
          message: 'Cannot parse server response. Invalid data format.',
          body: ApiResponse<T>.error('Parsing error: ${exception.message}'),
          headers: {
            'x-error-type': 'parsing',
            'x-content-error': 'true'
          },
        );

      case ExceptionType.cancelled:
        return Response<ApiResponse<T>>(
          status: HttpStatus.REQUEST_CANCELLED,
          message: 'Request was cancelled.',
          body: ApiResponse<T>.error('Request cancelled: ${exception.message}'),
          headers: {
            'x-error-type': 'cancelled',
            'x-cancelled': 'true'
          },
        );

      default:
        return Response<ApiResponse<T>>(
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          message: 'An unexpected error occurred. Please try again.',
          body: ApiResponse<T>.error('Unknown error: ${exception.message}'),
          headers: {
            'x-error-type': 'unknown',
            'x-unexpected-error': 'true'
          },
        );
    }
  }

  /// Creates an unauthorized response.
  /// 
  /// This method is used to create an unauthorized response.
  /// 
  /// Returns a [Response<ApiResponse<T>>] with the status code and message from the exception.
  Response<ApiResponse<T>> unauthorized<T>() {
    return Response<ApiResponse<T>>(
      status: HttpStatus.UNAUTHORIZED,
      headers: {},
      body: ApiResponse<T>.unauthorized('Unable to complete request due to authentication failure'),
    );
  }

  /// Retries a request after session refresh.
  Future<Response<ApiResponse<T>>> _retryRequest<T>(RequestExecutor<T> execute, CancelToken? cancelToken) async {
    final newSession = await handleSessionRefresh();
    Response<ApiResponse<T>> response;

    if (newSession != null) {
      // Retry the request with new session
      final headers = buildHeaders();
      response = await execute(headers, cancelToken);
    } else {
      response = unauthorized<T>();
    }

    _log(response);

    if(response.status == HttpStatus.UNAUTHORIZED) {
      whenUnauthorized?.call();
    }

    return response;
  }

  /// Executes an HTTP request with authentication and error handling.
  /// 
  /// This method handles the common flow for all HTTP methods:
  /// 1. Validates authentication requirements
  /// 2. Builds headers with configurable authentication
  /// 3. Executes the request
  /// 4. Handles HttpStatus.UNAUTHORIZED errors with session refresh
  /// 5. Logs request/response if enabled
  /// 6. Parses response data using provided parser
  Future<Response<ApiResponse<T>>> execute<T>(RequestExecutor<T> execute, String method, String endpoint, bool useAuth, CancelToken? cancelToken) async {
    __log(method, endpoint, null);
    Response<ApiResponse<T>> response;

    if(useSingleInstance) {
      checkAuth(useAuth);

      try {
        final headers = buildHeaders();

        if(useAuth) {
          headers.addAll(buildHeadersWithAuth());
        }

        response = await execute(headers, cancelToken);
        
        // Handle HttpStatus.UNAUTHORIZED Unauthorized - attempt session refresh
        if (response.status == HttpStatus.UNAUTHORIZED && useAuth) {
          response = await _retryRequest(execute, cancelToken);
        }
      } on ZapException catch (e) {
        response = handleException(e);
      } on Exception catch (e) {
        response = handleException(e);
      }
    } else {
      response = await execute(null, cancelToken);
    }

    _log(response);
    return response;
  }
}