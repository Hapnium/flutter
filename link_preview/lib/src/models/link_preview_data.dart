import 'link_preview_image.dart';

/// {@template link_preview_data}
/// A data model representing metadata extracted from a web link for preview purposes.
///
/// It includes fields like title, description, image, site name, and URL.
/// This model is typically constructed after parsing metadata from a webpage and is
/// suitable for caching, display, and serialization.
///
/// Example:
/// ```dart
/// final preview = LinkPreviewData()
///   ..title = "OpenAI"
///   ..description = "AI research and deployment company"
///   ..url = "https://openai.com"
///   ..timeout = DateTime.now().add(Duration(hours: 1));
/// ```
/// {@endtemplate}
class LinkPreviewData extends InfoBase with BaseMetaInfo, MetadataKeys {
  /// Creates preview data from a map (e.g., decoded JSON).
  /// 
  /// {@macro link_preview_data}
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
  /// 
  /// {@macro link_preview_data}
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
  /// 
  /// {@macro link_preview_data}
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

/// {@template metadata_keys}
/// A mixin providing a collection of constant keys used for identifying metadata
/// fields within maps, such as when serializing or deserializing [LinkPreviewData].
///
/// These keys are typically used to extract or encode title, description, image, URL,
/// site name, and expiration time (`timeout`) from a JSON object.
///
/// Example usage:
/// ```dart
/// final json = {
///   MetadataKeys.kTitle: 'OpenAI',
///   MetadataKeys.kDescription: 'AI Research Lab',
///   MetadataKeys.kImage: {...},
/// };
/// ```
/// {@endtemplate}
mixin MetadataKeys {
  /// JSON key representing the title of the link.
  static const kTitle = 'title';

  /// JSON key representing the description of the link.
  static const kDescription = 'description';

  /// JSON key representing the preview image data.
  static const kImage = 'image';

  /// JSON key representing the URL.
  static const kUrl = 'url';

  /// JSON key representing the site or publisher's name.
  static const kSiteName = 'siteName';

  /// JSON key representing the expiration timeout (in Unix timestamp).
  static const kTimeout = 'timeout';
}

/// {@template base_meta_info}
/// A reusable metadata mixin that contains optional fields representing the
/// common metadata properties extracted from a web page or link.
///
/// Can be used in classes that need to hold temporary or pre-processed metadata
/// before being converted into a [LinkPreviewData] object.
///
/// This mixin also includes a `hasData` utility to quickly check if the object
/// contains any valid metadata other than the URL.
///
/// Fields default to `null` unless explicitly set.
/// {@endtemplate}
mixin BaseMetaInfo {
  /// The title of the linked page. Default: null
  String? title;

  /// The description or summary of the linked content. Default: null
  String? description;

  /// The associated preview image for the link. Default: null
  LinkPreviewImage? image;

  /// The URL of the link source. Default: null
  String? url;

  /// The site or domain name hosting the content. Default: null
  String? siteName;

  /// Returns true if at least one of the metadata fields—[title], [description],
  /// or [image]—is non-null and non-empty, excluding the [url].
  ///
  /// Useful for checking if the object contains meaningful data.
  bool get hasData =>
      ((title?.isNotEmpty ?? false) && title != 'null') ||
      ((description?.isNotEmpty ?? false) && description != 'null') ||
      ((image?.url.isNotEmpty ?? false) && image?.url != 'null');

  /// Converts this metadata mixin into a [LinkPreviewData] instance by copying
  /// the current values of all fields (excluding timeout).
  ///
  /// This is helpful when you're constructing a full metadata object from
  /// partially parsed values.
  LinkPreviewData parse() {
    return LinkPreviewData()
      ..title = title
      ..description = description
      ..image = image
      ..url = url
      ..siteName = siteName;
  }
}

/// {@template info_base}
/// An abstract base class that defines a required [timeout] field, representing
/// the expiration or invalidation timestamp for metadata.
///
/// Typically used as a superclass for link preview models to ensure they carry
/// a cache expiry mechanism.
///
/// Example:
/// ```dart
/// final info = LinkPreviewData()..timeout = DateTime.now().add(Duration(hours: 1));
/// ```
/// {@endtemplate}
abstract class InfoBase {
  /// The expiration time for the metadata. Must be set explicitly.
  ///
  /// This is used by cache mechanisms to determine whether the preview data
  /// is still valid or should be refreshed.
  late DateTime timeout;
}