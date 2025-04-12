extension BoolExtensions on bool {
  /// Converts the boolean to an integer (1 for true, 0 for false).
  int toInt() => this ? 1 : 0;

  /// Checks if the current value of this boolean is `false`
  bool get isFalse => this == false;

  /// Checks if the current value of this boolean is `true`
  bool get isTrue => this == true;

  /// Case equality check.
  bool equals(bool other) => this == other;

  /// Case in-equality check.
  bool notEquals(bool other) => this != other;
}