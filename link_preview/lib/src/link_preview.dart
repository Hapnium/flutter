import 'link_preview_interface.dart';

/// Singleton instance of the default [LinkPreviewInterface] implementation.
class _LinkPreviewImpl extends LinkPreviewInterface {}

/// The global [LinkPreviewInterface] instance for building and fetching previews.
final LinkPreview = _LinkPreviewImpl();