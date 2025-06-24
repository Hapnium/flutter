import '../extensions/others/t.dart';

/// {@template instance}
/// A utility class for type checking, similar to Java's `instanceof`.
/// It also provides additional methods for type checking.
/// 
/// {@endtemplate}
class Instance {
  /// Checks whether [value] is of type [T].
  ///
  /// Example:
  /// ```dart
  /// bool isString = Instance.of<String>("Hello"); // true
  /// bool isInt = Instance.of<int>(42); // true
  /// ```
  static bool of<T>(dynamic value) {
    return value is T || value == T;
  }

  /// Checks whether [value] is of type [type].
  ///
  /// Example:
  /// ```dart
  /// bool isString = Instance.isType("Hello", String); // true
  /// bool isInt = Instance.isType(42, int); // true
  /// ```
  static bool isType(dynamic value, Type type) {
    if(value.runtimeType == type) {
      return true;
    }

    if(value.runtimeType.toString() == type.toString()) {
      return true;
    }

    if(type.toString().startsWith("Map")) {
      return value is Map;
    }

    return value.runtimeType.toString().replaceAll("_", "") == type.toString().replaceAll("_", "");
  }

  /// Checks if [value] is a numeric type (`int` or `double`).
  ///
  /// Example:
  /// ```dart
  /// bool isNumeric = Instance.isNumeric(42); // true
  /// ```
  static bool isNumeric(dynamic value) {
    return value is num || value == num;
  }

  /// Checks if [value] is a list.
  ///
  /// Example:
  /// ```dart
  /// bool isList = Instance.isList([1, 2, 3]); // true
  /// ```
  static bool isList(dynamic value) {
    return value is List || value == List;
  }

  /// Checks if [value] is a map.
  ///
  /// Example:
  /// ```dart
  /// bool isMap = Instance.isMap({"key": "value"}); // true
  /// ```
  static bool isMap(dynamic value) {
    return value is Map || value == Map;
  }

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become
  /// non-nullable can still be used with `!` and `?`
  /// to support older versions of the API as well.
  static T? ambiguate<T>(T? value) => value;

  /// Checks if [value] is null.
  ///
  /// Example:
  /// ```dart
  /// bool isNull = Instance.nullable(null); // true
  /// bool isNotNull = Instance.nullable("Hello"); // false
  /// ```
  static bool nullable<T>(T? id) {
    return id == null;
  }

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