import '../certificates/certificates.dart';
import '../stub/stub_http_request.dart'
    if (dart.library.js_interop) '../html/html_http_request.dart'
    if (dart.library.io) '../io/io_http_request.dart';

/// Create a [HttpRequestImplementation]
/// 
/// This is the factory to create a [HttpRequestImplementation] depends on the platform
/// 
/// Args:
///   allowAutoSignedCert: When true, the client will allow auto signed certificate
///   trustedCertificates: The trusted certificates to use
///   withCredentials: When true, the client will send credentials
///   findProxy: The function to find proxy
HttpRequestImplementation createHttp({
  bool allowAutoSignedCert = true,
  List<ZapTrustedCertificate>? trustedCertificates,
  bool withCredentials = false,
  String Function(Uri url)? findProxy,
}) {
  return HttpRequestImplementation(
    allowAutoSignedCert: allowAutoSignedCert,
    trustedCertificates: trustedCertificates,
    withCredentials: withCredentials,
    findProxy: findProxy,
  );
}