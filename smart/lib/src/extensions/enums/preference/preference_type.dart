import '../../../enums/preference/preference_type.dart';

/// An extension on [PreferenceType] to provide convenient boolean checks for each preference status.
///
/// This extension allows you to easily compare a [PreferenceType] instance to specific predefined values.
/// Instead of writing verbose equality checks (e.g., `if (preference == PreferenceType.security)`),
/// you can use expressive getters like `preference.isSecurity` for cleaner and more readable code.
extension PreferenceTypeExtension on PreferenceType {
  /// Returns `true` if the preference option is set to [PreferenceType.security].
  bool get isSecurity => this == PreferenceType.security;

  /// Returns `true` if the preference option is set to [PreferenceType.schedule].
  bool get isSchedule => this == PreferenceType.schedule;

  /// Returns `true` if the preference option is set to [PreferenceType.theme].
  bool get isTheme => this == PreferenceType.theme;

  /// Returns `true` if the preference option is set to [PreferenceType.gender].
  bool get isGender => this == PreferenceType.gender;

  /// Returns `true` if the preference option is set to [PreferenceType.preference].
  bool get isPreference => this == PreferenceType.preference;
}