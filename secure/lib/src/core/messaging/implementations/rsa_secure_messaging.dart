import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:secure/secure.dart';

import '../../../utilities/pem_delimiter.dart';
import '../../../utilities/rsa_utils.dart';
import '../../../utilities/secure_utils.dart';
import '../secure_messaging_service.dart';

/// RSA implementation of the [SecureMessagingService].
///
/// This class provides RSA-based encryption and decryption functionalities
/// for secure messaging. It extends the [SecureMessaging] class and implements
/// the [SecureMessagingService] interface.
class RSASecureMessaging extends SecureMessaging implements SecureMessagingService {
  /// RSA implementation of the [SecureMessagingService].
  ///
  /// This class provides RSA-based encryption and decryption functionalities
  /// for secure messaging. It extends the [SecureMessaging] class and implements
  /// the [SecureMessagingService] interface.
  RSASecureMessaging() : super(PemStyle.RSA);

  OAEPEncoding _getEncoding() => OAEPEncoding(RSAEngine());

  @override
  String encrypt({required String message, required String publicKey}) {
    if (publicKey.startsWith(PemDelimiter.BEGIN_PUBLIC_EC_KEY)) {
      return SecureMessaging.ec().encrypt(message: message, publicKey: publicKey);
    }

    try {
      PublicKeyParameter<RSAPublicKey> params = PublicKeyParameter<RSAPublicKey>(RSAUtils.decodePublicKey(publicKey));
      OAEPEncoding encoding = _getEncoding()..init(true, params);

      MessagingResponse response = MessagingResponse(
        message: message,
        metadata: MessagingMetadata(enc: "RSA", sign: "${DateTime.timestamp()}", type: "RSA")
      );
      Uint8List encryptedBytes = encoding.process(utf8.encode(response.toString()));

      return base64Encode(encryptedBytes);
    } catch (e) {
      throw SecureException("RSA Message encryption failed: $e");
    }
  }

  @override
  MessagingResponse decrypt({required String message, required String privateKey}) {
    if (privateKey.startsWith(PemDelimiter.BEGIN_PRIVATE_EC_KEY)) {
      return SecureMessaging.ec().decrypt(message: message, privateKey: privateKey);
    }

    try {
      PrivateKeyParameter<RSAPrivateKey> params = PrivateKeyParameter<RSAPrivateKey>(RSAUtils.decodePrivateKey(privateKey));
      OAEPEncoding encoding = _getEncoding()..init(false, params);

      Uint8List decryptedBytes = encoding.process(base64Decode(message));
      String source = utf8.decode(decryptedBytes);

      return MessagingResponse.fromString(source);
    } catch (e) {
      throw SecureException("RSA Message decryption failed: $e");
    }
  }

  @override
  SecureKeyResponse generate() {
    try {
      SecureRandom secureRandom = SecureUtils.create();

      RSAKeyGeneratorParameters genParams = RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64);
      ParametersWithRandom<RSAKeyGeneratorParameters> params = ParametersWithRandom(genParams, secureRandom,);

      RSAKeyGenerator keyGen = RSAKeyGenerator()..init(params);
      AsymmetricKeyPair<PublicKey, PrivateKey> pair = keyGen.generateKeyPair();

      RSAPrivateKey privateKey = pair.privateKey as RSAPrivateKey;
      RSAPublicKey publicKey = pair.publicKey as RSAPublicKey;

      return SecureKeyResponse(publicKey: RSAUtils.encodePublicKey(publicKey), privateKey: RSAUtils.encodePrivateKey(privateKey));
    } catch (e) {
      throw SecureException("RSA Key pair generation failed: $e");
    }
  }
}
