// ignore_for_file: constant_identifier_names, non_constant_identifier_names

/// {@template http_method}
/// Defines the standard HTTP methods used for network requests.
///
/// Each constant represents an HTTP verb used in RESTful APIs and other HTTP-based communication.
///
/// Example:
/// ```dart
/// final method = HttpMethod.POST;
/// ```
/// {@endtemplate}
abstract class HttpMethod {
  /// `GET`
  ///
  /// Retrieves data from the server without modifying it.
  ///
  /// - Safe and idempotent.
  /// - Commonly used to fetch lists or individual resources.
  ///
  /// Example: `GET /users`
  static const String GET = 'GET';

  /// `POST`
  ///
  /// Sends data to the server to create a new resource.
  ///
  /// - Not idempotent.
  /// - Often used with `application/json` or `multipart/form-data` bodies.
  ///
  /// Example: `POST /users` with a JSON body to create a new user.
  static const String POST = 'POST';

  /// `PUT`
  ///
  /// Updates or replaces a resource at a specific URI.
  ///
  /// - Idempotent (repeating the request has the same effect).
  /// - Usually replaces the entire resource.
  ///
  /// Example: `PUT /users/123` to update user 123.
  static const String PUT = 'PUT';

  /// `DELETE`
  ///
  /// Removes a resource identified by a URI.
  ///
  /// - Idempotent.
  ///
  /// Example: `DELETE /users/123` deletes user 123.
  static const String DELETE = 'DELETE';

  /// `PATCH`
  ///
  /// Applies partial modifications to a resource.
  ///
  /// - Not necessarily idempotent.
  /// - Typically used to update only the changed fields.
  ///
  /// Example: `PATCH /users/123` with a body that includes only updated fields.
  static const String PATCH = 'PATCH';

  /// `HEAD`
  ///
  /// Retrieves headers for a resource without the body.
  ///
  /// - Safe and idempotent.
  /// - Useful for checking resource availability or metadata.
  ///
  /// Example: `HEAD /users/123` to check if user 123 exists.
  static const String HEAD = 'HEAD';

  /// `OPTIONS`
  ///
  /// Retrieves the HTTP methods supported by the server for a specific resource.
  ///
  /// - Safe and idempotent.
  /// - Useful for checking resource availability or metadata.
  ///
  /// Example: `OPTIONS /users/123` to check if user 123 exists.
  static const String OPTIONS = 'OPTIONS';

  /// `TRACE`
  ///
  /// Retrieves the HTTP methods supported by the server for a specific resource.
  ///
  /// - Safe and idempotent.
  /// - Useful for checking resource availability or metadata.
  ///
  /// Example: `TRACE /users/123` to check if user 123 exists.
  static const String TRACE = 'TRACE';

  /// `CONNECT`
  ///
  /// Retrieves the HTTP methods supported by the server for a specific resource.
  ///
  /// - Safe and idempotent.
  /// - Useful for checking resource availability or metadata.
  ///
  /// Example: `CONNECT /users/123` to check if user 123 exists.
  static const String CONNECT = 'CONNECT';

  /// `FROM`
  /// 
  /// Retrieves the HTTP methods supported by the server for a specific resource.
  /// 
  /// - Safe and idempotent.
  /// - Useful for checking resource availability or metadata.
  /// 
  /// Example: `FROM /users/123` to check if user 123 exists.
  static String FROM(String value) {
    return value.toUpperCase();
  }
}