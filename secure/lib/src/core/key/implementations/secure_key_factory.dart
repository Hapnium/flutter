import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/ec_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

import '../../../exceptions/secure_exception.dart';
import '../../../models/secure_key_response.dart';
import '../../../utilities/ec_utils.dart';
import '../../messaging/implementations/secure_messaging.dart';
import '../secure_key_service.dart';
import 'secure_key.dart';

class SecureKeyFactory extends SecureKey implements SecureKeyService {
  @override
  String decrypt({required String message, required String privateKey}) {
    return SecureMessaging.ec().decrypt(message: message, privateKey: privateKey).message;
  }

  @override
  String encrypt({required String message, required String publicKey}) {
    return SecureMessaging.ec().encrypt(message: message, publicKey: publicKey);
  }

  @override
  SecureKeyResponse generate(String identifier) {
    try {
      final passwordBytes = utf8.encode(identifier);

      // Ensure we have at least 32 bytes by repeating or cycling
      final expandedBytes = List<int>.generate(32, (i) => passwordBytes[i % passwordBytes.length]);

      // Perform a simple transformation (XOR with shifted values)
      for (int i = 0; i < 32; i++) {
        expandedBytes[i] ^= (expandedBytes[(i + 1) % 32] << 3) & 0xFF;
      }

      final seed = Uint8List.fromList(expandedBytes);

      // Generate RSA key pair
      final secureRandom = _createSecureRandom(Uint8List.fromList(seed));
      ECKeyGeneratorParameters genParams = ECKeyGeneratorParameters(ECUtils.parameters);
      ParametersWithRandom<ECKeyGeneratorParameters> params = ParametersWithRandom(genParams, secureRandom,);

      ECKeyGenerator keyGen = ECKeyGenerator()..init(params);

      AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = keyGen.generateKeyPair();

      ECPrivateKey privateKey = keyPair.privateKey as ECPrivateKey;
      ECPublicKey publicKey = keyPair.publicKey as ECPublicKey;

      return SecureKeyResponse(publicKey: ECUtils.encodePublicKey(publicKey), privateKey: ECUtils.encodePrivateKey(privateKey));
    } catch (e) {
      throw SecureException("Key pair generation failed: $e");
    }
  }

  SecureRandom _createSecureRandom(Uint8List seed) {
    final secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }
}