import 'package:flutter/foundation.dart' show mustCallSuper, nonVirtual;
import 'package:tracing/tracing.dart';

import '../models/link_preview_data.dart';

/// A customizable cache manager for [LinkPreviewData].
///
/// Subclasses can override how the data is stored (e.g., local memory, database, network),
/// but the core logic around validation and cleanup is handled here.
abstract class CacheManager {
  /// Stores a [LinkPreviewData] object with the given [key].
  ///
  /// Override this to change the persistence layer.
  Future<void> store(String key, LinkPreviewData value);

  /// Retrieves a [LinkPreviewData] object for the given [key], or `null` if not found.
  ///
  /// Override this to provide custom retrieval logic.
  Future<LinkPreviewData?> retrieve(String key);

  /// Deletes a cached entry by its [key].
  ///
  /// Override this to provide custom deletion logic.
  Future<void> remove(String key);

  /// Clears all cached data.
  ///
  /// Override this to clear custom storage layers.
  Future<void> clear() async {}

  /// Performs validation and retrieves the [LinkPreviewData] for the given [url].
  ///
  /// If the data is expired or invalid, it is removed from the cache.
  @nonVirtual
  Future<LinkPreviewData?> get(String url) async {
    LinkPreviewData? info;

    try {
      info = await retrieve(url);

      final isInvalid = info == null || info.title == null || info.title == 'null';
      final isExpired = info != null && !info.timeout.isAfter(DateTime.now());

      if (isInvalid || isExpired) {
        await remove(url);
        return null;
      }
    } catch (e) {
      console.log('Error retrieving from cache: $e');
    }

    return info;
  }

  /// Stores the [LinkPreviewData] for a given [url].
  ///
  /// Wraps [store] to support public-facing caching.
  @mustCallSuper
  Future<void> set(String url, LinkPreviewData data) => store(url, data);

  /// Deletes the cached [LinkPreviewData] for a given [url].
  @mustCallSuper
  Future<void> delete(String url) async {
    try {
      await remove(url);
    } catch (e) {
      console.log('Error deleting from cache: $e');
    }
  }
}