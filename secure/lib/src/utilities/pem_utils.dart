import 'package:secure/src/enums/pem_style.dart';
import 'package:secure/src/utilities/pem_delimiter.dart';

/// {@template pem_utils}
/// A utility class for encoding and decoding RSA or EC keys in PEM format.
///
/// PEM (Privacy-Enhanced Mail) format represents keys as base64 strings wrapped
/// with delimiter lines like `-----BEGIN RSA PUBLIC KEY-----`.
///
/// This class handles:
/// - Encoding base64 strings to PEM-wrapped keys
/// - Decoding PEM-wrapped keys back to base64
/// - Proper formatting for RSA (with line breaks) and EC (compact) styles
///
/// Supported key types are defined by [PemStyle].
/// {@endtemplate}
class PemUtils {
  /// {@macro pem_utils}
  PemUtils._();

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

  /// Adds line breaks to a base64 string every 64 characters.
  ///
  /// This is used for formatting RSA keys according to PEM standards.
  ///
  /// Example:
  /// ```
  /// MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...
  /// becomes:
  /// MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
  /// ...
  /// ```
  static String _addBreaks(String base64Key) {
    const chunkSize = 64;
    final buffer = StringBuffer();

    for (var i = 0; i < base64Key.length; i += chunkSize) {
      buffer.writeln(base64Key.substring(i, i + chunkSize > base64Key.length ? base64Key.length : i + chunkSize));
    }

    return buffer.toString().trim();
  }
}