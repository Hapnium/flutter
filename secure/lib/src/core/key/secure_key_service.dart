import 'package:secure/secure.dart';

/// Abstract class defining the interface for a service handling end-to-end encryption (E2EE) operations.
///
/// This service provides methods for:
///   - Generating key pairs (public and private) for secure communication.
///   - Encrypting messages using the recipient's public key.
///   - Decrypting messages using the user's private key.
///
/// Concrete implementations of this class should provide the underlying cryptographic logic.
abstract class SecureKeyService {
  /// Generates a new key pair (public and private).
  ///
  /// This method typically involves:
  ///   1. Deriving a key from a secure source or generating a new key.
  ///   2. Generating an asymmetric key pair (e.g., using RSA or ECC).
  ///   3. Securely storing the private key locally (e.g., in a secure storage or encrypted database).
  ///   4. Returning a `SecureKeyResponse` object containing the public key.
  ///
  /// **Returns:**
  ///
  /// A `SecureKeyResponse` object containing the generated public key.
  SecureKeyResponse generate(String identifier);

  /// Encrypts the given `message` using the provided `publicKey` of the recipient.
  ///
  /// This method typically uses an asymmetric encryption algorithm
  /// (e.g., RSA, ElGamal) to encrypt the message.
  ///
  /// **Parameters:**
  ///
  /// * `message`: The message to be encrypted.
  /// * `publicKey`: The recipient's public key in Base64-encoded format.
  ///
  /// **Returns:**
  ///
  /// The encrypted message, typically in Base64-encoded format.
  String encrypt({required String message, required String publicKey});

  /// Decrypts the given `encryptedMessage` using the user's private key.
  ///
  /// This method typically uses the corresponding private key to decrypt the message.
  ///
  /// **Parameters:**
  ///
  /// * `message`: The encrypted message in Base64-encoded format.
  /// * `privateKey`: The user's private key in Base64-encoded format.
  ///
  /// **Returns:**
  ///
  /// A `MessagingResponse` object containing the decrypted message or an error message.
  String decrypt({required String message, required String privateKey});
}