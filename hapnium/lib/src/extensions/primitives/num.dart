import './iterable.dart';

extension NumExtensions on num {
  /// Case equality check.
  bool equals(num other) => this == other;

  /// Checks if num equals any item in the list
  bool equalsAny(List<num> values) => values.any((v) => equals(v));
  
  /// Checks if num equals all items in the list
  bool equalsAll(List<num> values) => values.all((v) => equals(v));

  /// Case in-equality check.
  bool notEquals(num other) => this != other;

  /// Checks if num does not equals any item in the list
  bool notEqualsAny(List<num> values) => !values.any((v) => equals(v));
  
  /// Checks if num does not equals all items in the list
  bool notEqualsAll(List<num> values) => !values.all((v) => equals(v));

  /// Returns the length of this int value
  int get length => toString().replaceAll('.', '').length;

  /// Checks if LOWER than num b.
  bool isLessThan(num b) => this < b;

  /// Short form for `isLessThan`
  bool isLt(num b) => isLessThan(b);

  /// Checks if GREATER than num b.
  bool isGreaterThan(num b) => this > b;

  /// Short form for `isGreaterThan`
  bool isGt(num b) => isGreaterThan(b);

  /// Checks if LOWER than num b.
  bool isLessThanOrEqualTo(num b) => isLessThan(b) || equals(b);

  /// Short form for `isLessThanOrEqualTo`
  bool isLtOrEt(num b) => isLessThanOrEqualTo(b);

  /// Checks if GREATER than num b.
  bool isGreaterThanOrEqualTo(num b) => isGreaterThan(b) || equals(b);

  /// Short form for `isGreaterThanOrEqualTo`
  bool isGtOrEt(num b) => isGreaterThanOrEqualTo(b);

  /// Checks if length of double value is GREATER than max.
  bool isLengthGreaterThan(int max) => length > max;

  /// Short form for `isLengthGreaterThan`
  bool isLengthGt(int max) => isLengthGreaterThan(max);

  /// Checks if length of double value is GREATER OR EQUAL to max.
  bool isLengthGreaterThanOrEqualTo(int max) => length >= max;

  /// Short form for `isLengthGreaterThanOrEqualTo`
  bool isLengthGtOrEt(int max) => isLengthGreaterThanOrEqualTo(max);

  /// Checks if length of double value is LESS than max.
  bool isLengthLessThan(int max) => length < max;

  /// Short form for `isLengthLessThan`
  bool isLengthLt(int max) => isLengthLessThan(max);

  /// Checks if length of double value is LESS OR EQUAL to max.
  bool isLengthLessThanOrEqualTo(int max) => length <= max;

  /// Short form for `isLengthLessThanOrEqualTo`
  bool isLengthLtOrEt(int max) => isLengthLessThanOrEqualTo(max);

  /// Checks if length of double value is EQUAL to max.
  bool isLengthEqualTo(int other) => length == other;

  /// Short form for `isLengthEqualTo`
  bool isLengthEt(int max) => isLengthEqualTo(max);

  /// Checks if length of double value is BETWEEN minLength to max.
  bool isLengthBetween(int min, int max) => isLengthGreaterThanOrEqualTo(min) && isLengthLessThanOrEqualTo(max);

  /// Divides the current number by the given value.
  num divideBy(num value) => this / value;

  /// Multiplies the current number by the given value.
  num multiplyBy(num value) => this * value;

  /// Adds the given value to the current number.
  num plus(num value) => this + value;

  /// Subtracts the given value from the current number.
  num minus(num value) => this - value;

  /// Returns the remainder of the division.
  num remainder(num value) => this % value;

  /// Performs integer division and returns the quotient.
  int iq(num value) => this ~/ value;

  /// Negates the number.
  num negated() => -this;

  /// Converts numbers to human-readable strings.
  ///
  /// This function takes a numeric input and formats it into a more concise,
  /// human-readable string representation, using abbreviations for large numbers.
  ///
  /// **Examples:**
  ///
  /// * `3300` -> `"3.3k"`
  /// * `2300000` -> `"2.3M"`
  /// * `1200000000` -> `"1.2B"`
  ///
  /// **Behavior:**
  ///
  /// * Numbers less than 1000 are returned as their string representation.
  /// * Numbers between 1000 and 1,000,000 are divided by 1000 and appended with "k" (thousands).
  /// * Numbers between 1,000,000 and 1,000,000,000 are divided by 1,000,000 and appended with "M" (millions).
  /// * Numbers greater than or equal to 1,000,000,000 are divided by 1,000,000,000 and appended with "B" (billions).
  /// * The result is formatted to one decimal place.
  ///
  /// **Parameters:**
  ///
  /// * `number`: The numeric value to be converted.
  ///
  /// **Returns:**
  ///
  /// A human-readable string representation of the input number.
  String get prettyFormat {
    if (this < 1000) {
      return this.toString();
    } else if (this < 1_000_000) {
      return "${(this / 1000.0).toStringAsFixed(1)}k";
    } else if (this < 1_000_000_000) {
      return "${(this / 1_000_000.0).toStringAsFixed(1)}M";
    } else {
      return "${(this / 1_000_000_000.0).toStringAsFixed(1)}B";
    }
  }
}