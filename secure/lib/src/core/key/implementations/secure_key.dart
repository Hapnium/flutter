import 'secure_key_factory.dart';
import '../secure_key_service.dart';

abstract class SecureKey implements SecureKeyService {
  SecureKey();

  factory SecureKey.factory() {
    return SecureKeyFactory();
  }
}