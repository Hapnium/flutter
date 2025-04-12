/// Specifies the cryptographic algorithm style for PEM (Privacy-Enhanced Mail) formatted keys.
///
/// PEM files are commonly used to store cryptographic keys and certificates.
/// This enum helps identify the algorithm style of the key being used.
///
/// ### Variants:
/// - `RSA`: Represents keys that use the RSA (Rivest–Shamir–Adleman) cryptographic algorithm.
/// - `EC`: Represents keys that use the EC (Elliptic Curve) cryptographic algorithm.
///
/// ### Example:
/// ```dart
/// PemStyle style = PemStyle.RSA;
/// switch (style) {
///   case PemStyle.RSA:
///     print("Using an RSA key.");
///     break;
///   case PemStyle.EC:
///     print("Using an Elliptic Curve key.");
///     break;
/// }
/// ```
///
/// This enum is useful for determining the type of key being handled and for choosing
/// the appropriate cryptographic processing or validation logic.
enum PemStyle {
  /// Represents keys that use the RSA (Rivest–Shamir–Adleman) cryptographic algorithm.
  RSA,

  /// Represents keys that use the EC (Elliptic Curve) cryptographic algorithm.
  EC,
}