/// Defines the available modes for PEM (Privacy-Enhanced Mail) formatted keys.
///
/// PEM files are commonly used to represent cryptographic keys. This enum helps
/// categorize the different types of keys supported in the system.
///
/// ### Variants:
/// - `PUBLIC_RSA`: Represents a PEM-formatted public key using the RSA algorithm.
/// - `PRIVATE_RSA`: Represents a PEM-formatted private key using the RSA algorithm.
/// - `PUBLIC_EC`: Represents a PEM-formatted public key using the Elliptic Curve (EC) algorithm.
/// - `PRIVATE_EC`: Represents a PEM-formatted private key using the Elliptic Curve (EC) algorithm.
///
/// ### Example:
/// ```dart
/// PemMode mode = PemMode.PUBLIC_RSA;
/// switch (mode) {
///   case PemMode.PUBLIC_RSA:
///     print("Using an RSA public key.");
///     break;
///   case PemMode.PRIVATE_RSA:
///     print("Using an RSA private key.");
///     break;
///   case PemMode.PUBLIC_EC:
///     print("Using an EC public key.");
///     break;
///   case PemMode.PRIVATE_EC:
///     print("Using an EC private key.");
///     break;
/// }
/// ```
///
/// This enum is useful for determining the appropriate key parsing or processing logic
/// based on the type of key being handled.
enum PemMode {
  /// Represents a PEM-formatted public key using the RSA algorithm.
  PUBLIC_RSA,

  /// Represents a PEM-formatted private key using the RSA algorithm.
  PRIVATE_RSA,

  /// Represents a PEM-formatted public key using the Elliptic Curve (EC) algorithm.
  PUBLIC_EC,

  /// Represents a PEM-formatted private key using the Elliptic Curve (EC) algorithm.
  PRIVATE_EC,
}