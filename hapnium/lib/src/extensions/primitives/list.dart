import 'package:hapnium/hapnium.dart';

extension ListExtensions<T> on List<T> {
  /// Checks if all list data have same value.
  bool get isOneAKind {
    if(isEmpty) {
      return false;
    } else {
      var first = this[0];
      int len = length;

      for (int i = 0; i < len; i++) {
        if (this[i] != first) {
          return false;
        }
      }

      return true;
    }
  }

  /// Adds an item to a list if a condition is met.
  void addIf(ConditionTester<T> condition, T element) {
    for (var item in List<T>.from(this)) {
      if (condition(item)) {
        add(element);
      }
    }

    return;
  }

  /// Adds all items from another list to a list if a condition is met.
  void addAllIf(ConditionTester<T> condition, Iterable<T> items) {
    if(all(condition)) {
      addAll(items);
    }
  }

  /// Removes an item from a list if a condition is met.
  void removeIf(ConditionTester<T> condition, T element) {
    for (var item in List<T>.from(this)) {
      if (condition(item)) {
        remove(element);
      }
    }
  }

  /// Removes all items from another list if a condition is met.
  void removeAllIf(ConditionTester<T> condition, Iterable<T> items) {
    if(all(condition)) {
      removeWhere((element) => items.any((e) => e.equals(element)));
    }
  }

  /// Returns the first element that satisfies the predicate or `null` if none match.
  T? firstWhereOrNull(ConditionTester<T> test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element that satisfies the predicate or `null` if none match.
  T? lastWhereOrNull(ConditionTester<T> test) {
    for (var element in reversed) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Removes and returns the first element of the list.
  /// 
  /// Returns `null` if the list is empty.
  T? shift() {
    if (isEmpty) return null;
    return removeAt(0);
  }

  /// Removes and returns the last element of the list.
  /// 
  /// Returns `null` if the list is empty.
  T? pop() {
    if (isEmpty) return null;
    return removeAt(length - 1);
  }

  /// Returns a new list with the elements in reverse order.
  List<T> reverse() {
    return List<T>.from(this).reversed.toList();
  }
}