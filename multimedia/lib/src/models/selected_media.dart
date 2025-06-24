import './file_reader/file_reader.dart' show readFileBytes;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:smart/smart.dart' show MediaType, StringExtensions, JsonUtils, Instance, EnumExtension;

/// {@template selected_media}
/// Represents a selected piece of media (photo, video, etc.) in the system.
///
/// This model is designed to encapsulate metadata and raw content for any
/// type of selected media, whether it comes from the camera, gallery,
/// or a remote source. It supports serialization to and from JSON, and
/// provides utility methods for base64 encoding.
///
/// This class is platform-aware and will behave differently on the web
/// versus mobile or desktop platforms.
///
/// ### Example
/// ```dart
/// final media = SelectedMedia(
///   path: '/storage/emulated/0/DCIM/Camera/photo.jpg',
///   size: '2.1 MB',
///   duration: '00:10',
///   isCamera: true,
///   media: MediaType.photo,
/// );
///
/// if (media.hasContent) {
///   final base64 = await media.getBase64WithPrefix();
///   print(base64);
/// }
/// ```
/// {@endtemplate}
class SelectedMedia {
  /// Full path to the media file on the device or web.
  ///
  /// Defaults to an empty string.
  final String path;

  /// Size of the media file as a formatted string (e.g., "2.3 MB").
  ///
  /// Useful for UI display.
  ///
  /// Defaults to an empty string.
  final String size;

  /// Duration of the media (e.g., for video or audio).
  ///
  /// Format: "HH:MM:SS" or "MM:SS".
  ///
  /// Defaults to "00:00".
  final String duration;

  /// Raw byte data of the media, if already available in memory.
  ///
  /// Only used on web or in-memory operations.
  ///
  /// Defaults to `null`.
  final Uint8List? data;

  /// Optional callback URL pointing to the media on a remote server.
  ///
  /// Useful when media is uploaded or streamed.
  ///
  /// Defaults to `null`.
  final String? callbackUrl;

  /// Type of media selected, such as photo or video.
  ///
  /// Defaults to `MediaType.photo`.
  final MediaType media;

  /// Indicates whether the media was captured using the device camera.
  ///
  /// Useful for distinguishing camera vs. gallery sources.
  ///
  /// Defaults to `false`.
  final bool isCamera;

  /// {@macro selected_media}
  const SelectedMedia({
    required this.path,
    this.duration = "00:00",
    this.size = "",
    this.data,
    this.callbackUrl,
    this.isCamera = false,
    this.media = MediaType.photo,
  });

  /// Creates a copy of this [SelectedMedia] with optional overrides.
  ///
  /// Useful for immutability and rebuilding modified instances.
  SelectedMedia copyWith({
    String? path,
    String? duration,
    String? size,
    Uint8List? data,
    String? callbackUrl,
    MediaType? media,
    bool? isCamera,
  }) {
    return SelectedMedia(
      path: path ?? this.path,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      data: data ?? this.data,
      media: media ?? this.media,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      isCamera: isCamera ?? this.isCamera,
    );
  }

  /// Converts the media object to a JSON-compatible `Map`.
  Map<String, dynamic> toJson() => {
    "path": path,
    "duration": duration,
    "size": size,
    "data": data,
    "callback_url": callbackUrl,
    "media": media.type,
    "is_camera": isCamera,
  };

  /// Converts the media object to a JSON string.
  String toJsonString(SelectedMedia media) {
    return JsonUtils.instance.encode(media.toJson());
  }

  /// Creates a [SelectedMedia] instance from a JSON `Map` or JSON string.
  ///
  /// Automatically parses enum values and checks for null safety.
  factory SelectedMedia.fromJson(dynamic data) {
    if (Instance.of<String>(data)) {
      data = JsonUtils.instance.decode(data);
    }

    return SelectedMedia(
      path: data["path"] ?? "",
      duration: data["duration"] ?? "",
      size: data["size"] ?? "",
      data: data["data"],
      callbackUrl: data["callback_url"],
      isCamera: data["is_camera"] ?? false,
      media: data["media"] != null ? (data["media"] as String).toMediaType : MediaType.photo,
    );
  }

  /// Returns an empty [SelectedMedia] with a blank path.
  factory SelectedMedia.empty() => SelectedMedia(path: "");

  /// Returns `true` if there is either a file path or byte data present.
  bool get hasContent => path.isNotEmpty || data != null;

  /// Encodes the media into a base64 string (without MIME prefix).
  ///
  /// This method reads from memory if on the web, or reads the file from
  /// disk on other platforms.
  Future<String> getBase64() async {
    Uint8List fileBytes;

    if (kIsWeb) {
      if (data == null) {
        throw Exception("No data available in memory for web platform.");
      }
      fileBytes = data!;
    } else {
      fileBytes = await readFileBytes(path);
    }

    return JsonUtils.instance.encode(fileBytes);
  }

  /// Returns a base64 string of the media, prefixed with the MIME type.
  ///
  /// Example: `"data:image/jpeg;base64,/9j/4AAQSk..."`.
  Future<String> getBase64WithPrefix() async {
    final base64String = await getBase64();
    final mime = path.mimeType;
    return 'data:$mime;base64,$base64String';
  }
}