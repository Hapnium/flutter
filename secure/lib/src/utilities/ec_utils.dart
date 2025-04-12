import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

import '../enums/pem_mode.dart';
import 'pem.dart';

/// Utility class for handling EC key encoding and decoding.
class ECUtils {
  static ECDomainParameters parameters = ECCurve_secp128r1();

  /// Encodes an [ECPublicKey] to PEM format.
  ///
  /// The [publicKey] parameter is the EC public key to encode.
  ///
  /// Returns the PEM-formatted public key as a `String`.
  ///
  /// Example:
  /// ```dart
  /// ECPublicKey publicKey = ECPublicKey(BigInt.parse('modulus'), BigInt.parse('exponent'));
  /// String pem = ECUtils.encodePublicKey(publicKey);
  /// print(pem);
  /// ```
  static String encodePublicKey(ECPublicKey publicKey) {
    return Pem.encode(publicKey.Q!.getEncoded(), PemMode.PUBLIC_EC);
  }

  /// Decodes a PEM-formatted public key into an [ECPublicKey].
  ///
  /// The [pem] parameter is the PEM-formatted public key as a `String`.
  ///
  /// Returns an `ECPublicKey` object.
  ///
  /// Example:
  /// ```dart
  /// String pem = '-----BEGIN EC PUBLIC KEY-----...';
  /// ECPublicKey publicKey = ECUtils.decodePublicKey(pem);
  /// print(publicKey.modulus);
  /// ```
  static ECPublicKey decodePublicKey(String pem) {
    Uint8List encoded = Pem.decode(pem, PemMode.PUBLIC_EC);

    return ECPublicKey(parameters.curve.decodePoint(encoded), parameters);
  }

  /// Encodes an [ECPrivateKey] to PEM format.
  ///
  /// The [privateKey] parameter is the EC private key to encode.
  ///
  /// Returns the PEM-formatted private key as a `String`.
  ///
  /// Example:
  /// ```dart
  /// ECPrivateKey privateKey = ECPrivateKey(
  ///   BigInt.parse('modulus'),
  ///   BigInt.parse('privateExponent'),
  ///   BigInt.parse('p'),
  ///   BigInt.parse('q')
  /// );
  /// String pem = ECUtils.encodePrivateKey(privateKey);
  /// print(pem);
  /// ```
  static String encodePrivateKey(ECPrivateKey privateKey) {
    final sequence = ASN1Sequence()
      ..add(ASN1IA5String(stringValue: "${privateKey.d!}"));

    return Pem.encode(sequence.encode(), PemMode.PRIVATE_EC);
  }

  /// Decodes a PEM-formatted private key into an [ECPrivateKey].
  ///
  /// The [pem] parameter is the PEM-formatted private key as a `String`.
  ///
  /// Returns an `ECPrivateKey` object.
  ///
  /// Example:
  /// ```dart
  /// String pem = '-----BEGIN EC PRIVATE KEY-----...';
  /// ECPrivateKey privateKey = ECUtils.decodePrivateKey(pem);
  /// print(privateKey.modulus);
  /// ```
  static ECPrivateKey decodePrivateKey(String pem) {
    ASN1Parser asn1Parser = ASN1Parser(Pem.decode(pem, PemMode.PRIVATE_EC));
    ASN1Sequence sequence = asn1Parser.nextObject() as ASN1Sequence;

    BigInt modulus = BigInt.parse((sequence.elements![0] as ASN1IA5String).stringValue!);

    return ECPrivateKey(modulus, parameters);
  }

  static Uint8List getSharedSecret(ECPoint point, BigInt? key) => (point * key)!.getEncoded(false);

  static Uint8List deriveAesKey(Uint8List ephPublicKey, Uint8List sharedSecret) {
    Uint8List input = Uint8List.fromList(ephPublicKey + sharedSecret);
    Uint8List aesKey = Uint8List(32);

    HKDFKeyDerivator derive = HKDFKeyDerivator(SHA256Digest());
    derive.init(HkdfParameters(input, 32, null));
    derive.deriveKey(null, 0, aesKey, 0);

    return aesKey;
  }
}