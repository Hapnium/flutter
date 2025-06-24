import 'package:flutter/foundation.dart' show mustCallSuper, nonVirtual;
import 'package:tracing/tracing.dart';

import '../models/link_preview_data.dart';

/// {@template cache_manager}
/// An abstract base class that defines a customizable cache mechanism for [LinkPreviewData].
///
/// Designed for extensibility, you can implement your own cache manager that persists
/// data using memory, database, disk, or even cloud storage. This class ensures that
/// validation and expiration checks are handled before returning any cached data.
///
/// Example:
/// ```dart
/// class InMemoryCacheManager extends CacheManager {
///   final _cache = <String, LinkPreviewData>{};
///
///   @override
///   Future<void> store(String key, LinkPreviewData value) async {
///     _cache[key] = value;
///   }
///
///   @override
///   Future<LinkPreviewData?> retrieve(String key) async {
///     return _cache[key];
///   }
///
///   @override
///   Future<void> remove(String key) async {
///     _cache.remove(key);
///   }
/// }
/// ```
/// {@endtemplate}
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