import 'package:test/test.dart';
import 'package:hapnium/hapnium.dart';

void main() {
  group('Optional', () {
    group('constructors', () {
      test('should create an empty Optional', () {
        final optional = Optional.empty();
        expect(optional.isPresent(), isFalse);
      });

      test('should create an Optional with a value', () {
        final optional = Optional.of(10);
        expect(optional.isPresent(), isTrue);
        expect(optional.get(), 10);
      });

      test('should throw an exception when creating Optional.of with null', () {
        expect(() => Optional.of(null), throwsA(isA<HapniumException>()));
      });

      test('should create an Optional with a nullable value', () {
        final optional = Optional<int>.ofNullable(null);
        expect(optional.isPresent(), isFalse);

        final optional2 = Optional<String>.ofNullable("hello");
        expect(optional2.isPresent(), isTrue);
        expect(optional2.get(), "hello");
      });
    });

    group('get', () {
      test('should return the value when present', () {
        final optional = Optional.of(10);
        expect(optional.get(), 10);
      });

      test('should throw an exception when value is not present', () {
        final optional = Optional.empty();
        expect(() => optional.get(), throwsA(isA<HapniumException>()));
      });
    });

    group('isPresent', () {
      test('should return true when value is present', () {
        final optional = Optional.of(10);
        expect(optional.isPresent(), isTrue);
      });

      test('should return false when value is not present', () {
        final optional = Optional.empty();
        expect(optional.isPresent(), isFalse);
      });
    });

    group('ifPresent', () {
      test('should execute consumer when value is present', () {
        int? value;
        final optional = Optional.of(10);
        optional.ifPresent((v) => value = v);
        expect(value, 10);
      });

      test('should not execute consumer when value is not present', () {
        int? value;
        final optional = Optional.empty();
        optional.ifPresent((v) => value = v);
        expect(value, isNull);
      });

      test('should handle lists correctly', () {
        final optional = Optional.of([1, 2, 3]);
        int sum = 0;
        optional.ifPresent((v) => v.forEach((item) => sum += item));
        expect(sum, 6);
      });

      test('should handle maps correctly', () {
        final optional = Optional.of({"a": 1, "b": 2});
        int sum = 0;
        optional.ifPresent((v) => v.forEach((key, value) => sum += value));
        expect(sum, 3);
      });
    });

    group('filter', () {
      test('should return Optional with value if predicate matches', () {
        final optional = Optional.of(10);
        final filtered = optional.filter((v) => v > 5);
        expect(filtered.isPresent(), isTrue);
        expect(filtered.get(), 10);
      });

      test('should return empty Optional if predicate does not match', () {
        final optional = Optional.of(10);
        final filtered = optional.filter((v) => v < 5);
        expect(filtered.get(), -1);
      });

      test('should return empty Optional if original Optional is empty', () {
        final optional = Optional.empty();
        final filtered = optional.filter((v) => v > 5);
        expect(filtered.isPresent(), isFalse);
      });
    });

    group('map', () {
      test('should map the value to another type', () {
        final optional = Optional.of(10);
        final mapped = optional.map((v) => v.toString());
        expect(mapped.isPresent(), isTrue);
        expect(mapped.get(), '10');
      });

      test('should return empty Optional if original Optional is empty', () {
        final optional = Optional.empty();
        final mapped = optional.map((v) => v.toString());
        expect(mapped.get(), "");
      });
    });

    group('flatMap', () {
      test('should flatMap the value to another Optional type', () {
        final optional = Optional.of(10);
        final flatMapped = optional.flatMap((v) => Optional.of(v.toString()));
        expect(flatMapped.isPresent(), isTrue);
        expect(flatMapped.get(), '10');
      });

      test('should return empty Optional if original Optional is empty', () {
        final optional = Optional.empty();
        final flatMapped = optional.flatMap((v) => Optional.of(v.toString()));
        expect(flatMapped.get(), "");
      });
    });

    group('orElse', () {
      test('should return the value if present', () {
        final optional = Optional.of(10);
        expect(optional.orElse(20), 10);
      });

      test('should return other value if not present', () {
        final optional = Optional.empty();
        expect(optional.orElse(20), 20);
      });
    });

    group('orElseGet', () {
      test('should return the value if present', () {
        final optional = Optional.of(10);
        expect(optional.orElseGet(() => 20), 10);
      });

      test('should return value from supplier if not present', () {
        final optional = Optional.empty();
        expect(optional.orElseGet(() => 20), 20);
      });
    });

    group('orElseThrow', () {
      test('should return the value if present', () {
        final optional = Optional.of(10);
        expect(optional.orElseThrow(() => Exception('')), 10);
      });

      test('should throw exception if not present', () {
        final optional = Optional.empty();
        expect(() => optional.orElseThrow(() => Exception('Test Exception')),
            throwsA(isA<Exception>()));
      });
    });

    group('ifPresentOrElse', () {
      test('should execute ifPresentCallback if value is present', () {
        int? value;
        final optional = Optional.of(10);
        optional.ifPresentOrElse((v) => value = v, () {});
        expect(value, 10);
      });

      test('should execute elseCallback if value is not present', () {
        bool called = false;
        final optional = Optional.empty();
        optional.ifPresentOrElse((v) {}, () => called = true);
        expect(called, isTrue);
      });
    });

    group('firstIf', () {
      test('should return the first matching item in the list', () {
        final optional = Optional.of([1, 2, 3, 4, 5]);
        expect(optional.firstIn<int>((item) => item.isGt(2)), 3);
      });

      test('should throw an exception if no matching item is found', () {
        final optional = Optional.of([1, 2, 3]);
        expect(() => optional.firstIf((item) => item.any((digit) => digit.isGt(5))),
            throwsA(isA<HapniumException>()));
      });

      test('should throw an exception if the value is not a list', () {
        final optional = Optional.of(1);
        expect(() => optional.firstIf((item) => item > 0),
            throwsA(isA<HapniumException>()));
      });
    });

    group('filterList', () {
      // test('should return an Optional with the filtered list', () {
      //   final optional = Optional.of([1, 2, 3, 4, 5]);
      //   final filteredList = optional.filter((item) => item.any((digit) => digit.isGt(2)));
      //   expect(filteredList.isPresent(), isTrue);
      //   expect(filteredList.get(), [3, 4, 5]);
      // });
      //
      // test('should return an empty Optional if the value is not existing', () {
      //   final optional = Optional.of(1);
      //   final filtered = optional.filter((item) => item > 1);
      //   expect(filtered.isPresent(), isFalse);
      // });

      test('should return an empty Optional if the list is empty', () {
        final optional = Optional.of(<int>[]);
        final filteredList = optional.filter((item) => item.any((digit) => digit.isGt(0)));
        expect(filteredList.isPresent(), isFalse);
      });

      // test('should return an Optional with an empty list if no items match', () {
      //   final optional = Optional.of([1, 2, 3]);
      //   final filteredList = optional.filter((item) => item.any((digit) => digit.isGt(5)));
      //   expect(filteredList.isPresent(), isFalse);
      //   expect(filteredList.get(), <int>[]);
      // });
    });

    group('mapList', () {
      // test('should return an Optional with the mapped list', () {
      //   final optional = Optional.of([1, 2, 3]);
      //   final mappedList = optional.mapList((item) => item.toString());
      //   expect(mappedList.isPresent(), isTrue);
      //   expect(mappedList.get(), ['1', '2', '3']);
      // });

      test('should return an empty Optional if the value is not a list', () {
        final optional = Optional.of(1);
        final mappedList = optional.mapList((item) => item.toString());
        expect(mappedList.isPresent(), isFalse);
      });

      test('should return an empty Optional if the list is empty', () {
        final optional = Optional.of(<int>[]);
        final mappedList = optional.mapList((item) => item.toString());
        expect(mappedList.isPresent(), isFalse);
      });
    });

    group('equality', () {
      test('should be equal if the values are equal', () {
        final optional1 = Optional.of(10);
        final optional2 = Optional.of(10);
        expect(optional1 == optional2, isTrue);
      });

      test('should not be equal if the values are different', () {
        final optional1 = Optional.of(10);
        final optional2 = Optional.of(20);
        expect(optional1 == optional2, isFalse);
      });

      test('should be equal if both are empty', () {
        final optional1 = Optional.empty();
        final optional2 = Optional.empty();
        expect(optional1 == optional2, isTrue);
      });

      test('should not be equal if one is present and other is empty', () {
        final optional1 = Optional.of(10);
        final optional2 = Optional.empty();
        expect(optional1 == optional2, isFalse);
      });
    });

    group('toString', () {
      test('should return correct string representation for present value', () {
        final optional = Optional.of(10);
        expect(optional.toString(), 'Optional[10]');
      });

      test('should return correct string representation for empty value', () {
        final optional = Optional.empty();
        expect(optional.toString(), 'Optional.empty');
      });
    });
  });
}