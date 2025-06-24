/// {@template pem_delimiter}
/// A utility class that defines all constant delimiters used in PEM-formatted key blocks.
///
/// PEM (Privacy-Enhanced Mail) format is a base64 encoding with a specific header/footer block.
/// This class provides constants to help wrap or unwrap keys in PEM format for various key types:
/// - General purpose public/private keys
/// - RSA public/private keys
/// - EC (Elliptic Curve) public/private keys
///
/// These delimiters are used internally by encoding/decoding logic in `PemUtils` and `Pem`.
///
/// Example usage:
/// ```dart
/// final pem = '${PemDelimiter.BEGIN_PRIVATE_RSA_KEY}\n$base64Key\n${PemDelimiter.END_PRIVATE_RSA_KEY}';
/// ```
/// {@endtemplate}
class PemDelimiter {
  /// {@macro pem_delimiter}
  PemDelimiter._();

  // General PEM delimiters

  /// Header for a generic public key block.
  ///
  /// Example:
  /// ```
  /// -----BEGIN PUBLIC KEY-----
  /// ```
  static const BEGIN_PUBLIC_KEY = "-----BEGIN PUBLIC KEY-----";

  /// Footer for a generic public key block.
  ///
  /// Example:
  /// ```
  /// -----END PUBLIC KEY-----
  /// ```
  static const END_PUBLIC_KEY = "-----END PUBLIC KEY-----";

  /// Header for a generic private key block.
  ///
  /// Example:
  /// ```
  /// -----BEGIN PRIVATE KEY-----
  /// ```
  static const BEGIN_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----";

  /// Footer for a generic private key block.
  ///
  /// Example:
  /// ```
  /// -----END PRIVATE KEY-----
  /// ```
  static const END_PRIVATE_KEY = "-----END PRIVATE KEY-----";

  // RSA PEM delimiters

  /// Header for an RSA public key block.
  ///
  /// Used when encoding/decoding RSA public keys.
  static const BEGIN_PUBLIC_RSA_KEY = "-----BEGIN RSA PUBLIC KEY-----";

  /// Footer for an RSA public key block.
  static const END_PUBLIC_RSA_KEY = "-----END RSA PUBLIC KEY-----";

  /// Header for an RSA private key block.
  static const BEGIN_PRIVATE_RSA_KEY = "-----BEGIN RSA PRIVATE KEY-----";

  /// Footer for an RSA private key block.
  static const END_PRIVATE_RSA_KEY = "-----END RSA PRIVATE KEY-----";

  // EC PEM delimiters

  /// Header for an EC (Elliptic Curve) public key block.
  ///
  /// Used when encoding/decoding EC public keys.
  static const BEGIN_PUBLIC_EC_KEY = "-----BEGIN EC PUBLIC KEY-----";

  /// Footer for an EC public key block.
  static const END_PUBLIC_EC_KEY = "-----END EC PUBLIC KEY-----";

  /// Header for an EC (Elliptic Curve) private key block.
  ///
  /// Used when encoding/decoding EC private keys.
  static const BEGIN_PRIVATE_EC_KEY = "-----BEGIN EC PRIVATE KEY-----";

  /// Footer for an EC private key block.
  static const END_PRIVATE_EC_KEY = "-----END EC PRIVATE KEY-----";
}