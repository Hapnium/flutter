import '../interface/http_request_interface.dart';
import '../request/request.dart';
import '../response/helpers.dart';
import '../response/response.dart';
import '../utils/body_decoder.dart';

/// A handler for [MockHttpRequest]
typedef MockHttpRequestHandler = Future<ZapResponse> Function(ZapRequest request);

/// A mock implementation of [HttpRequestInterface]
/// 
/// This is used for testing purposes
class MockHttpRequest extends HttpRequestInterface {
  /// The handler for than transforms request on response
  final MockHttpRequestHandler _handler;

  /// Creates a [MockHttpRequest] with a handler that receives [ZapRequest]s and sends
  /// [ZapResponse]s.
  MockHttpRequest(this._handler);

  @override
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request) async {
    var requestBody = await request.bodyBytes.toBytes();
    var bodyBytes = requestBody.toStream();

    var response = await _handler(request);

    final stringBody = await bodyBytesToString(bodyBytes, response.headers!);

    var mimeType = response.headers!.containsKey('content-type')
        ? response.headers!['content-type']
        : '';

    final body = bodyDecoded<T>(
      request,
      stringBody,
      mimeType,
    );
    return ZapResponse(
      headers: response.headers,
      request: request,
      statusCode: response.statusCode,
      statusText: response.statusText,
      bodyBytes: bodyBytes,
      body: body,
      bodyString: stringBody,
    );
  }

  @override
  void close() {}
}