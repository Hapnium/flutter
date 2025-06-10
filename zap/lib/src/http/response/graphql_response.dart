
import '../../enums/zap_provider.dart';
import '../../exceptions/exceptions.dart';
import '../utils/http_status.dart';
import 'response.dart';

/// A response object specifically for GraphQL operations.
///
/// Includes both the successful data payload and any GraphQL errors returned.
class GraphQLResponse<T> extends ZapResponse<T> {
  /// List of GraphQL errors returned by the server.
  final List<GraphQLError>? graphQLErrors;

  GraphQLResponse({required super.status, super.body, this.graphQLErrors, super.provider = ZapProvider.graphql});

  /// Constructs a [GraphQLResponse] from a standard [ZapResponse],
  /// extracting the GraphQL `data` field as the response body.
  GraphQLResponse.fromResponse(ZapResponse res) : graphQLErrors = null, super(
    request: res.request,
    status: res.status,
    message: res.message,
    bodyBytes: res.bodyBytes,
    bodyString: res.bodyString,
    headers: res.headers,
    body: res.body['data'] as T?,
    provider: ZapProvider.graphql,
  );

  /// Constructs a [GraphQLResponse] from a dynamic response body.
  /// 
  /// This factory constructor is useful when you have a [ZapResponse]
  /// that contains a GraphQL response body.
  factory GraphQLResponse.fromDynamic(ZapResponse res) {
    final listError = res.body['errors'];

    if ((listError is List) && listError.isNotEmpty) {
      return GraphQLResponse<T>(
        status: res.status,
        graphQLErrors: listError.map((e) => GraphQLError(
          code: (e['extensions'] != null ? e['extensions']['code'] ?? '' : '').toString(),
          message: (e['message'] ?? '').toString(),
        )).toList()
      );
    }
    return GraphQLResponse<T>.fromResponse(res);
  }

  factory GraphQLResponse.fromException(Exception e) {
    return GraphQLResponse<T>(
      status: HttpStatus.CONNECTION_NOT_REACHABLE,
      graphQLErrors: [
        GraphQLError(
          code: null,
          message: e.toString(),
        )
      ]
    );
  }
}