import 'package:meta/meta.dart';

/// {@template link_preview_image}
/// A model representing the preview image metadata extracted from a link.
///
/// Includes dimensions and the direct URL to the image, typically used
/// to display thumbnails or preview cards.
///
/// Example:
/// ```dart
/// final image = LinkPreviewImage(
///   height: 120,
///   width: 200,
///   url: 'https://example.com/image.jpg',
/// );
/// ```
/// {@endtemplate}
@immutable
class LinkPreviewImage {
  /// Image height in pixels. Default: null
  final double height;

  /// Remote image URL. Default: null
  final String url;

  /// Image width in pixels. Default: null
  final double width;

  /// {@macro link_preview_image}
  const LinkPreviewImage({
    required this.height,
    required this.url,
    required this.width,
  });

  /// Creates preview data image from a map (decoded JSON).
  factory LinkPreviewImage.fromJson(Map<String, dynamic> json) {
    return LinkPreviewImage(
      height: json['height'] as double,
      url: json['url'] as String,
      width: json['width'] as double,
    );
  }

  /// Converts preview data image to the map representation, encoded to JSON.
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'url': url,
      'width': width,
    };
  }
}