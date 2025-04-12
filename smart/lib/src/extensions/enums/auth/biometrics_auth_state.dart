import '../../../enums/auth/biometrics_auth_state.dart';

/// Provides convenience checks for [BiometricAuthState].
///
/// Example:
/// ```dart
/// if (authState.isSuccessful) {
///   print("User successfully authenticated.");
/// }
/// ```
extension BiometricAuthStateExtension on BiometricAuthState {
  /// Returns `true` if the biometrics authentication state is set to [BiometricAuthState.failed].
  ///
  /// This indicates that the user's biometrics authentication failed.
  bool get isFailed => this == BiometricAuthState.failed;

  /// Returns `true` if the biometrics authentication state is set to [BiometricAuthState.successful].
  ///
  /// This indicates that the user's biometrics authentication was successful.
  bool get isSuccessful => this == BiometricAuthState.successful;

  /// Returns `true` if the biometrics authentication state is set to [BiometricAuthState.none].
  ///
  /// This indicates that the user's biometrics authentication has not started.
  bool get isNone => this == BiometricAuthState.none;
}