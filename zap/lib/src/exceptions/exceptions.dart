/// A general exception thrown by ZapClient during HTTP operations.
///
/// Typically thrown when the client encounters unexpected or unrecoverable conditions.
///
/// - [message]: A description of the exception.
/// - [uri]: Optional URI associated with the failed request.
class ZapException implements Exception {
  final String message;
  final Uri? uri;
  final bool isTimeout;

  ZapException(this.message, [this.uri, this.isTimeout = false]);

  @override
  String toString() => message;
}

/// Represents an error returned by a GraphQL API.
/// 
/// - [message]: A description of the error.
/// - [code]: A code representing the error type.
class GraphQLError {
  GraphQLError({this.code, this.message});
  final String? message;
  final String? code;

  @override
  String toString() => 'ZAP [GraphQLError]:\n\tcode:$code\n\tmessage:$message';
}

/// Exception thrown when a request is unauthorized (e.g. HTTP 401).
class ZapUnauthorizedException implements Exception {
  @override
  String toString() => 'Operation Unauthorized';
}

/// Exception thrown when a response body is in an unexpected format or can't be parsed.
///
/// - [message]: A description of the formatting issue.
class ZapUnexpectedFormat implements Exception {
  final String message;

  ZapUnexpectedFormat(this.message);

  @override
  String toString() => 'Unexpected format: $message';
}