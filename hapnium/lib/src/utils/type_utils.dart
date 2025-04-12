import './instance.dart';
import '../extensions/others/t.dart';

/// A utility class for common string operations
class TypeUtils {
  /// Converts [value] to a string.
  ///
  /// Example:
  /// ```dart
  /// String str = TypeUtils.valueOf(100); // "100"
  /// ```
  static String valueOf(dynamic value) => "$value";

  /// Converts a dynamic value into a boolean.
  ///
  /// - Strings: `"true"` (case-insensitive) → `true`, `"false"` → `false`
  /// - Integers: `1` → `true`, `0` → `false`
  /// - Booleans: Returns the value itself.
  /// - Other values: Defaults to `false`
  static bool toBoolean<T>(T? value) {
    if(value.isNotNull) {
      if(value.instanceOf<String>() || Instance.of<String>(value)) {
        String result = (value as String).trim();

        return bool.tryParse(result.toLowerCase()) ?? false;
      } else if(value.instanceOf<int>() || Instance.of<int>(value)) {
        int result = value as int;

        return result.equals(1);
      } else if(value.instanceOf<bool>() || Instance.of<bool>(value)) {
        bool result = value as bool;

        return result;
      }
    }

    return false;
  }
}