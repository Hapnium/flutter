import 'dart:convert';
import 'dart:io';

class Utility {
  Utility._();
  static Utility instance = Utility._();

  String _decompress(String data) {
    // Decode Base64
    final compressedBytes = base64Decode(data);
    // Decompress using zlib (compatible with GZIP)
    final decompressedBytes = ZLibDecoder().convert(compressedBytes);

    // Convert back to String
    return utf8.decode(decompressedBytes);
  }

  dynamic decodeToJson(dynamic data) {
    try {
      if(data != null) {
        return jsonDecode(data);
      }
    } catch (_) {
      if(data != null && data is String) {
        return decodeToJson(_decompress(data));
      }
    }

    return data;
  }
}