import '../../utils/instance.dart';
import '../others/t.dart';

extension MapExtensions<K, V> on Map<K, V> {
  /// Converts a Map to JSON with formatted keys (`_`, `-`, or `camelCase`).
  /// 
  /// ## Parameters
  /// - `delimiter`: The delimiter to use for formatting keys
  /// 
  /// ## Returns
  /// - A new Map with formatted keys
  Map<String, dynamic> asJson({String delimiter = '_'}) {
    return mapKeys((key) {
      if (key is String) {
        return formatKeys(key, delimiter);
      }
      return Instance.valueOf(key);
    });
  }

  /// Formats map keys (snake_case, kebab-case, camelCase)
  /// 
  /// ## Parameters
  /// - `key`: The key to format
  /// - `delimiter`: The delimiter to use for formatting keys
  /// 
  /// ## Returns
  /// - The formatted key
  static String formatKeys(String key, String delimiter) {
    switch (delimiter) {
      case '_':
        return key.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]}_${m[2]!.toLowerCase()}');
      case '-':
        return key.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]}-${m[2]!.toLowerCase()}');
      default:
        return key; // Return as is
    }
  }

  /// Merges another Map into the current Map, overriding duplicate keys.
  /// 
  /// ## Parameters
  /// - `other`: The Map to merge
  /// 
  /// ## Returns
  /// - A new Map with merged key-value pairs
  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }

  /// Applies a transformation function to the keys of the Map.
  /// 
  /// ## Parameters
  /// - `convert`: The transformation function to apply to the keys
  /// 
  /// ## Returns
  /// - A new Map with transformed keys
  Map<K2, V> mapKeys<K2>(K2 Function(K key) convert) {
    return map<K2, V>((key, value) => MapEntry(convert(key), value));
  }

  /// Add item
  /// 
  /// If the key already exists, it will be updated only if the value is different.
  /// 
  /// ## Parameters
  /// - `key`: The key to add
  /// - `item`: The value to add
  void add(K key, V item) {
    update(key, (v) => v.notEquals(item) ? item : v, ifAbsent: () => item);
  }
}