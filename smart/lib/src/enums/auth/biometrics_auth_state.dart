/// Represents different states of biometric authentication.
///
/// This enum helps track whether biometric authentication was successful, failed, or unused.
enum BiometricAuthState {
  /// No biometric authentication was performed.
  none,

  /// Biometric authentication was successful.
  successful,

  /// Biometric authentication failed.
  failed,
}