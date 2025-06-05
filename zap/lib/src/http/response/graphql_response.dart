
import '../../exceptions/exceptions.dart';
import 'response.dart';

/// A response object specifically for GraphQL operations.
///
/// Includes both the successful data payload and any GraphQL errors returned.
class GraphQLResponse<T> extends ZapResponse<T> {
  /// List of GraphQL errors returned by the server.
  final List<GraphQLError>? graphQLErrors;

  GraphQLResponse({required super.status, super.body, this.graphQLErrors});

  /// Constructs a [GraphQLResponse] from a standard [ZapResponse],
  /// extracting the GraphQL `data` field as the response body.
  GraphQLResponse.fromResponse(ZapResponse res)
    : graphQLErrors = null,
      super(
        request: res.request,
        status: res.status,
        message: res.message,
        bodyBytes: res.bodyBytes,
        bodyString: res.bodyString,
        headers: res.headers,
        body: res.body['data'] as T?
      );
}