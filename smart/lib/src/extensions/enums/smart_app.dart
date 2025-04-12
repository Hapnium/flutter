import '../../enums/smart_app.dart';

/// Provides convenience checks for [SmartApp].
///
/// This extension provides methods to check the type of a `SmartApp` enum value.
///
/// Example:
/// ```dart
/// if (SmartApp.isUser) {
///   print("The current app is the user application.");
/// }
/// ```
extension SmartAppExtension on SmartApp {
  /// Returns `true` if the `SmartApp` value is set to [SmartApp.user].
  ///
  /// This indicates that the current application is the user-facing application.
  bool get isUser => this == SmartApp.user;

  /// Returns `true` if the `SmartApp` value is set to [SmartApp.provider].
  ///
  /// This indicates that the current application is the service provider application.
  bool get isProvider => this == SmartApp.provider;

  /// Returns `true` if the `SmartApp` value is set to [SmartApp.business].
  ///
  /// This indicates that the current application is the business management application.
  bool get isBusiness => this == SmartApp.business;

  /// Returns `true` if the `SmartApp` value is set to [SmartApp.nearby].
  ///
  /// This indicates that the current application is the nearby services application.
  bool get isNearby => this == SmartApp.nearby;
}