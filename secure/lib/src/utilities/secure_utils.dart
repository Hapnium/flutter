import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';

/// {@template secure_utils}
/// Utility class for generating cryptographically secure random values
/// using the Fortuna algorithm provided by the PointyCastle library.
///
/// The [SecureUtils] class provides static utility methods for secure
/// randomness, useful in cryptographic operations such as key generation,
/// nonce creation, and secure token generation.
///
/// This class uses Dart’s [Random.secure()] to produce a high-entropy
/// seed, which is then used to initialize a [FortunaRandom] instance.
/// This generator can produce secure random bytes.
///
/// Example usage:
/// ```dart
/// SecureRandom secureRandom = SecureUtils.create();
/// Uint8List randomBytes = secureRandom.nextBytes(16);
/// ```
/// {@endtemplate}
class SecureUtils {
  /// {@macro secure_utils}
  SecureUtils._();

  /// Creates a cryptographically secure random number generator (CSPRNG) using Fortuna algorithm.
  ///
  /// This method utilizes Dart's [Random.secure()] to generate a secure random seed and
  /// then uses that seed to initialize the Fortuna random number generator for cryptographic
  /// purposes, ensuring a high level of randomness suitable for security-related tasks.
  ///
  /// Returns a [SecureRandom] instance, which can be used to generate cryptographically
  /// secure random bytes.
  ///
  /// Example usage:
  /// ```dart
  /// SecureRandom secureRandom = createSecureRandom();
  /// ```
  static SecureRandom create() {
    Random random = Random.secure();
    Uint8List seed = Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));

    // Return the secure random generator
    return FortunaRandom()..seed(KeyParameter(seed));
  }
}