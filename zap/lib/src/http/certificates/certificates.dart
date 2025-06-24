import '../../definitions.dart';

/// {@template trusted_certificate}
/// Represents a trusted SSL/TLS certificate in binary form (DER-encoded).
///
/// This class is typically used to pin or trust specific certificates manually,
/// such as when bypassing system trust stores or for custom certificate validation.
///
/// ## Usage
/// You might load a certificate from assets or network, and use it
/// to validate a server connection:
///
/// ```dart
/// final certBytes = await rootBundle.load('assets/certs/server.der');
/// final trustedCert = TrustedCertificate(certBytes.buffer.asUint8List());
/// ```
///
/// It's commonly used in scenarios involving:
/// - Certificate pinning
/// - Custom CA trust chains
/// - Self-signed certificates
/// 
/// {@endtemplate}
class ZapTrustedCertificate {
  /// The binary representation (DER format) of the trusted certificate.
  ///
  /// This is typically a byte list (`BodyBytes`) read from a `.cer`, `.crt`,
  /// or `.der` file. It should **not** be Base64-encoded PEM unless decoded.
  final BodyBytes bytes;

  /// Creates a [ZapTrustedCertificate] from raw certificate [bytes].
  ///
  /// The bytes must represent a valid DER-encoded certificate.
  /// 
  /// {@macro trusted_certificate}
  const ZapTrustedCertificate(this.bytes);
}