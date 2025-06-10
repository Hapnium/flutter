import '../../definitions.dart';
import '../certificates/certificates.dart';
import '../interface/http_request_interface.dart';
import '../request/request.dart';
import '../response/response.dart';

class HttpRequestImplementation extends HttpRequestInterface {
  HttpRequestImplementation({
    bool allowAutoSignedCert = true,
    List<ZapTrustedCertificate>? trustedCertificates,
    bool withCredentials = false,
    ProxyFinder? findProxy,
  });

  @override
  void close() {}

  @override
  Future<ZapResponse<T>> send<T>(ZapRequest<T> request) {
    throw UnimplementedError();
  }
}