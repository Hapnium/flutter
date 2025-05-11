import 'dart:convert';
import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';

class YoutubeParser with BaseMetaInfo {
  /// The [document] to be parse
  Document? document;
  dynamic _jsonData;

  YoutubeParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document? document) {
    final data = document?.outerHtml
        .replaceAll('<html><head></head><body>', '')
        .replaceAll('</body></html>', '');
    if (data == null) return null;
    /* For multiline json file */
    // Replacing all new line characters with empty space
    // before performing json decode on data
    var d = jsonDecode(data.replaceAll('\n', ' '));
    return d;
  }

  /// Get the [LinkPreviewData.title] from the [<title>] tag
  @override
  String? get title {
    final data = _jsonData;
    if (data is List) {
      return data.first['title'];
    } else if (data is Map) {
      return data.get('title');
    }

    return null;
  }

  /// Get the [LinkPreviewData.image] from the first <img> tag in the body
  @override
  LinkPreviewImage? get image {
    final data = _jsonData;
    String? img;
    if (data is List && data.isNotEmpty) {
      img = _imgResultToStr(data.first['thumbnail_url']);
    } else if (data is Map) {
      img = _imgResultToStr(data.getDynamic('thumbnail_url'));
    }

    double h = 0.0;
    double w = 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  @override
  String? get siteName {
    final data = _jsonData;
    if (data is List) {
      return data.first['provider_name'];
    } else if (data is Map) {
      return data.get('provider_name');
    }

    return null;
  }

  @override
  String? get url {
    final data = _jsonData;
    if (data is List) {
      return data.first['provider_url'];
    } else if (data is Map) {
      return data.get('provider_url');
    }

    return null;
  }

  String? _imgResultToStr(dynamic result) {
    if (result is List && result.isNotEmpty) result = result.first;
    if (result is String) return result;
    return null;
  }

  @override
  String toString() => parse().toString();
}