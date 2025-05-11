import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';
import 'og_parser.dart';

/// Parses [LinkPreviewData] from `<meta property='twitter:*'>` tags.
class TwitterParser with BaseMetaInfo {
  /// The [Document] to parse.
  final Document? _document;

  TwitterParser(this._document);

  /// Get [LinkPreviewData.title] from 'twitter:title'
  @override
  String? get title => getProperty(_document, attribute: 'name', property: 'twitter:title')
      ?? getProperty(_document, property: 'twitter:title');

  /// Get [LinkPreviewData.desc] from 'twitter:description'
  @override
  String? get description => getProperty(_document, attribute: 'name', property: 'twitter:description')
      ?? getProperty(_document, property: 'twitter:description');

  /// Get [LinkPreviewData.image] from 'twitter:image'
  @override
  LinkPreviewImage? get image {
    String? img = getProperty(_document, attribute: 'name', property: 'twitter:image')
        ?? getProperty(_document, property: 'twitter:image');
    double h = double.tryParse(_document?.body?.querySelector('twitter:image')?.attributes.get('height') ?? "0.0") ?? 0.0;
    double w = double.tryParse(_document?.body?.querySelector('twitter:image')?.attributes.get('width') ?? "0.0") ?? 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  /// Twitter Cards do not have a siteName property, so we get it from
  /// [og:site_name] if available.
  @override
  String? get siteName => OpenGraphParser(_document).siteName;

  /// Twitter Cards do not have a url property, so we get the url from
  /// [og:url] if available.
  @override
  String? get url => OpenGraphParser(_document).url;

  @override
  String toString() => parse().toString();
}