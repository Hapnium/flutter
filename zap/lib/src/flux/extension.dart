import 'package:tracing/tracing.dart' show console;

import '../definitions.dart';
import '../models/api_response.dart';
import '../exceptions/exceptions.dart';
import '../http/response/response.dart';
import '../http/utils/http_status.dart';
import '../models/flux_config.dart';
import '../models/session_response.dart';
import '../models/cancel_token.dart';

/// Type definition for request executor function with cancellation support
typedef RequestExecutor<T> = Future<Response<ApiResponse<T>>> Function(Headers? headers, CancelToken? cancelToken);

extension FluxConfigExtension on FluxConfig {
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

  /// Handles [ZapException] and returns a [Response<ApiResponse<T>>].
  /// 
  /// This method is used to handle [ZapException] that may be thrown during a request.
  /// 
  /// If [showErrorLogs] is true, the exception is logged.
  /// 
  /// Returns a [Response<ApiResponse<T>>] with the status code and message from the exception.
  Response<ApiResponse<T>> handleZapException<T>(ZapException e) {
    if (showErrorLogs) {
      console.log('[ZAP PULSE] ZapException: $e');
    }
    
    // Return error response
    return Response<ApiResponse<T>>(
      status: e.isTimeout ? HttpStatus.REQUEST_TIMEOUT : HttpStatus.INTERNAL_SERVER_ERROR,
      message: e.isTimeout ? 'Request timed out' : e.message,
      body: ApiResponse<T>.error(e.message),
    );
  }

  /// Handles [Exception] and returns a [Response<ApiResponse<T>>].
  /// 
  /// This method is used to handle [Exception] that may be thrown during a request.
  /// 
  /// If [showErrorLogs] is true, the exception is logged.
  /// 
  /// Returns a [Response<ApiResponse<T>>] with the status code and message from the exception.
  Response<ApiResponse<T>> handleException<T>(Exception e) {
    if (showErrorLogs) {
      console.log('[ZAP PULSE] Exception: $e');
    }
    
    // Return error response
    return Response<ApiResponse<T>>(
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      message: e.toString(),
      body: ApiResponse<T>.error(e.toString()),
    );
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