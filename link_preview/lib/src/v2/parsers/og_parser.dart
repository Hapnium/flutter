import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';

/// Parses [LinkPreviewData] from `<meta property='og:*'>` tags.
class OpenGraphParser with BaseMetaInfo {
  /// The [Document] to parse.
  final Document? _document;

  OpenGraphParser(this._document);

  /// Get [LinkPreviewData.title] from 'og:title'.
  @override
  String? get title => getProperty(_document, property: 'og:title');

  /// Get [LinkPreviewData.desc] from 'og:description'.
  @override
  String? get description => getProperty(_document, property: 'og:description');

  /// Get [LinkPreviewData.image] from 'og:image'.
  @override
  LinkPreviewImage? get image {
    String? img = getProperty(_document, property: 'og:image');
    double h = double.tryParse(_document?.body?.querySelector('og:image')?.attributes.get('height') ?? "0.0") ?? 0.0;
    double w = double.tryParse(_document?.body?.querySelector('og:image')?.attributes.get('width') ?? "0.0") ?? 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  /// Get [LinkPreviewData.siteName] from 'og:site_name'.
  @override
  String? get siteName => getProperty(_document, property: 'og:site_name');

  /// Get [LinkPreviewData.url] from 'og:url'.
  @override
  String? get url => getProperty(_document, property: 'og:url');

  @override
  String toString() => parse().toString();
}