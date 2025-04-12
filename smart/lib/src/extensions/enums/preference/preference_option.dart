import '../../../enums/preference/preference_option.dart';

/// An extension on [PreferenceOption] to provide convenient boolean checks for each preference status.
///
/// This extension allows you to easily compare a [PreferenceOption] instance to specific predefined values.
/// Instead of writing verbose equality checks (e.g., `if (preference == PreferenceOption.inApp)`),
/// you can use expressive getters like `preference.isInApp` for cleaner and more readable code.
///
/// Example Usage:
/// ```dart
/// PreferenceOption option = PreferenceOption.inApp;
/// if (option.isInApp) {
///   print("User prefers in-app notifications.");
/// }
/// ```
extension PreferenceOptionExtension on PreferenceOption {
  /// Returns `true` if the preference option is set to [PreferenceOption.inApp].
  ///
  /// This indicates that the user has opted to receive notifications only within the application.
  bool get isInApp => this == PreferenceOption.inApp;

  /// Returns `true` if the preference option is set to [PreferenceOption.phone].
  ///
  /// This means the user prefers to receive notifications via phone (such as SMS or calls).
  bool get isPhone => this == PreferenceOption.phone;

  /// Returns `true` if the preference option is set to [PreferenceOption.all].
  ///
  /// This signifies that the user has chosen to receive notifications through all available channels.
  bool get isAll => this == PreferenceOption.all;

  /// Returns `true` if the preference option is set to [PreferenceOption.none].
  ///
  /// This means the user has opted out of receiving any notifications.
  bool get isNone => this == PreferenceOption.none;
}