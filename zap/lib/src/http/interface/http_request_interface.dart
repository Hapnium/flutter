import '../request/request.dart';
import '../response/response.dart';

/// Abstract interface of [HttpRequestImplementation].
abstract class HttpRequestInterface {
  /// Sends an HTTP [ZapRequest].
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request);

  /// Closes the [ZapRequest] and cleans up any resources associated with it.
  void close();

  /// Gets and sets the timeout.
  ///
  /// For mobile, this value will be applied for both connection and request
  /// timeout.
  ///
  /// For web, this value will be the request timeout.
  Duration? timeout;
}