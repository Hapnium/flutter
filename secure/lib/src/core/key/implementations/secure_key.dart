import 'secure_key_factory.dart';
import '../secure_key_service.dart';

/// {@template secure_key_abstract}
/// An abstract base class for secure key operations including:
/// - Key generation
/// - Encryption
/// - Decryption
///
/// This class acts as a common interface and uses a factory constructor
/// to delegate implementation details to [SecureKeyFactory].
/// {@endtemplate}
abstract class SecureKey implements SecureKeyService {
  /// {@macro secure_key_abstract}
  SecureKey();

  /// Factory constructor that returns the default implementation of [SecureKeyService].
  ///
  /// Currently returns an instance of [SecureKeyFactory].
  /// 
  /// {@macro secure_key_factory}
  factory SecureKey.factory() {
    return SecureKeyFactory();
  }
}