import 'package:hapnium/hapnium.dart';

extension IterableExtension<T> on Iterable<T> {
  /// Flattens single items or lists of items into a single iterable.
  ///
  /// This function allows you to extract either a single element or an iterable of elements
  /// from each item in the original iterable, then flattens the result.
  ///
  /// Example:
  /// ```dart
  /// List<User> addons = [...];
  /// List<Card> cards = addons.flatMap((e) => e.card).toList();
  /// ```
  Iterable<E> flatMap<E>(Object? Function(T item) selector) sync* {
    for (T item in this) {
      final result = selector(item);
      if (result is E) {
        yield result;
      } else if (result is Iterable<E>) {
        yield* result;
      }
    }
  }

  /// Transforms each element of the iterable into zero or more results of type `E`,
  /// and flattens the resulting collections into a single iterable.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final doubledNumbers = numbers.flatMapIterable((n) => [n, n * 2]);
  /// // doubledNumbers will be [1, 2, 2, 4, 3, 6]
  /// ```
  Iterable<E> flattenIterable<E>(Iterable<E>? Function(T item) selector) sync* {
    for (T item in this) {
      Iterable<E>? res = selector(item);
      if (res != null) yield* res;
    }
  }

  /// Transforms each element of the iterable into zero or more elements of type `E`
  /// and flattens the results.
  ///
  /// Example:
  /// ```dart
  /// List<User> addons = [...];
  /// List<Card> cards = addons.flatten<Card>((e) => e.card).toList();
  /// ```
  Iterable<E> flatten<E>(E? Function(T item) selector) sync* {
    for (T item in this) {
      final E? result = selector(item);
      if (result != null) {
        yield result;
      }
    }
  }

  /// Checks whether all elements of this iterable satisfy [test].
  ///
  /// Iterates through each element, returning `false` as soon as an element
  /// does not satisfy [test]. Returns `true` if all elements satisfy [test].
  /// Returns `true` if the iterable is empty (since no elements violate the condition).
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.all((element) => element >= 5); // false;
  /// result = numbers.all((element) => element >= 0); // true;
  /// ```  
  bool all(ConditionTester<T> test) {
    for (T element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  /// Finds the index of the first element that satisfies the given predicate.
  ///
  /// Returns the index of the first element in the iterable
  /// that matches the provided `test` function.
  /// Returns -1 if no such element is found.
  int findIndex(ConditionTester<T> test) {
    for (var i = 0; i < this.length; i++) {
      if (test(this.elementAt(i))) {
        return i;
      }
    }
    return -1;
  }

  /// Finds the first element that satisfies the given predicate.
  ///
  /// Returns the first element in the iterable that matches the provided
  /// `test` function. Returns `null` if no such element is found.
  T? find(ConditionTester<T> test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Checks if length of double value is GREATER than max.
  bool isLengthGreaterThan(int max) => length > max;

  /// Short form for `isLengthGreaterThan`
  bool isLengthGt(int max) => isLengthGreaterThan(max);

  /// Checks if length of double value is GREATER OR EQUAL to max.
  bool isLengthGreaterThanOrEqualTo(int max) => length >= max;

  /// Short form for `isLengthGreaterThanOrEqualTo`
  bool isLengthGtEt(int max) => isLengthGreaterThanOrEqualTo(max);

  /// Checks if length of double value is LESS than max.
  bool isLengthLessThan(int max) => length < max;

  /// Short form for `isLengthLessThan`
  bool isLengthLt(int max) => isLengthLessThan(max);

  /// Checks if length of double value is LESS OR EQUAL to max.
  bool isLengthLessThanOrEqualTo(int max) => length <= max;

  /// Short form for `isLengthLessThanOrEqualTo`
  bool isLengthLtEt(int max) => isLengthLessThanOrEqualTo(max);

  /// Checks if length of double value is EQUAL to max.
  bool isLengthEqualTo(int other) => length == other;

  /// Short form for `isLengthEqualTo`
  bool isLengthEt(int max) => isLengthEqualTo(max);

  /// Checks if length of double value is BETWEEN minLength to max.
  bool isLengthBetween(int min, int max) => isLengthGreaterThanOrEqualTo(min) && isLengthLessThanOrEqualTo(max);

  /// Checks if no element matches the predicate.
  bool none(ConditionTester<T> test) => !any(test);

  /// Checks if none of the elements match a condition using noneMatch.
  bool noneMatch(ConditionTester<T> test) => none(test);

  /// Converts the iterable to a stream.
  Stream<T> stream() => Stream.fromIterable(this);

  /// Finds the index of an element that satisfies the predicate or returns `null` if not found.
  int? indexWhereOrNull(ConditionTester<T> test) {
    for (var i = 0; i < length; i++) {
      if (test(elementAt(i))) return i;
    }
    return null;
  }

  /// Filters elements of a specific type `T`.
  Iterable<T> whereType<T>() => this.where((element) => element is T).cast<T>();

  /// Returns an iterable with elements that match a condition, or `null` if none match.
  Iterable<T>? whereOrNull(ConditionTester<T> test) {
    final filtered = where(test);
    return filtered.isEmpty ? null : filtered;
  }

  /// Filters elements based on a predicate.
  Iterable<T> filterWhere(ConditionTester<T> test) => where(test);

  /// Filters elements based on a predicate (alias for `where`).
  Iterable<T> filter(ConditionTester<T> test) => where(test);
}