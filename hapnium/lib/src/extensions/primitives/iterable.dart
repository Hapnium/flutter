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

  /// Groups the elements of the iterable by a key returned from the [keySelector] function.
  ///
  /// Returns a [Map] where each key is a value returned by [keySelector],
  /// and the corresponding value is a list of all elements in the iterable
  /// that produced that key.
  ///
  /// Example:
  /// ```dart
  /// final items = ['apple', 'banana', 'avocado'];
  /// final grouped = items.group((item) => item[0]);
  /// // grouped = {
  /// //   'a': ['apple', 'avocado'],
  /// //   'b': ['banana']
  /// // }
  /// ```
  Map<K, List<T>> group<K>(K Function(T item) keySelector) {
    final Map<K, List<T>> result = {};
    for (final element in this) {
      final key = keySelector(element);
      result.putIfAbsent(key, () => []).add(element);
    }
    return result;
  }

  /// Groups elements of this iterable into a [Map] using the given [keySelector].
  ///
  /// Similar to Java's `Collectors.groupingBy`.
  ///
  /// Each entry in the resulting map has a key produced by [keySelector],
  /// and the corresponding value is a list of elements that share that key.
  ///
  /// Example:
  /// ```dart
  /// class Interest {
  ///   final String name;
  ///   final String category;
  ///   Interest(this.name, this.category);
  /// }
  ///
  /// final interests = [
  ///   Interest('Football', 'Sports'),
  ///   Interest('Chess', 'Board Games'),
  ///   Interest('Basketball', 'Sports'),
  /// ];
  ///
  /// final grouped = interests.groupBy((i) => i.category);
  /// print(grouped['Sports']!.map((i) => i.name)); // [Football, Basketball]
  /// ```
  Map<K, List<T>> groupBy<K>(K Function(T item) keySelector) {
    return group(keySelector);
  }

  /// Groups elements of this iterable into a [Map] using [keySelector],
  /// and applies [valueSelector] to each element before storing it.
  ///
  /// Similar to Java's `Collectors.groupingBy(..., Collectors.mapping(...))`.
  ///
  /// Example:
  /// ```dart
  /// class Interest {
  ///   final String name;
  ///   final String category;
  ///   Interest(this.name, this.category);
  /// }
  ///
  /// final interests = [
  ///   Interest('Football', 'Sports'),
  ///   Interest('Chess', 'Board Games'),
  ///   Interest('Basketball', 'Sports'),
  /// ];
  ///
  /// final groupedNames = interests.groupByAndMap(
  ///   (i) => i.category,
  ///   (i) => i.name,
  /// );
  ///
  /// print(groupedNames['Sports']); // [Football, Basketball]
  /// ```
  Map<K, List<V>> groupByAndMap<K, V>(K Function(T item) keySelector, V Function(T item) valueSelector) {
    final Map<K, List<V>> result = {};
    for (final element in this) {
      final key = keySelector(element);
      result.putIfAbsent(key, () => []).add(valueSelector(element));
    }

    return result;
  }
}