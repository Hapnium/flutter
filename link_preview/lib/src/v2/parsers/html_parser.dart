import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';

/// Parses [LinkPreviewData] from `<meta>`, `<title>`, and `<img>` tags.
class HtmlMetaParser with BaseMetaInfo {
  /// The [Document] to parse.
  final Document? _document;

  HtmlMetaParser(this._document);

  /// Get the [LinkPreviewData.title] from the <title> tag.
  @override
  String? get title => _document?.head?.querySelector('title')?.text;

  /// Get the [LinkPreviewData.desc] from the content of the
  /// <meta name="description"> tag.
  @override
  String? get description => _document?.head
      ?.querySelector("meta[name='description']")
      ?.attributes
      .get('content');

  /// Get the [LinkPreviewData.image] from the first <img> tag in the body.
  @override
  LinkPreviewImage? get image {
    String? img = _document?.body?.querySelector('img')?.attributes.get('src');
    double h = double.tryParse(_document?.body?.querySelector('img')?.attributes.get('height') ?? "0.0") ?? 0.0;
    double w = double.tryParse(_document?.body?.querySelector('img')?.attributes.get('width') ?? "0.0") ?? 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  /// Get the [LinkPreviewData.siteName] from the content of the
  /// <meta name="site_name"> meta tag.
  @override
  String? get siteName => _document?.head
      ?.querySelector("meta[name='site_name']")
      ?.attributes
      .get('content');

  @override
  String toString() => parse().toString();
}