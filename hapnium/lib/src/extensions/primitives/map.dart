import '../../utils/type_utils.dart';
import '../others/t.dart';

extension MapExtensions<K, V> on Map<K, V> {
  /// Converts a Map to JSON with formatted keys (`_`, `-`, or `camelCase`).
  Map<String, dynamic> asJson({String delimiter = '_'}) {
    return mapKeys((key) {
      if (key is String) {
        return formatKeys(key, delimiter);
      }
      return TypeUtils.valueOf(key);
    });
  }

  /// Formats map keys (snake_case, kebab-case, camelCase)
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
  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }

  /// Applies a transformation function to the keys of the Map.
  Map<K2, V> mapKeys<K2>(K2 Function(K key) convert) {
    return map<K2, V>((key, value) => MapEntry(convert(key), value));
  }

  /// Add item
  void add(K key, V item) {
    update(key, (v) => v.notEquals(item) ? item : v, ifAbsent: () => item);
  }
}