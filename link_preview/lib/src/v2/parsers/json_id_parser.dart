import 'dart:convert';

import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';
import 'og_parser.dart';

/// Parses [LinkPreviewData] from `json-ld` data in `<script>` tags.
class JsonLdParser with BaseMetaInfo {
  /// The [Document] to parse.
  Document? document;
  dynamic _jsonData;

  JsonLdParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document? document) {
    final data = document?.head
        ?.querySelector("script[type='application/ld+json']")
        ?.innerHtml;
    if (data == null) return null;
    // For multiline json file
    // Replacing all new line characters with empty space
    // before performing json decode on data
    return jsonDecode(data.replaceAll('\n', ' '));
  }

  /// Get the [LinkPreviewData.title] from the <title> tag.
  @override
  String? get title {
    final data = _jsonData;
    if (data is List) {
      return data.first['name'];
    } else if (data is Map) {
      return data.get('name') ?? data.get('headline');
    }
    return null;
  }

  /// Get the [LinkPreviewData.desc] from the content of the
  /// <meta name="description"> tag.
  @override
  String? get description {
    final data = _jsonData;
    if (data is List) {
      return data.first['description'] ?? data.first['headline'];
    } else if (data is Map) {
      return data.get('description') ?? data.get('headline');
    }
    return null;
  }

  /// Get the [LinkPreviewData.image] from the first <img> tag in the body.
  @override
  LinkPreviewImage? get image {
    String? img;
    final data = _jsonData;
    if (data is List && data.isNotEmpty) {
      img = _imgResultToStr(data.first['logo'] ?? data.first['image']);
    } else if (data is Map) {
      img = _imgResultToStr(data.getDynamic('logo') ?? data.getDynamic('image'));
    }

    double h = 0.0;
    double w = 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  /// JSON LD does not have a siteName property, so we get it from
  /// [og:site_name] if available.
  @override
  String? get siteName => OpenGraphParser(document).siteName;

  String? _imgResultToStr(dynamic result) {
    if (result is List && result.isNotEmpty) result = result.first;
    if (result is String) return result;
    return null;
  }

  @override
  String toString() => parse().toString();
}