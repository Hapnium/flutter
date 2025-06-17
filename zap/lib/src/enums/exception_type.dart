/// Defines the category of an exception for structured error handling.
///
/// The [ExceptionType] enum helps classify different failure scenarios during
/// network or API operations. It allows exception handlers to easily distinguish
/// between retryable, fatal, and user-actionable errors.
///
/// This classification is inspired by real-world error types from HTTP standards,
/// network protocols, and system-level failures.
enum ExceptionType {
  /// Issues related to network connectivity, such as no internet access,
  /// socket disconnection, or airplane mode.
  ///
  /// Examples:
  /// - `SocketException: Failed host lookup`
  /// - `No route to host`
  network,

  /// The request took too long and exceeded the configured timeout threshold.
  ///
  /// Typically indicates slow network or unresponsive server.
  ///
  /// Retry is often a viable strategy.
  timeout,

  /// Server-side errors returned with HTTP status codes in the 5xx range.
  ///
  /// Indicates that the server failed to fulfill a valid request.
  /// Retryable for transient conditions like:
  /// - 502 Bad Gateway
  /// - 503 Service Unavailable
  /// - 504 Gateway Timeout
  server,

  /// Client-side errors, usually indicated by HTTP status codes in the 4xx range.
  ///
  /// Common causes:
  /// - Malformed requests
  /// - Unauthorized access (401)
  /// - Forbidden resources (403)
  /// - Resource not found (404)
  client,

  /// Authentication or authorization issues.
  ///
  /// Used when credentials are missing, invalid, or expired.
  /// Should typically prompt a login or re-authentication flow.
  auth,

  /// The request was intentionally or programmatically cancelled.
  ///
  /// This may occur due to:
  /// - A timeout cancellation token
  /// - User-initiated abort (e.g., closing screen)
  cancelled,

  /// Errors related to SSL/TLS certificate validation or negotiation.
  ///
  /// Examples:
  /// - Self-signed certificate rejection
  /// - Hostname mismatch
  /// - Expired certificate
  ssl,

  /// Failure to establish a TCP connection to the server.
  ///
  /// Causes may include:
  /// - Port closed
  /// - Server down
  /// - Firewall or proxy blocking connection
  connection,

  /// Failure to resolve a domain name (DNS error).
  ///
  /// Typically results from:
  /// - Misconfigured DNS
  /// - No internet connection
  /// - Invalid hostname
  dns,

  /// Failures during deserialization, response decoding, or data parsing.
  ///
  /// Examples:
  /// - Unexpected JSON structure
  /// - Format exceptions
  /// - Null dereferencing
  parsing,

  /// A fallback type for uncategorized or unknown errors.
  ///
  /// Use this when no specific type applies, or when an unexpected
  /// error occurs that doesn't match known categories.
  unknown,
}