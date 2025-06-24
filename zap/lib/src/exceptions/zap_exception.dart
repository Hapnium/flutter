import '../enums/exception_type.dart';

/// {@template zap_exception}
/// A comprehensive exception thrown by ZapClient during HTTP operations.
///
/// The [ZapException] class represents a unified structure for handling all errors
/// that may occur during network or API interactions, such as timeouts, SSL failures,
/// server/client errors, and more. It encapsulates contextual information like
/// the request URI, status codes, and optional diagnostic details.
///
/// Inspired by structured error models in frameworks like Spring Boot, this class
/// promotes consistent error categorization and better error-handling workflows.
/// 
/// {@endtemplate}
class ZapException implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// The URI of the HTTP request that caused the exception, if available.
  final Uri? uri;

  /// A strongly typed [ExceptionType] categorizing the nature of the error.
  final ExceptionType type;

  /// The HTTP status code returned by the server, if applicable.
  final int? statusCode;

  /// Additional metadata or context related to the error, such as validation issues.
  final Map<String, dynamic>? details;

  /// The original exception that caused this one, if applicable.
  final Exception? originalException;

  /// The stack trace of the original exception, useful for logging or debugging.
  final StackTrace? originalStackTrace;

  /// Main constructor for [ZapException].
  ///
  /// Use this when constructing exceptions directly or from custom handlers.
  /// 
  /// {@macro zap_exception}
  ZapException(
    this.message, [
    this.uri,
    this.type = ExceptionType.unknown,
    this.statusCode,
    this.details,
    this.originalException,
    this.originalStackTrace,
  ]);

  /// Creates a timeout-related exception.
  /// 
  /// {@macro zap_exception}
  ZapException.timeout(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.timeout, null, details);

  /// Creates a network failure exception (e.g., no internet).
  /// 
  /// {@macro zap_exception}
  ZapException.network(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.network, null, details);

  /// Creates an exception for server-side errors (HTTP 5xx).
  /// 
  /// {@macro zap_exception}
  ZapException.server(String message, int statusCode, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.server, statusCode, details);

  /// Creates an exception for client-side errors (HTTP 4xx).
  /// 
  /// {@macro zap_exception}
  ZapException.client(String message, int statusCode, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.client, statusCode, details);

  /// Creates an authentication or authorization failure exception.
  /// 
  /// {@macro zap_exception}
  ZapException.auth(String message, [Uri? uri, int? statusCode, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.auth, statusCode, details);

  /// Creates an exception for cancelled requests (e.g., manually aborted).
  /// 
  /// {@macro zap_exception}
  ZapException.cancelled(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.cancelled, null, details);

  /// Creates an SSL handshake or certificate failure exception.
  /// 
  /// {@macro zap_exception}
  ZapException.ssl(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.ssl, null, details);

  /// Creates a connection failure exception (e.g., socket issues).
  /// 
  /// {@macro zap_exception}
  ZapException.connection(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.connection, null, details);

  /// Creates a DNS resolution failure exception.
  /// 
  /// {@macro zap_exception}
  ZapException.dns(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.dns, null, details);

  /// Creates an exception related to parsing the response body.
  /// 
  /// {@macro zap_exception}
  ZapException.parsing(String message, [Uri? uri, Map<String, dynamic>? details])
      : this(message, uri, ExceptionType.parsing, null, details);

  // -------------------------
  // Convenience Type Checks
  // -------------------------

  /// Returns true if this is a timeout-related exception.
  bool get isTimeout => type == ExceptionType.timeout;

  /// Returns true if this is a network-related exception.
  bool get isNetwork => type == ExceptionType.network;

  /// Returns true if this is a server-side (5xx) exception.
  bool get isServer => type == ExceptionType.server;

  /// Returns true if this is a client-side (4xx) exception.
  bool get isClient => type == ExceptionType.client;

  /// Returns true if this is an authentication-related exception.
  bool get isAuth => type == ExceptionType.auth;

  /// Returns true if the request was cancelled.
  bool get isCancelled => type == ExceptionType.cancelled;

  /// Returns true if the error was SSL/certificate-related.
  bool get isSSL => type == ExceptionType.ssl;

  /// Returns true if the error was due to a failed connection.
  bool get isConnection => type == ExceptionType.connection;

  /// Returns true if the error was DNS-related.
  bool get isDNS => type == ExceptionType.dns;

  /// Returns true if the error was due to response parsing.
  bool get isParsing => type == ExceptionType.parsing;

  /// Returns true if this exception is considered retryable.
  ///
  /// Retryable exceptions include network issues, timeouts, connection problems,
  /// DNS failures, and specific server errors like 502/503/504.
  bool get isRetryable {
    switch (type) {
      case ExceptionType.network:
      case ExceptionType.timeout:
      case ExceptionType.connection:
      case ExceptionType.dns:
        return true;
      case ExceptionType.server:
        return statusCode == 502 || statusCode == 503 || statusCode == 504;
      default:
        return false;
    }
  }

  /// Returns a formatted string representing the exception.
  @override
  String toString() {
    final buffer = StringBuffer('ZapException [${type.name.toUpperCase()}]: $message');
    
    if (uri != null) buffer.write(' (URL: $uri)');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    if (details != null && details!.isNotEmpty) buffer.write(' (Details: $details)');
    
    return buffer.toString();
  }

  /// Converts this exception into a serializable map format.
  ///
  /// Useful for logging, error reporting, or analytics pipelines.
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'uri': uri?.toString(),
      'type': type.name,
      'statusCode': statusCode,
      'details': details,
      'isRetryable': isRetryable,
    };
  }
}