import 'package:flutter/foundation.dart';

import '../models/link_preview_data.dart';

/// A basic in-memory cache for LinkPreviewData.
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();

  final Map<String, LinkPreviewData> _cache = {};

  CacheManager._internal();

  static CacheManager get instance => _instance;

  /// Stores a [LinkPreviewData] object with the given [key].
  void set(String key, LinkPreviewData value) {
    _cache[key] = value;
  }

  /// Retrieves a [LinkPreviewData] object for the given [key], or null if not cached.
  LinkPreviewData? get(String key) => _cache[key];

  /// Deletes a cached item by [key].
  void delete(String key) => _cache.remove(key);

  /// Clears the entire cache.
  void clear() => _cache.clear();

  /// Returns [LinkPreviewData] from cache if available.
  Future<LinkPreviewData?> getCache(String url) async {
    LinkPreviewData? info_;

    try {
      final infoJson = await CacheManager.instance.get(url);
      if (infoJson != null) {
        info_ = infoJson;
        var isEmpty_ = info_.title == null || info_.title == 'null';
        if (isEmpty_ || !info_.timeout.isAfter(DateTime.now())) {
          CacheManager.instance.delete(url);
        }
        if (isEmpty_) info_ = null;
      }
    } catch (e) {
      debugPrint('Error while retrieving cache data => $e');
    }

    return info_;
  }

  /// Deletes [LinkPreviewData] from cache if present.
  void deleteCache(String url) => CacheManager.instance.delete(url);
}