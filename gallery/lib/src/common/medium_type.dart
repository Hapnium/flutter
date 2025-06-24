/// {@template medium_type}
/// Represents the type of a medium stored in the gallery, such as an image or a video.
///
/// This enum is used to distinguish between different types of media that can be fetched,
/// listed, or displayed from the gallery.
///
/// Example usage:
/// ```dart
/// MediumType type = MediumType.image;
/// if (type == MediumType.video) {
///   print('This is a video.');
/// }
/// ```
/// {@endtemplate}
enum MediumType {
  /// Represents an image medium.
  ///
  /// Corresponds to `MediumType.image`.
  image,

  /// Represents a video medium.
  ///
  /// Corresponds to `MediumType.video`.
  video,
}

/// {@template medium_type_to_json}
/// Converts a [MediumType] value to its corresponding JSON string representation.
///
/// Returns:
/// - `'image'` if the value is [MediumType.image]
/// - `'video'` if the value is [MediumType.video]
/// - `null` if the value is `null` or unrecognized
///
/// Example:
/// ```dart
/// final jsonValue = mediumTypeToJson(MediumType.image); // 'image'
/// ```
/// {@endtemplate}
String? mediumTypeToJson(MediumType? value) {
  switch (value) {
    case MediumType.image:
      return 'image';
    case MediumType.video:
      return 'video';
    default:
      return null;
  }
}

/// {@template json_to_medium_type}
/// Parses a [String] value from JSON into a corresponding [MediumType] enum.
///
/// Returns:
/// - [MediumType.image] if the input is `'image'`
/// - [MediumType.video] if the input is `'video'`
/// - `null` if the input is `null` or does not match any known type
///
/// Example:
/// ```dart
/// final type = jsonToMediumType('video'); // MediumType.video
/// ```
/// {@endtemplate}
MediumType? jsonToMediumType(String? value) {
  switch (value) {
    case 'image':
      return MediumType.image;
    case 'video':
      return MediumType.video;
    default:
      return null;
  }
}