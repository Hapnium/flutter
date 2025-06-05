import '../request/request.dart';
import '../utils/http_status.dart';

/// A class that encapsulates an HTTP response, including the decoded body, headers, and status.
class ZapResponse<T> {
  const ZapResponse({
    this.request,
    this.statusCode,
    this.bodyBytes,
    this.bodyString,
    this.statusText = '',
    this.headers = const {},
    this.body,
  });

  /// Creates a copy of this response with optional overrides.
  ZapResponse<T> copyWith({
    ZapRequest? request,
    int? statusCode,
    Stream<List<int>>? bodyBytes,
    String? bodyString,
    String? statusText,
    Map<String, String>? headers,
    T? body,
  }) {
    return ZapResponse<T>(
      request: request ?? this.request,
      statusCode: statusCode ?? this.statusCode,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      bodyString: bodyString ?? this.bodyString,
      statusText: statusText ?? this.statusText,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  /// The original request that triggered this response.
  final ZapRequest? request;

  /// The HTTP response headers.
  final Map<String, String>? headers;

  /// The HTTP status code (e.g. 200, 404, 500).
  final int? statusCode;

  /// Human-readable status message (e.g. "OK", "Not Found").
  final String? statusText;

  /// The raw response body as a byte stream.
  final Stream<List<int>>? bodyBytes;

  /// The raw response body as a UTF-8 decoded string.
  final String? bodyString;

  /// The deserialized response body.
  final T? body;

  /// [HttpStatus] from [ZapResponse]. `status.connectionError` is true
  /// when statusCode is null. `status.isUnauthorized` is true when
  /// statusCode is equal `401`. `status.isNotFound` is true when
  /// statusCode is equal `404`. `status.isServerError` is true when
  /// statusCode is between `500` and `599`.
  HttpStatus get status => HttpStatus(statusCode);

  /// `hasError` is true when statusCode is not between 200 and 299.
  bool get hasError => status.hasError;

  /// `isOk` is true when statusCode is between 200 and 299.
  bool get isOk => !hasError;

  /// `unauthorized` is true when statusCode is equal `401`.
  bool get unauthorized => status.isUnauthorized;

  /// Returns true when statusCode is between 200 and 299.
  /// 
  /// This is a helper method to check if the response is successful.
  bool is2xxSuccessful() {
    return statusCode != null && statusCode! >= 200 && statusCode! < 300;
  }

  /// Returns true when statusCode is between 300 and 399.
  /// 
  /// This is a helper method to check if the response is a redirection.
  bool is3xxRedirection() {
    return statusCode != null && statusCode! >= 300 && statusCode! < 400;
  }

  /// Returns true when statusCode is between 400 and 499.
  /// 
  /// This is a helper method to check if the response is a client error.
  bool is4xxClientError() {
    return statusCode != null && statusCode! >= 400 && statusCode! < 500;
  }

  /// Returns true when statusCode is between 500 and 599.
  /// 
  /// This is a helper method to check if the response is a server error.
  bool is5xxServerError() {
    return statusCode != null && statusCode! >= 500 && statusCode! < 600;
  }
}