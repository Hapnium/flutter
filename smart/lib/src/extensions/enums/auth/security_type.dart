import '../../../enums/auth/security_type.dart';

/// Provides convenience checks for [SecurityType].
///
/// Example:
/// ```dart
/// if (securityType.isMfa) {
///   print("Multi-factor authentication is enabled.");
/// }
/// ```
extension SecurityTypeExtension on SecurityType {
  /// Returns `true` if the security type is set to [SecurityType.biometrics].
  ///
  /// This indicates that the user has opted to biometrics security lock in the application.
  bool get isBiometrics => this == SecurityType.biometrics;

  /// Returns `true` if the security type is set to [SecurityType.mfa].
  ///
  /// This indicates that the user has opted to mfa `Multi-Factor Authentication` security lock in the application.
  bool get isMfa => this == SecurityType.mfa;

  /// Returns `true` if the security type is set to [SecurityType.both].
  ///
  /// This indicates that the user has opted to both biometrics and mfa security lock in the application.
  bool get isBoth => this == SecurityType.both;

  /// Returns `true` if the security type is set to [SecurityType.none].
  ///
  /// This indicates that the user has not opted to security lock in the application.
  bool get isNone => this == SecurityType.none;
}