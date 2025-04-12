/// Represents different security mechanisms available for authentication.
///
/// This enum defines various security options a user can choose for authentication,
/// including biometrics, multi-factor authentication (MFA), both, or none.
enum SecurityType {
  /// Security via biometric authentication (e.g., fingerprint, face recognition).
  biometrics("Biometrics"),

  /// Security through multi-factor authentication (e.g., OTP, authentication apps).
  mfa("Multi-Factor Authentication"),

  /// Combination of both biometrics and multi-factor authentication for enhanced security.
  both("Biometrics and Multi-Factor Authentication"),

  /// No security mechanism is enforced.
  none("None");

  /// A human-readable description of the security type.
  final String type;

  /// Creates a [SecurityType] with the given [type] description.
  const SecurityType(this.type);
}