/// {@template graphql_error}
/// Represents an error returned by a GraphQL API.
///
/// This class is used to encapsulate the structure of a typical GraphQL error
/// response, including the human-readable error message and an optional error code.
///
/// In GraphQL, errors can be returned even when the response has a 200 status code.
/// This class helps capture and inspect those logical or validation errors
/// returned in the `errors` field of a GraphQL response.
/// 
/// {@endtemplate}
class GraphQLError {
  /// Creates a [GraphQLError] with an optional [code] and [message].
  ///
  /// - [code] may represent an application-specific error identifier.
  /// - [message] is typically the human-readable description of the error,
  ///   useful for debugging or displaying to the user.
  /// 
  /// {@macro graphql_error}
  GraphQLError({this.code, this.message});

  /// A descriptive message explaining the GraphQL error.
  ///
  /// This typically comes from the `message` field of a GraphQL error object.
  /// For example: `"Field 'user' not found on type 'Query'"`.
  final String? message;

  /// An optional machine-readable code representing the type of error.
  ///
  /// This can be used to handle specific GraphQL error cases programmatically.
  /// Not all GraphQL APIs include this field.
  final String? code;

  /// Returns a formatted string representation of the error for logging or debugging.
  @override
  String toString() => 'ZAP [GraphQLError]:\n\tcode:$code\n\tmessage:$message';
}