/// {@template secure_key_response}
/// Represents a secure key pair (public and private keys).
///
/// This class provides methods for serializing and deserializing the key pair.
/// 
/// {@endtemplate}
class SecureKeyResponse {
  /// The public key.
  final String publicKey;

  /// The private key.
  final String privateKey;

  /// Creates a [SecureKeyResponse] instance.
  ///
  /// - [publicKey]: The public key.
  /// - [privateKey]: The private key.
  /// 
  /// {@macro secure_key_response}
  SecureKeyResponse({
    required this.publicKey,
    required this.privateKey,
  });

  /// Factory constructor to create a [SecureKeyResponse] from a JSON map.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the public and private keys.
  ///
  /// Missing fields default to empty strings.
  factory SecureKeyResponse.fromJson(Map<String, dynamic> json) {
    return SecureKeyResponse(
      publicKey: json["public_key"] ?? "",
      privateKey: json["private_key"] ?? "",
    );
  }

  /// Factory constructor to create an empty [SecureKeyResponse].
  ///
  /// Both the public and private keys are initialized to empty strings.
  factory SecureKeyResponse.empty() => SecureKeyResponse(publicKey: "", privateKey: "");

  /// Converts the [SecureKeyResponse] instance to a JSON map.
  ///
  /// Returns a `Map<String, dynamic>` containing the public and private keys.
  Map<String, dynamic> toJson() {
    return {
      "public_key": publicKey,
      "private_key": privateKey,
    };
  }
}