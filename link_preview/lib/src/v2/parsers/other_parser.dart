import 'package:html/dom.dart';

import '../../models/link_preview_data.dart';
import '../../models/link_preview_image.dart';
import '../../extensions/get_extension.dart';

/// Parses [LinkPreviewData] from `<meta attribute: 'name' property='*'>` tags.
class OtherParser with BaseMetaInfo {
  /// The [Document] to be parse
  final Document? _document;

  OtherParser(this._document);

  /// Get [LinkPreviewData.title] from 'title'.
  @override
  String? get title => getProperty(_document, attribute: 'name', property: 'title');

  /// Get [LinkPreviewData.desc] from 'description'.
  @override
  String? get description => getProperty(_document, attribute: 'name', property: 'description');

  /// Get [LinkPreviewData.image] from 'image'.
  @override
  LinkPreviewImage? get image {
    String? img = getProperty(_document, attribute: 'name', property: 'image');
    double h = double.tryParse(_document?.body?.querySelector('image')?.attributes.get('height') ?? "0.0") ?? 0.0;
    double w = double.tryParse(_document?.body?.querySelector('image')?.attributes.get('width') ?? "0.0") ?? 0.0;

    if(img != null && img != "null") {
      return LinkPreviewImage(url: img, height: h, width: w);
    }

    return null;
  }

  /// Get [LinkPreviewData.siteName] from 'description'.
  @override
  String? get siteName => getProperty(_document, attribute: 'name', property: 'site_name');

  /// Get [LinkPreviewData.url] from 'url'.
  @override
  String? get url => getProperty(_document, attribute: 'name', property: 'url');

  @override
  String toString() => parse().toString();
}