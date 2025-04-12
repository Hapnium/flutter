/// A utility class for type checking, similar to Java's `instanceof`.
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

  static bool nullable<T>(T? id) {
    return id == null;
  }
}