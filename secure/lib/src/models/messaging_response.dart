import 'dart:convert';

import 'package:secure/secure.dart';

/// {@template messaging_response}
/// Represents a messaging response that includes a message and its metadata.
///
/// This class provides methods for serializing and deserializing the response,
/// including support for both RSA and EC cryptographic styles.
/// 
/// {@endtemplate}
class MessagingResponse {
  /// The content of the message.
  final String message;

  /// Metadata associated with the message.
  final MessagingMetadata metadata;

  /// Creates a [MessagingResponse] instance.
  ///
  /// - [message]: The message content.
  /// - [metadata]: Metadata related to the message.
  /// 
  /// {@macro messaging_response}
  MessagingResponse({
    required this.message,
    required this.metadata,
  });

  /// Factory constructor to create a [MessagingResponse] from a string.
  ///
  /// - [source]: The input string, either as JSON or plain text.
  /// - [type]: The cryptographic style (RSA or EC). Defaults to [PemStyle.RSA].
  ///
  /// If the string cannot be decoded as JSON, it is treated as plain text (legacy format).
  factory MessagingResponse.fromString(String source, {PemStyle type = PemStyle.RSA}) {
    return type == PemStyle.EC ? _fromEC(source) : _fromRSA(source);
  }

  /// Converts the [MessagingResponse] instance to a JSON map.
  ///
  /// Returns a `Map<String, dynamic>` containing the message and metadata.
  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "metadata": metadata.toJson(),
    };
  }

  /// Converts the [MessagingResponse] instance to a JSON string.
  @override
  String toString() => json.encode(toJson());

  /// Private factory method to create a [MessagingResponse] for RSA messages.
  ///
  /// - [source]: The input string, either as JSON or plain text.
  ///
  /// If decoding as JSON fails, the input is treated as plain text (legacy format).
  static MessagingResponse _fromRSA(String source) {
    try {
      final decodedJson = json.decode(source) as Map<String, dynamic>;
      return _fromJson(decodedJson);
    } catch (e) {
      return MessagingResponse(
        message: source,
        metadata: MessagingMetadata(
          enc: "RSA",
          sign: "legacy",
          type: "RSA",
        ),
      );
    }
  }

  /// Private factory method to create a [MessagingResponse] for EC messages.
  ///
  /// - [source]: The input string, either as JSON or plain text.
  ///
  /// If decoding as JSON fails, the input is treated as plain text (legacy format).
  static MessagingResponse _fromEC(String source) {
    try {
      final decodedJson = json.decode(source) as Map<String, dynamic>;
      return _fromJson(decodedJson);
    } catch (e) {
      return MessagingResponse(
        message: source,
        metadata: MessagingMetadata(
          enc: "EC",
          sign: "legacy",
          type: "EC",
        ),
      );
    }
  }

  /// Private method to create a [MessagingResponse] instance from a JSON map.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the message and metadata.
  ///
  /// Missing fields default to empty strings or empty objects.
  static MessagingResponse _fromJson(Map<String, dynamic> json) {
    return MessagingResponse(
      message: json["message"] ?? "",
      metadata: MessagingMetadata.fromJson(json["metadata"] ?? {}),
    );
  }
}