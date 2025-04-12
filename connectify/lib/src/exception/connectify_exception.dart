/// A custom exception class to handle various error scenarios in the app,
/// providing information such as error messages, status codes, and specific
/// error flags for rerouting or handling specific conditions.
///
/// This exception is used to manage application errors, such as session expiration,
/// platform incompatibility, or account lock status, and facilitates rerouting when
/// these errors occur.
class ConnectifyException implements Exception {
  /// A descriptive message that explains the cause of the exception.
  String message;

  /// An optional error code that provides additional context for the error.
  int? code;

  /// Indicates whether the user's account is locked. Defaults to `false`.
  bool isLocked;

  /// Indicates whether the user's session has expired. Defaults to `false`.
  bool isSessionExpired;

  /// Indicates whether the platform is not supported. Defaults to `false`.
  bool isPlatformNotSupported;

  /// Creates a [ConnectifyException] with a specified [message] and optional fields
  /// for [code], [isLocked], [isSessionExpired], and [isPlatformNotSupported].
  ///
  /// The [isLocked], [isSessionExpired], and [isPlatformNotSupported] fields default
  /// to `false` if not provided.
  ///
  /// Example usage:
  /// ```dart
  /// throw ConnectifyException(
  ///   "Session has expired",
  ///   code: 401,
  ///   isSessionExpired: true
  /// );
  /// ```
  ConnectifyException(this.message, {
    this.code,
    this.isLocked = false,
    this.isSessionExpired = false,
    this.isPlatformNotSupported = false,
  });

  /// Returns a string representation of the exception, including the [message] and
  /// the optional [code] if it is provided.
  ///
  /// Example:
  /// ```dart
  /// ConnectifyException("An error occurred", code: 500).toString();
  /// // Output: "Main Exception: An error occurred. Code: 500"
  /// ```
  @override
  String toString() {
    if (code != null) {
      return "Connectify Exception: $message. Code: $code";
    }

    return "Connectify Exception: $message";
  }
}