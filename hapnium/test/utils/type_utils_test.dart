import 'package:test/test.dart';
import 'package:hapnium/hapnium.dart';

void main() {
  group('TypeUtils', () {
    group('valueOf', () {
      test('should convert various types to strings', () {
        expect(TypeUtils.valueOf(100), '100');
        expect(TypeUtils.valueOf(3.14), '3.14');
        expect(TypeUtils.valueOf(true), 'true');
        expect(TypeUtils.valueOf(false), 'false');
        expect(TypeUtils.valueOf([1, 2, 3]), '[1, 2, 3]');
        expect(TypeUtils.valueOf({'a': 1, 'b': 2}), '{a: 1, b: 2}');
        expect(TypeUtils.valueOf(null), 'null');
      });
    });

    group('toBoolean', () {
      test('should convert strings to booleans', () {
        expect(TypeUtils.toBoolean("true"), isTrue);
        expect(TypeUtils.toBoolean("TRUE"), isTrue); // Case-insensitive
        expect(TypeUtils.toBoolean("  true  "), isTrue); // Trimmed
        expect(TypeUtils.toBoolean("false"), isFalse);
        expect(TypeUtils.toBoolean("FALSE"), isFalse); // Case-insensitive
        expect(TypeUtils.toBoolean("  false  "), isFalse); // Trimmed
        expect(TypeUtils.toBoolean("anything else"), isFalse); // Invalid string
      });

      test('should convert integers to booleans', () {
        expect(TypeUtils.toBoolean(1), isTrue);
        expect(TypeUtils.toBoolean(0), isFalse);
        expect(TypeUtils.toBoolean(-1), isFalse); // Anything other than 1 is false
        expect(TypeUtils.toBoolean(2), isFalse);
      });

      test('should return the boolean value itself', () {
        expect(TypeUtils.toBoolean(true), isTrue);
        expect(TypeUtils.toBoolean(false), isFalse);
      });

      test('should return false for other types', () {
        expect(TypeUtils.toBoolean(3.14), isFalse);
        expect(TypeUtils.toBoolean([1, 2, 3]), isFalse);
        expect(TypeUtils.toBoolean({'a': 1}), isFalse);
      });

      test('should handle null values', () {
        expect(TypeUtils.toBoolean(null), isFalse);
      });
    });
  });
}