import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:secure/secure.dart';

import '../../../utilities/ec_utils.dart';
import '../../../utilities/pem_delimiter.dart';
import '../../../utilities/secure_utils.dart';
import '../secure_messaging_service.dart';

/// {@template ec_secure_messaging}
/// EC (Elliptic Curve) implementation of the [SecureMessagingService].
///
/// This class provides EC-based encryption and decryption functionalities
/// for secure messaging. It extends the [SecureMessaging] class and implements
/// the [SecureMessagingService] interface.
/// 
/// {@endtemplate}
class ECSecureMessaging extends SecureMessaging implements SecureMessagingService {
  /// EC (Elliptic Curve) implementation of the [SecureMessagingService].
  ///
  /// This class provides EC-based encryption and decryption functionalities
  /// for secure messaging. It extends the [SecureMessaging] class and implements
  /// the [SecureMessagingService] interface.
  /// 
  /// {@macro ec_secure_messaging}
  ECSecureMessaging() : super(PemStyle.EC);

  final int macSize = 128;
  final Uint8List associatedData = Uint8List(0);

  GCMBlockCipher _getCipher() => GCMBlockCipher(AESEngine());

  @override
  String encrypt({required String message, required String publicKey}) {
    if (publicKey.startsWith(PemDelimiter.BEGIN_PUBLIC_RSA_KEY)) {
      return SecureMessaging.rsa().encrypt(message: message, publicKey: publicKey);
    }

    try {
      AsymmetricKeyPair<PublicKey, PrivateKey> sharedKey = _generate();
      ECPublicKey receiverPublicKey = ECUtils.decodePublicKey(publicKey);

      // Derive AES key
      Uint8List sharedSecret = ECUtils.getSharedSecret (receiverPublicKey.Q!, (sharedKey.privateKey as ECPrivateKey).d);
      Uint8List sharedPublicKey = (sharedKey.publicKey as ECPublicKey).Q!.getEncoded(false);
      Uint8List aesKey = ECUtils.deriveAesKey(sharedPublicKey, sharedSecret);
      Uint8List nonce = SecureUtils.create().nextBytes(16);

      // Encrypt using AES-256 GCM
      AEADParameters<KeyParameter> params = AEADParameters(KeyParameter(aesKey), macSize, nonce, associatedData);
      GCMBlockCipher cipher = _getCipher()..init(true, params);
      Uint8List encryptedBytes = cipher.process(utf8.encode(message));

      MessagingResponse response = MessagingResponse(
        message: base64Encode(encryptedBytes),
        metadata: MessagingMetadata(enc: base64Encode(sharedPublicKey), sign: base64Encode(nonce), type: "EC")
      );

      return base64Encode(utf8.encode(response.toString()));
    } catch (e) {
      throw SecureException("EC Message encryption failed: $e");
    }
  }

  @override
  MessagingResponse decrypt({required String message, required String privateKey}) {
    if (privateKey.startsWith(PemDelimiter.BEGIN_PRIVATE_RSA_KEY)) {
      return SecureMessaging.rsa().decrypt(message: message, privateKey: privateKey);
    }

    try {
      ECPrivateKey decodedPrivateKey = ECUtils.decodePrivateKey(privateKey);
      String source = utf8.decode(base64Decode(message));

      MessagingResponse response = MessagingResponse.fromString(source, type: PemStyle.EC);

      // Extract ephemeral public key and nonce from metadata
      Uint8List ephPublicKeyBytes = base64Decode(response.metadata.enc);
      Uint8List nonce = base64Decode(response.metadata.sign);
      ECPoint ephPublicKey = ECUtils.parameters.curve.decodePoint(ephPublicKeyBytes)!;

      // 3. Derive AES key
      Uint8List sharedSecret = ECUtils.getSharedSecret(ephPublicKey, decodedPrivateKey.d);
      Uint8List aesKey = ECUtils.deriveAesKey(ephPublicKeyBytes, sharedSecret);

      // 4. Decrypt using AES-256 GCM
      Uint8List ciphertextTag = base64Decode(response.message);
      AEADParameters<KeyParameter> params = AEADParameters(KeyParameter(aesKey), macSize, nonce, associatedData);
      GCMBlockCipher gcmCipher = _getCipher()..init(false, params);

      Uint8List plaintext = gcmCipher.process(ciphertextTag);

      return MessagingResponse(
        message: utf8.decode(plaintext),
        metadata: MessagingMetadata(enc: "EC", sign: "${DateTime.timestamp()}", type: "EC")
      );
    } catch (e) {
      throw SecureException("EC Message decryption failed: $e");
    }
  }

  @override
  SecureKeyResponse generate() {
    try {
      AsymmetricKeyPair<PublicKey, PrivateKey> pair = _generate();

      ECPrivateKey privateKey = pair.privateKey as ECPrivateKey;
      ECPublicKey publicKey = pair.publicKey as ECPublicKey;

      return SecureKeyResponse(publicKey: ECUtils.encodePublicKey(publicKey), privateKey: ECUtils.encodePrivateKey(privateKey));
    } catch (e) {
      throw SecureException("EC Key pair generation failed: $e");
    }
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> _generate() {
    SecureRandom secureRandom = SecureUtils.create();

    ECKeyGeneratorParameters genParams = ECKeyGeneratorParameters(ECUtils.parameters);
    ParametersWithRandom<ECKeyGeneratorParameters> params = ParametersWithRandom(genParams, secureRandom,);

    ECKeyGenerator keyGen = ECKeyGenerator()..init(params);
    return keyGen.generateKeyPair();
  }
}