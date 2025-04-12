/// Represents the different types of media that can be selected.
///
/// The [MediaType] enum defines the available media formats that can be captured or selected
/// within the application.
///
/// Example Usage:
/// ```dart
/// MediaType media = MediaType.video;
/// print(media.type); // Output: "Video"
/// ```
enum MediaType {
  /// Represents media captured from the device's camera as a **video**.
  video("Video"),

  /// Represents media captured from the device's camera as a **photo**.
  photo("Photo");

  /// Constructs a [MediaType] object with the given descriptive [type] string.
  const MediaType(this.type);

  /// The human-readable string representation of the media type.
  final String type;
}