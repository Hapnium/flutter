import '../interface/http_request_interface.dart';
import '../request/request.dart';
import '../response/helpers.dart';
import '../response/response.dart';
import '../utils/body_decoder.dart';

/// A handler for [MockHttpRequest]
typedef MockHttpRequestHandler = Future<Response> Function(Request request);

/// {@template mock_http_request}
/// A mock implementation of [HttpRequestInterface]
/// 
/// This is used for testing purposes
/// 
/// {@endtemplate}
class MockHttpRequest extends HttpRequestInterface {
  /// The handler for than transforms request on response
  final MockHttpRequestHandler _handler;

  /// {@macro mock_http_request}
  MockHttpRequest(this._handler);

  @override
  Future<Response<T>> send<T>(Request<T> request) async {
    var requestBody = await request.bodyBytes.toBytes();
    var bodyBytes = requestBody.toStream();

    var response = await _handler(request);

    final stringBody = await bodyBytesToString(bodyBytes, response.headers!);

    var mimeType = response.headers!.containsKey('content-type')
        ? response.headers!['content-type']
        : '';

    final body = bodyDecoded<T>(request, stringBody, mimeType);

    return Response(
      headers: response.headers,
      request: request,
      status: response.status,
      message: response.message,
      bodyBytes: bodyBytes,
      body: body,
      bodyString: stringBody,
      provider: response.provider,
    );
  }

  @override
  void close() {}
}