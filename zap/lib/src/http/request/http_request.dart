import '../../definitions.dart';
import '../certificates/certificates.dart';
import '../stub/stub_http_request.dart'
    if (dart.library.js_interop) '../html/html_http_request.dart'
    if (dart.library.io) '../io/io_http_request.dart';

/// {@template create_http}
/// Create a [HttpRequestImplementation]
/// 
/// This is the factory to create a [HttpRequestImplementation] depends on the platform
/// 
/// Args:
///   allowAutoSignedCert: When true, the client will allow auto signed certificate
///   trustedCertificates: The trusted certificates to use
///   withCredentials: When true, the client will send credentials
///   findProxy: The function to find proxy
/// 
/// Example:
/// ```dart
/// final http = createHttp();
/// ```
/// 
/// {@endtemplate}
HttpRequestImplementation createHttp({
  bool allowAutoSignedCert = true,
  List<ZapTrustedCertificate>? trustedCertificates,
  bool withCredentials = false,
  ProxyFinder? findProxy,
}) {
  return HttpRequestImplementation(
    allowAutoSignedCert: allowAutoSignedCert,
    trustedCertificates: trustedCertificates,
    withCredentials: withCredentials,
    findProxy: findProxy,
  );
}