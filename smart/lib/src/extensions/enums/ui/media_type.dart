import '../../../enums/ui/media_type.dart';

/// Provides convenient boolean checks for [MediaType] values.
///
/// This extension allows you to perform quick comparisons with readable getter methods.
/// Instead of writing `if (media == MediaType.video)`, you can use `media.isVideo`.
///
/// Example Usage:
/// ```dart
/// MediaType media = MediaType.photo;
/// if (media.isPhoto) {
///   print("User selected a photo.");
/// }
/// ```
extension MediaTypeExtension on MediaType {
  /// Returns `true` if the media type is a **video**.
  bool get isVideo => this == MediaType.video;

  /// Returns `true` if the media type is a **photo**.
  bool get isPhoto => this == MediaType.photo;
}