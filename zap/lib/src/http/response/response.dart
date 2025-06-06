import 'package:zap/src/definitions.dart';

import '../../enums/zap_provider.dart';
import '../request/request.dart';
import '../utils/http_status.dart';

/// A class that encapsulates an HTTP response, including the decoded body,
/// headers, status code, and raw response data.
///
/// This class is generic and can be used to represent the body of any type [T],
/// which allows flexibility in decoding different types of responses.
///
/// Typical usage:
/// ```dart
/// final response = ZapResponse<User>(
///   status: HttpStatus.ok,
///   body: User.fromJson(json),
///   headers: {...},
/// );
/// if (response.isOk) {
///   // Use response.body
/// }
/// ```
class ZapResponse<T> {
  /// The original request that triggered this response.
  ///
  /// This includes request details like the HTTP method, URL, headers, and body.
  final ZapRequest? request;

  /// The HTTP response headers returned by the server.
  ///
  /// These might include metadata such as content type, authorization info, etc.
  final Headers? headers;

  /// The HTTP status code and description.
  ///
  /// This includes both the numeric status code (e.g., 200, 404)
  /// and a human-readable message (e.g., "OK", "Not Found").
  final HttpStatus status;

  /// A human-readable message describing the response.
  ///
  /// Defaults to [status.description] if not explicitly provided.
  final String message;

  /// The raw response body as a stream of bytes.
  ///
  /// Useful for downloading binary data such as files or images.
  final BodyBytes? bodyBytes;

  /// The raw response body decoded as a UTF-8 string.
  ///
  /// Suitable for logging or fallback access when deserialization fails.
  final String? bodyString;

  /// Which client was used to make the request that brought this response.
  ///
  /// Can be `io`, `http`, `web` or `graphql`
  final ZapProvider provider;

  /// The parsed/deserialized response body of type [T].
  ///
  /// This is usually the result of applying a response parser on the raw response body.
  final T? body;

  /// Constructs a new [ZapResponse] with the given fields.
  ///
  /// If [message] is not provided, it will default to the status description.
  ZapResponse({
    this.request,
    required this.status,
    this.bodyBytes,
    this.bodyString,
    this.headers = const {},
    this.body,
    String? message,
    this.provider = ZapProvider.io,
  }) : message = message ?? status.description;

  /// Creates a copy of this response with optional overrides.
  ///
  /// This is useful for modifying or updating specific fields without
  /// reconstructing the entire response object.
  ZapResponse<T> copyWith({
    ZapRequest? request,
    HttpStatus? status,
    Stream<List<int>>? bodyBytes,
    String? bodyString,
    Map<String, String>? headers,
    T? body,
    ZapProvider? provider,
  }) {
    return ZapResponse<T>(
      request: request ?? this.request,
      status: status ?? this.status,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      bodyString: bodyString ?? this.bodyString,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      provider: provider ?? this.provider,
    );
  }

  /// Returns `true` if the response indicates an error.
  ///
  /// Error responses typically have status codes outside the 200–299 range.
  bool get hasError => status.hasError;

  /// Returns `true` if the response indicates a successful request.
  ///
  /// Equivalent to `!hasError`, covering status codes 200–299.
  bool get isOk => !hasError;

  /// Returns `true` if the response status code is 401 (Unauthorized).
  ///
  /// This is useful for detecting authentication failures.
  bool get unauthorized => status.isUnauthorized;

  /// Returns `true` if the status code is in the 2xx range (200–299).
  ///
  /// This typically indicates success.
  bool is2xxSuccessful() {
    return status.code >= 200 && status.code < 300;
  }

  /// Returns `true` if the status code is in the 3xx range (300–399).
  ///
  /// This indicates a redirection response.
  bool is3xxRedirection() {
    return status.code >= 300 && status.code < 400;
  }

  /// Returns `true` if the status code is in the 4xx range (400–499).
  ///
  /// This indicates a client error such as bad request or unauthorized access.
  bool is4xxClientError() {
    return status.code >= 400 && status.code < 500;
  }

  /// Returns `true` if the status code is in the 5xx range (500–599).
  ///
  /// This indicates a server-side error.
  bool is5xxServerError() {
    return status.code >= 500 && status.code < 600;
  }

  Map<String, dynamic> toJson() {
    return {
      'request': request?.toJson(),
      'headers': headers,
      'status': status.toJson(),
      'bodyBytes': bodyBytes,
      'bodyString': bodyString,
      'body': body,
      'provider': provider,
    };
  }
}