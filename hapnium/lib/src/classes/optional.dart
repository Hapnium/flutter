import '../exceptions/hapnium_exception.dart';
import '../utils/typedefs.dart';
import '../extensions/others/t.dart';

class Optional<T> {
  final T? _value;

  /// Creates an empty Optional.
  factory Optional.empty() {
    if (T.instanceOf<List>()) {
      return Optional._([] as T);
    } else if (T.instanceOf<Map>()) {
      return Optional._(<String, dynamic>{} as T);
    } else if (T.instanceOf<String>()) {
      return Optional._('' as T);
    } else if (T.instanceOf<bool>()) {
      return Optional._(false as T);
    } else if (T.instanceOf<double>()) {
      return Optional._(0.0 as T);
    } else if (T.instanceOf<int>()) {
      return Optional._(-1 as T);
    } else if (T.instanceOf<num>()) {
      return Optional._(0 as T);
    }

    return Optional._(null); // Default for other types
  }

  Optional._(this._value);

  /// Creates an Optional with a non-null value.
  factory Optional.of(T value) {
    if (value == null) {
      throw HapniumException('$T is not present');
    }

    return Optional._(value);
  }

  /// Creates an Optional with a nullable value.
  Optional.ofNullable(T? value) : _value = value;

  /// Retrieves the value if present, otherwise throws a [HapniumException].
  T get() {
    if (_value == null) throw HapniumException('$T is not present');
    return _value;
  }

  /// Checks if the Optional contains a value.
  bool isPresent() => _value != null;

  /// Executes a consumer function if a value is present and is of type `U`.
  /// Processes each item if _value is a list or map.
  void ifPresentIn<U>(Consumer<U> consumer) {
    if (isPresent()) {
      if (_value is List) {
        for (var item in _value as List) {
          if (item is U) {
            consumer(item);
          }
        }
      } else if (_value is Map) {
        (_value as Map).forEach((key, value) {
          if (value is U) {
            consumer(value);
          }
        });
      } else if (_value is U) {
        consumer(_value as U);
      } else {
        throw HapniumException("Value is not of type $U");
      }
    }
  }

  /// Executes a consumer function if a value is present.
  void ifPresent(Consumer<T> consumer) {
    if (isPresent()) {
      consumer(_value as T);
    }
  }

  /// Filters the Optional based on a predicate.
  /// If the value is a List, it filters the list using the predicate.
  /// If the value is a Map, it filters the map based on values.
  /// Otherwise, it applies the predicate to a single value.
  Optional<T> filter(Checker<T> predicate) {
    if (isPresent()) {
      if (_value is List<T>) {
        List<T> filteredList = (_value as List<T>).where(predicate).toList();

        if(filteredList.isNotEmpty) {
          return Optional.of(filteredList as T);
        } else {
          return Optional.empty();
        }
      } else if (_value is Map) {
        List<MapEntry<dynamic, dynamic>> filteredMap = (_value as Map)
            .map((dynamic key, dynamic value) => predicate(value as T) ? MapEntry(key, value) : MapEntry(null, null))
            .entries
            .where((entry) => entry.key != null)
            .map((e) => e).toList();

        if(filteredMap.isNotEmpty) {
          return Optional.of(filteredMap as T);
        }
      }

      // Handle single value
      return predicate(_value as T) ? this : Optional.empty();
    }

    return Optional.empty();
  }

  /// Maps the value to another Optional type `U`.
  /// If the value is a List, it maps each item using the mapper.
  /// If the value is a Map, it maps each value in the map using the mapper.
  Optional<U> map<U>(Mapper<T, U> mapper) {
    if (isPresent()) {
      if (_value is List<T>) {
        List<U> mappedList = (_value as List<T>).map(mapper).toList();

        if(mappedList.isNotEmpty) {
          return Optional.of(mappedList as U);
        } else {
          return Optional.empty();
        }
      } else if (_value is Map) {
        // Map<dynamic, U> mappedMap = (_value as Map).map((dynamic key, dynamic value) {
        //   return MapEntry(key, mapper(value as T));
        // });

        return Optional.of(mapper(_value as T));
      }

      return Optional.ofNullable(mapper(_value as T));
    }

    return Optional.empty();
  }

  /// Maps the value to another Optional type `U` using a mapper function that returns an Optional.
  /// If the value is a List, it maps each item to an Optional and flattens the result.
  /// If the value is a Map, it applies the mapper to each map value.
  Optional<U> flatMap<U>(Optional<U> Function(T value) mapper) {
    if (isPresent()) {
      if (_value is List<T>) {
        List<U> flattenedList = <U>[];
        for (T item in _value as List<T>) {
          Optional<U> mappedOptional = mapper(item);
          if (mappedOptional.isPresent()) {
            flattenedList.add(mappedOptional.get());
          }
        }

        if(flattenedList.isNotEmpty) {
          return Optional.of(flattenedList as U);
        } else {
          return Optional.empty();
        }
      } else if (_value is Map) {
        List<MapEntry<dynamic, dynamic>> flattenedMap = (_value as Map)
            .map((dynamic key, dynamic value) {
              Optional<U> mappedOptional = mapper(value as T);
              return mappedOptional.isPresent() ? MapEntry(key, mappedOptional.get()) : MapEntry(null, null);
            })
            .entries.where((entry) => entry.key != null)
            .map((e) => e).toList();

        if(flattenedMap.isNotEmpty) {
          return Optional.of(flattenedMap as U);
        }
      }

      return mapper(_value as T);
    }

    return Optional.empty();
  }

  /// Returns the value if present, otherwise returns [other].
  T orElse(T other) => _value ?? other;

  /// Returns the value if present, otherwise calls [other] to get a default value.
  T orElseGet(Supplier<T> other) => _value ?? other();

  /// Returns the value if present, otherwise throws an exception provided by [exceptionSupplier].
  T orElseThrow(ExceptionSupplier exceptionSupplier) {
    if (isPresent()) return _value!;
    throw exceptionSupplier();
  }

  /// Executes `ifPresentCallback` if value is present, otherwise executes `elseCallback`.
  void ifPresentOrElse(Consumer<T> ifPresentCallback, void Function() elseCallback) {
    isPresent() ? ifPresentCallback(_value!) : elseCallback();
  }

  /// Returns the first item in the list that matches the condition.
  T firstIf(Checker<T> condition) {
    if (_value is List<T>) {
      for (var item in _value as List<T>) {
        if (condition(item)) return item;
      }
    }
    throw HapniumException("$condition item is not in list");
  }

  /// Returns the first item of type `U` in the list that matches the condition.
  /// Throws [HapniumException] if no item matches or _value is not a list.
  U firstIn<U>(Checker<U> condition) {
    if (_value is List) {
      for (var item in _value as List) {
        if (item is U && condition(item)) return item;
      }
      throw HapniumException("No item of type $U satisfies the condition");
    }
    throw HapniumException("Value is not a list");
  }

  /// Filters list elements based on a predicate.
  Optional<List<T>> filterList(Checker<T> predicate) {
    if (_value is List<T>) {
      return Optional.ofNullable((_value as List<T>).where(predicate).toList());
    }
    return Optional.empty();
  }

  /// Maps list elements to another type.
  Optional<List<U>> mapList<U>(Mapper<T, U> mapper) {
    if (_value is List<T>) {
      return Optional.ofNullable((_value as List<T>).map(mapper).toList());
    } else if (_value is Map) {
      return Optional.ofNullable((_value as Map).entries.map((MapEntry<dynamic, dynamic> entry) => mapper(entry.value as T)).toList());
    }
    return Optional.empty();
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Optional && runtimeType == other.runtimeType && (_value == other._value);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => isPresent() ? 'Optional[$_value]' : 'Optional.empty';
}