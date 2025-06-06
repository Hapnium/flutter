import 'package:link_preview/link_preview.dart';

import '../cache/cache.dart';
import '../link_preview_interface.dart';

/// Extension on [LinkPreviewInterface] to provide convenient access
/// to a [CacheManager] instance.
extension CacheExtension on LinkPreviewInterface {
  /// Returns the provided [cacheManager] if it's not null;
  /// otherwise returns the global singleton [Cache.instance].
  ///
  /// This enables flexibility in testing or customization.
  CacheManager cacheManager([CacheManager? cacheManager]) {
    return cacheManager ?? Cache.instance;
  }
}