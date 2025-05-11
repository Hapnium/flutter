import 'link_preview_image.dart';

/// A class that represents all url preview data.
class LinkPreviewData extends InfoBase with BaseMetaInfo, MetadataKeys {
  /// Creates preview data from a map (e.g., decoded JSON).
  static LinkPreviewData fromJson(Map<String, dynamic> json) {
    return LinkPreviewData()
      ..title = json[MetadataKeys.kTitle]
      ..description = json[MetadataKeys.kDescription]
      ..image = json[MetadataKeys.kImage] != null ? LinkPreviewImage.fromJson(json[MetadataKeys.kImage]) : null
      ..siteName = json[MetadataKeys.kSiteName]
      ..url = json[MetadataKeys.kUrl]
      ..timeout = DateTime.fromMillisecondsSinceEpoch(json[MetadataKeys.kTimeout]! * 1000);
  }

  /// Converts preview data to the map representation, encoded to JSON.
  Map<String, dynamic> toJson() {
    return {
      MetadataKeys.kTitle: title,
      MetadataKeys.kDescription: description,
      MetadataKeys.kImage: image,
      MetadataKeys.kSiteName: siteName,
      MetadataKeys.kUrl: url,
      MetadataKeys.kTimeout: timeout.millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// Creates a copy of the preview data with overridden fields.
  LinkPreviewData copyWith({
    String? title,
    String? description,
    LinkPreviewImage? image,
    String? url,
    String? siteName,
    DateTime? timeout,
  }) {
    return LinkPreviewData()
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..image = image ?? this.image
      ..url = url ?? this.url
      ..siteName = siteName ?? this.siteName
      ..timeout = timeout ?? this.timeout;
  }

  @override
  String toString() => toJson().toString();

  /// Utility: Returns true if all metadata is available.
  bool get hasAllMetadata => title != null && description != null && image != null && url != null;

  /// Utility: Returns true if the title is non-null and non-empty.
  bool get hasTitle => title?.isNotEmpty == true;

  /// Utility: Returns true if the description is non-null and non-empty.
  bool get hasDescription => description?.isNotEmpty == true;

  /// Utility: Returns true if the image is non-null and non-empty.
  bool get hasImage => image != null && image?.url.isNotEmpty == true;

  /// Utility: Returns true if the url is non-null and non-empty.
  bool get hasLink => url?.isNotEmpty == true;

  /// Utility: Returns true if there is at least one useful piece of data.
  bool get hasAnyData => hasTitle || hasDescription || hasImage;
}

/// The base class for implementing a parser.
mixin MetadataKeys {
  static const kTitle = 'title';
  static const kDescription = 'description';
  static const kImage = 'image';
  static const kUrl = 'url';
  static const kSiteName = 'siteName';
  static const kTimeout = 'timeout';
}

mixin BaseMetaInfo {
  /// The title of the link.
  String? title;

  /// The description of the link.
  String? description;

  /// The image associated with the link.
  LinkPreviewImage? image;

  /// The URL of the link.
  String? url;

  /// The name of the site.
  String? siteName;

  /// Returns true if any parameter other than [url] is filled.
  bool get hasData =>
      ((title?.isNotEmpty ?? false) && title != 'null') ||
          ((description?.isNotEmpty ?? false) && description != 'null') ||
          ((image?.url.isNotEmpty ?? false) && image?.url != 'null');

  LinkPreviewData parse() {
    return LinkPreviewData()
      ..title = title
      ..description = description
      ..image = image
      ..url = url
      ..siteName = siteName;
  }
}

abstract class InfoBase {
  late DateTime timeout;
}