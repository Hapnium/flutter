import '../../../enums/preference/gender.dart';

/// Provides readable checks for [Gender].
///
/// Example:
/// ```dart
/// if (userGender.isMale) {
///   print("User selected Male.");
/// }
/// ```
extension GenderExtension on Gender {
  /// Returns `true` if the gender is set to [Gender.male].
  ///
  /// This indicates that the user is a male.
  bool get isMale => this == Gender.male;

  /// Returns `true` if the gender is set to [Gender.female].
  ///
  /// This indicates that the user is a female.
  bool get isFemale => this == Gender.female;

  /// Returns `true` if the gender is set to [Gender.any].
  ///
  /// This indicates that the user is a different gender than specified.
  bool get isAny => this == Gender.any;

  /// Returns `true` if the gender is set to [Gender.none].
  ///
  /// This indicates that the user has not selected a gender.
  bool get isNone => this == Gender.none;
}