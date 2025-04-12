import '../../../enums/auth/mfa_auth.dart';

/// Provides simple checks for [MfaAuth] status.
///
/// Example:
/// ```dart
/// if (mfa.isEnabled) {
///   print("MFA is enabled.");
/// }
/// ```
extension MfaAuthExtension on MfaAuth {
  /// Returns `true` if the multi-factor authentication option is set to [MfaAuth.enable].
  ///
  /// This indicates that the user has opted to enable MFA in the application.
  bool get isEnabled => this == MfaAuth.enable;

  /// Returns `true` if the multi-factor authentication option is set to [MfaAuth.disable].
  ///
  /// This indicates that the user has opted to disable MFA in the application.
  bool get isDisabled => this == MfaAuth.disable;

  /// Returns `true` if the multi-factor authentication option is set to [MfaAuth.login].
  ///
  /// This indicates that the user has opted to login with MFA in the application.
  bool get isLogin => this == MfaAuth.login;
}