import 'package:hapnium/src/classes/optional.dart';
import 'package:test/test.dart';

void main() {
  group('Optional', () {
    test('Optional.of should store value', () {
      var optional = Optional.of(42);
      expect(optional.isPresent(), isTrue);
      expect(optional.get(), 42);
    });

    test('Optional.empty should be empty', () {
      var optional = Optional.empty();
      expect(optional.isPresent(), isFalse);
    });

    test('Calling get on empty Optional should throw exception', () {
      var optional = Optional.empty();
      expect(() => optional.get(), throwsException);
    });
  });
}