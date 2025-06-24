import '../request/request.dart';
import '../response/response.dart';

/// Abstract interface of [HttpRequestImplementation].
/// 
/// This class is used to send an HTTP [Request] and returns a [Response].
abstract class HttpRequestInterface {
  /// Sends an HTTP [Request].
  /// 
  /// This method sends an HTTP [Request] and returns a [Response].
  Future<Response<T>> send<T>(Request<T> request);

  /// Closes the [Request] and cleans up any resources associated with it.
  void close();

  /// Gets and sets the timeout.
  ///
  /// For mobile, this value will be applied for both connection and request
  /// timeout.
  ///
  /// For web, this value will be the request timeout.
  Duration? timeout;
}