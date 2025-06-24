import 'package:link_preview/link_preview.dart';

/// {@template cache}
/// A concrete implementation of [CacheManager] that acts as a global singleton.
///
/// This class is marked as `final`, preventing further subclassing.
///
/// Use [Cache.instance] to access the singleton.
/// 
/// {@endtemplate}
final class Cache extends CacheManager {
  /// The singleton instance of [Cache].
  /// 
  /// {@macro cache}
  static final Cache instance = Cache._();

  /// The in-memory cache storage
  final Map<String, LinkPreviewData> _cache = {};

  /// Private constructor to enforce singleton pattern.
  /// 
  /// {@macro cache}
  Cache._();

  @override
  Future<void> store(String key, LinkPreviewData value) {
    _cache[key] = value;
    return Future.value();
  }

  @override
  Future<LinkPreviewData?> retrieve(String key) {
    return Future.value(_cache[key]);
  }

  @override
  Future<void> remove(String key) {
    _cache.remove(key);
    return Future.value();
  }

  @override
  Future<void> clear() {
    _cache.clear();
    return Future.value();
  }
}