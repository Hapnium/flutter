/// Represents the authentication state for Multi-Factor Authentication (MFA).
///
/// This enum determines whether MFA is enabled, disabled, or if a login is required.
enum MfaAuth {
  /// MFA is enabled.
  enable,

  /// MFA is disabled.
  disable,

  /// User is required to log in using MFA.
  login,
}