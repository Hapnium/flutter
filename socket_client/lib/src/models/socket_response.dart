import 'dart:typed_data';

class SocketResponse {
  final String command;
  final Map<String, String> headers;
  final String? body;
  final Uint8List? binaryBody;
  final dynamic data;
  final bool hasData;
  final bool hasBody;

  SocketResponse({
    required this.command,
    this.headers = const {},
    this.body,
    this.binaryBody,
    this.data,
    this.hasData = false,
    this.hasBody = false
  });

  Map<String, dynamic> toJson() {
    return {
      "command": command,
      "headers": headers,
      "body": body,
      "binary_body": binaryBody,
      "data": data,
      "has_data": hasData,
      "has_body": hasBody
    };
  }
}