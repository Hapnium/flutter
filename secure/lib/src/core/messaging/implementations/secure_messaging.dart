import 'package:secure/secure.dart';

import 'ec_secure_messaging.dart';
import 'rsa_secure_messaging.dart';
import '../secure_messaging_service.dart';

/// Abstract class to provide a unified interface for secure messaging.
///
/// This class acts as a facade, delegating secure messaging operations to the
/// appropriate implementation ([RSASecureMessaging] or [ECSecureMessaging])
/// based on the provided [PemStyle].
abstract class SecureMessaging implements SecureMessagingService {
  /// Specifies the style of key (RSA or EC) to use.
  final PemStyle style;

  /// Private constructor to prevent direct instantiation.
  ///
  /// This constructor is intended to be used by subclasses and factory constructors.
  SecureMessaging(this.style);

  /// Factory method to dynamically resolve the appropriate implementation.
  ///
  /// This method is `deprecated`. Please use `SecureMessaging.ec()` or
  /// `SecureMessaging.rsa()` instead.
  ///
  /// **Parameters:**
  ///
  /// * `style`: The [PemStyle] to use for resolving the implementation.
  ///
  /// **Returns:**
  ///
  /// An instance of either [RSASecureMessaging] or [ECSecureMessaging] based
  /// on the provided [PemStyle].
  @deprecated
  static SecureMessaging resolve(PemStyle style) {
    if (style == PemStyle.RSA) {
      return SecureMessaging.rsa();
    } else {
      return SecureMessaging.ec();
    }
  }

  /// Factory constructor to create the [ECSecureMessaging] implementation.
  ///
  /// This method returns an instance of [ECSecureMessaging], which provides
  /// Elliptic Curve (EC) based secure messaging functionalities.
  ///
  /// **Returns:**
  ///
  /// An instance of [ECSecureMessaging].
  factory SecureMessaging.ec() {
    return ECSecureMessaging();
  }

  /// Factory constructor to create the [RSASecureMessaging] implementation.
  ///
  /// This method returns an instance of [RSASecureMessaging], which provides
  /// RSA-based secure messaging functionalities.
  ///
  /// **Returns:**
  ///
  /// An instance of [RSASecureMessaging].
  factory SecureMessaging.rsa() {
    return RSASecureMessaging();
  }
}