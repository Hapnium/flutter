import 'dart:convert';

/// {@template messaging_metadata}
/// Represents metadata associated with a secure message.
///
/// This class contains key details about the encryption, signature,
/// and type of the message. It provides methods to serialize and
/// deserialize the metadata to and from JSON and base64-encoded strings.
/// 
/// {@endtemplate}
class MessagingMetadata {
  /// The encryption scheme or related data.
  final String enc;

  /// The type of the message (e.g., RSA, EC).
  final String type;

  /// The signature or related identifier.
  final String sign;

  /// Creates a [MessagingMetadata] instance.
  ///
  /// - [enc]: Encryption-related information.
  /// - [sign]: Signature or identifier for validation.
  /// - [type]: The type of the message.
  /// 
  /// {@macro messaging_metadata}
  MessagingMetadata({
    required this.enc,
    required this.sign,
    required this.type,
  });

  /// Factory constructor to create a [MessagingMetadata] instance from a JSON map.
  ///
  /// - [json]: The JSON map containing metadata properties.
  ///
  /// If any field is missing in the JSON, it defaults to an empty string.
  factory MessagingMetadata.fromJson(Map<String, dynamic> json) {
    return MessagingMetadata(
      enc: json["enc"] ?? "",
      sign: json["sign"] ?? "",
      type: json["type"] ?? "",
    );
  }

  /// Converts the [MessagingMetadata] instance to a JSON map.
  ///
  /// Returns a `Map<String, dynamic>` representing the metadata.
  Map<String, dynamic> toJson() {
    return {
      "enc": enc,
      "sign": sign,
      "type": type,
    };
  }

  /// Factory constructor to create a [MessagingMetadata] instance from a base64-encoded string.
  ///
  /// - [source]: A base64-encoded string containing the JSON representation of metadata.
  ///
  /// Decodes the string, parses it as JSON, and converts it to a [MessagingMetadata] instance.
  factory MessagingMetadata.fromString(String source) {
    final decodedJson = json.decode(utf8.decode(base64Decode(source)));
    return MessagingMetadata.fromJson(decodedJson);
  }

  /// Converts the [MessagingMetadata] instance to a base64-encoded string.
  ///
  /// Encodes the metadata as JSON and then encodes the JSON string in base64.
  @override
  String toString() {
    final jsonString = json.encode(toJson());
    return base64Encode(utf8.encode(jsonString));
  }
}