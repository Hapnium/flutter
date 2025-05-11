import 'package:meta/meta.dart';

@immutable
class LinkPreviewImage {
  /// Image height in pixels.
  final double height;

  /// Remote image URL.
  final String url;

  /// Image width in pixels.
  final double width;

  /// Creates preview data image.
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