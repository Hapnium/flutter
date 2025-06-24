import '../../definitions.dart';
import '../certificates/certificates.dart';
import '../interface/http_request_interface.dart';
import '../request/request.dart';
import '../response/response.dart';

/// {@template stub_http_request}
/// A stub implementation of [HttpRequestInterface]
/// 
/// This implementation is used for testing and development purposes.
/// 
/// {@endtemplate}
class HttpRequestImplementation extends HttpRequestInterface {
  /// Create a [HttpRequestImplementation]
  /// 
  /// Args:
  ///   allowAutoSignedCert: Whether to allow auto signed certificates
  ///   trustedCertificates: List of trusted certificates
  ///   withCredentials: Whether to send credentials
  ///   findProxy: Proxy finder
  /// 
  /// {@macro stub_http_request}
  HttpRequestImplementation({
    bool allowAutoSignedCert = true,
    List<ZapTrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    ProxyFinder? findProxy,
  });

  @override
  void close() {}

  @override
  Future<Response<T>> send<T>(Request<T> request) {
    throw UnimplementedError();
  }
}