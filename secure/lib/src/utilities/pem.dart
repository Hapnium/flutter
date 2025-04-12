import 'dart:convert';
import 'dart:typed_data';

import 'package:secure/src/enums/pem_mode.dart';
import 'package:secure/src/enums/pem_style.dart';
import 'package:secure/src/utilities/pem_utils.dart';

/// Utility class for handling PEM encoding and decoding.
class Pem {
  /// Encodes a given key into PEM format based on the provided [PemMode].
  ///
  /// The [key] is a `Uint8List` representation of the key.
  /// The [mode] determines whether the key is a private/public key
  /// and whether it uses EC or RSA.
  ///
  /// Returns the encoded key as a `String` in PEM format.
  ///
  /// Throws:
  /// - Exception if the [PemMode] is invalid.
  static String encode(Uint8List key, PemMode mode) {
    String base64Key = base64Encode(key);

    if (mode == PemMode.PRIVATE_EC) {
      return PemUtils.encodePrivateKey(base64Key, PemStyle.EC);
    } else if (mode == PemMode.PRIVATE_RSA) {
      return PemUtils.encodePrivateKey(base64Key, PemStyle.RSA);
    } else if (mode == PemMode.PUBLIC_EC) {
      return PemUtils.encodePublicKey(base64Key, PemStyle.EC);
    } else {
      return PemUtils.encodePublicKey(base64Key, PemStyle.RSA);
    }
  }

  /// Decodes a PEM-formatted key string into a `Uint8List`.
  ///
  /// The [pem] is the PEM-formatted key as a `String`.
  /// The [mode] determines the type of key (private/public, EC/RSA).
  ///
  /// Returns the decoded key as a `Uint8List`.
  ///
  /// Throws:
  /// - Exception if the [PemMode] is invalid.
  static Uint8List decode(String pem, PemMode mode) {
    String key;
    if (mode == PemMode.PRIVATE_EC) {
      key = PemUtils.decodePrivateKey(pem, PemStyle.EC);
    } else if (mode == PemMode.PRIVATE_RSA) {
      key = PemUtils.decodePrivateKey(pem, PemStyle.RSA);
    } else if (mode == PemMode.PUBLIC_EC) {
      key = PemUtils.decodePublicKey(pem, PemStyle.EC);
    } else {
      key = PemUtils.decodePublicKey(pem, PemStyle.RSA);
    }

    return base64Decode(key);
  }
}