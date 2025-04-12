/// A custom exception class to handle various error scenarios in the app,
/// providing information such as error messages, status codes, and specific
/// error flags for rerouting or handling specific conditions.
///
/// This exception is used to manage application errors, such as session expiration,
/// platform incompatibility, or account lock status, and facilitates rerouting when
/// these errors occur.
class SmartException implements Exception {
  /// A descriptive message that explains the cause of the exception.
  String message;

  /// An optional error code that provides additional context for the error.
  int? code;

  /// Creates a [SmartException] with a specified [message] and optional fields
  /// for [code].
  ///
  /// Example usage:
  /// ```dart
  /// throw SmartException(
  ///   "Session has expired",
  ///   code: 401,
  ///   isSessionExpired: true
  /// );
  /// ```
  SmartException(this.message, {
    this.code,
  });

  /// Returns a string representation of the exception, including the [message] and
  /// the optional [code] if it is provided.
  ///
  /// Example:
  /// ```dart
  /// SmartException("An error occurred", code: 500).toString();
  /// // Output: "Main Exception: An error occurred. Code: 500"
  /// ```
  @override
  String toString() {
    if (code != null) {
      return "Smart Exception: $message. Code: $code";
    }

    return "Smart Exception: $message";
  }
}