import 'link_preview_interface.dart';

/// {@template link_preview_impl}
/// Singleton implementation of [LinkPreviewInterface] used internally by the [LinkPreview] global instance.
///
/// This class serves as the default implementation and inherits all behavior
/// from the abstract interface. While you can extend or override this implementation,
/// most applications will simply rely on the global [LinkPreview] instance for
/// convenience and consistency.
///
/// ## Example usage:
/// ```dart
/// final data = await LinkPreview.get('https://example.com');
/// if (data != null && data.hasAllMetadata) {
///   print('Fetched title: ${data.title}');
/// }
/// ```
/// {@endtemplate}
class _LinkPreviewImpl extends LinkPreviewInterface {}

/// The global [LinkPreviewInterface] instance for building and fetching previews.
///
/// This singleton provides a convenient default interface to fetch metadata for a given URL.
/// Internally, it uses the [_LinkPreviewImpl] class, which inherits behavior from [LinkPreviewInterface].
///
/// You can call [LinkPreview.get] directly without instantiating anything manually.
///
/// Useful for link cards, previews, unfurling messages, and more.
///
/// Example:
/// ```dart
/// final preview = await LinkPreview.get('https://example.com');
/// if (preview != null) {
///   print(preview.title);
/// }
/// ```
final LinkPreview = _LinkPreviewImpl();