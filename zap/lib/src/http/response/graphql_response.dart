
import '../../enums/zap_provider.dart';
import '../../exceptions/graphql_error.dart';
import '../utils/http_status.dart';
import 'response.dart';

/// {@template graphql_response}
/// A response object specifically for GraphQL operations.
///
/// Includes both the successful data payload and any GraphQL errors returned.
/// 
/// Example:
/// ```dart
/// final response = await client.post(
///   '/graphql',
///   body: {
///     'query': '{ hello }',
///   },
/// );
/// ```
/// 
/// {@endtemplate}
class GraphQLResponse<T> extends Response<T> {
  /// List of GraphQL errors returned by the server.
  final List<GraphQLError>? graphQLErrors;

  /// {@macro graphql_response}
  GraphQLResponse({required super.status, super.body, this.graphQLErrors, super.provider = ZapProvider.graphql});

  /// Constructs a [GraphQLResponse] from a standard [Response],
  /// extracting the GraphQL `data` field as the response body.
  /// 
  /// {@macro graphql_response}
  GraphQLResponse.fromResponse(Response res) : graphQLErrors = null, super(
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
  /// This factory constructor is useful when you have a [Response]
  /// that contains a GraphQL response body.
  /// 
  /// {@macro graphql_response}
  factory GraphQLResponse.fromDynamic(Response res) {
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

  /// Constructs a [GraphQLResponse] from an exception.
  /// 
  /// This factory constructor is useful when you have an exception
  /// that you want to convert into a [GraphQLResponse].
  /// 
  /// {@macro graphql_response}
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