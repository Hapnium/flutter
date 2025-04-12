import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class SecureUtils {
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