import 'package:secure/src/enums/pem_style.dart';
import 'package:secure/src/utilities/pem_delimiter.dart';

/// A utility class for encoding and decoding keys in PEM format.
class PemUtils {
  /// Encodes a public key in base64 format to PEM format.
  ///
  /// [base64Key]: The public key in base64 encoding.
  /// [style]: The key type (`RSA` or `EC`).
  ///
  /// Returns the key as a PEM-formatted string.
  static String encodePublicKey(String base64Key, PemStyle style) {
    bool isRSA = style == PemStyle.RSA;

    final header = isRSA ? PemDelimiter.BEGIN_PUBLIC_RSA_KEY : PemDelimiter.BEGIN_PUBLIC_EC_KEY;
    final footer = isRSA ? PemDelimiter.END_PUBLIC_RSA_KEY : PemDelimiter.END_PUBLIC_EC_KEY;

    if(isRSA) {
      return "$header\n${_addBreaks(base64Key)}\n$footer";
    } else {
      return "$header$base64Key$footer";
    }
  }

  /// Encodes a private key in base64 format to PEM format.
  ///
  /// [base64Key]: The private key in base64 encoding.
  /// [style]: The key type (`RSA` or `EC`).
  ///
  /// Returns the key as a PEM-formatted string.
  static String encodePrivateKey(String base64Key, PemStyle style) {
    bool isRSA = style == PemStyle.RSA;

    final header = isRSA ? PemDelimiter.BEGIN_PRIVATE_RSA_KEY : PemDelimiter.BEGIN_PRIVATE_EC_KEY;
    final footer = isRSA ? PemDelimiter.END_PRIVATE_RSA_KEY : PemDelimiter.END_PRIVATE_EC_KEY;

    if(isRSA) {
      return "$header\n${_addBreaks(base64Key)}\n$footer";
    } else {
      return "$header$base64Key$footer";
    }
  }

  /// Decodes a PEM-formatted public key to its base64 representation.
  ///
  /// [pem]: The PEM-formatted public key string.
  /// [style]: The key type (`RSA` or `EC`).
  ///
  /// Returns the public key as a base64-encoded string.
  static String decodePublicKey(String pem, PemStyle style) {
    String header = pem.startsWith(PemDelimiter.BEGIN_PUBLIC_KEY)
        ? PemDelimiter.BEGIN_PUBLIC_KEY
        : style == PemStyle.RSA ? PemDelimiter.BEGIN_PUBLIC_RSA_KEY : PemDelimiter.BEGIN_PUBLIC_EC_KEY;
    String footer = pem.endsWith(PemDelimiter.END_PUBLIC_KEY)
        ? PemDelimiter.END_PUBLIC_KEY
        : style == PemStyle.RSA ? PemDelimiter.END_PUBLIC_RSA_KEY : PemDelimiter.END_PUBLIC_EC_KEY;

    return pem.replaceAll(header, '').replaceAll(footer, '').replaceAll('\n', '');
  }

  /// Decodes a PEM-formatted private key to its base64 representation.
  ///
  /// [pem]: The PEM-formatted private key string.
  /// [style]: The key type (`RSA` or `EC`).
  ///
  /// Returns the private key as a base64-encoded string.
  static String decodePrivateKey(String pem, PemStyle style) {
    String header = pem.startsWith(PemDelimiter.BEGIN_PRIVATE_KEY)
        ? PemDelimiter.BEGIN_PRIVATE_KEY
        : style == PemStyle.RSA ? PemDelimiter.BEGIN_PRIVATE_RSA_KEY : PemDelimiter.BEGIN_PRIVATE_EC_KEY;
    String footer = pem.endsWith(PemDelimiter.END_PRIVATE_KEY)
        ? PemDelimiter.END_PRIVATE_KEY
        : style == PemStyle.RSA ? PemDelimiter.END_PRIVATE_RSA_KEY : PemDelimiter.END_PRIVATE_EC_KEY;

    return pem.replaceAll(header, '').replaceAll(footer, '').replaceAll('\n', '');
  }

  /// Helper method to add line breaks to base64-encoded strings.
  ///
  /// Splits the string into chunks of 64 characters, as required by PEM format.
  static String _addBreaks(String base64Key) {
    const chunkSize = 64;
    final buffer = StringBuffer();

    for (var i = 0; i < base64Key.length; i += chunkSize) {
      buffer.writeln(base64Key.substring(i, i + chunkSize > base64Key.length ? base64Key.length : i + chunkSize));
    }

    return buffer.toString().trim();
  }
}