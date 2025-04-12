import 'package:notify/notify.dart';

/// Provides platform identification utilities.
class PlatformEngine {
  // Private constructor for singleton pattern
  PlatformEngine._();

  // The single instance of the Platform
  static final PlatformEngine _instance = PlatformEngine._();

  /// Access the singleton instance of [PlatformEngine].
  static PlatformEngine get instance => _instance;

  late NotifyPlatform _platform;
  bool _isInitialized = false;
  String _errorMessage = "Notify is not initialized. You need to wrap your material app with `NotifyWrapper`";

  void init(NotifyPlatform platform) {
    _platform = platform;
    _isInitialized = true;
  }

  /// Returns `true` if the application is running on a web platform.
  bool get isWeb {
    if(_isInitialized) {
      return _platform == NotifyPlatform.WEB;
    } else {
      throw NotifyException(_errorMessage);
    }
  }

  /// Returns `true` if the application is running on an Android device.
  bool get isAndroid {
    if(_isInitialized) {
      return _platform == NotifyPlatform.ANDROID;
    } else {
      throw NotifyException(_errorMessage);
    }
  }

  /// Returns `true` if the application is running on an iOS device.
  bool get isIOS {
    if(_isInitialized) {
      return _platform == NotifyPlatform.IOS;
    } else {
      throw NotifyException(_errorMessage);
    }
  }

  /// Returns `true` if the application is running on an mobile device.
  bool get isMobile {
    if(_isInitialized) {
      return !isWeb && (isAndroid || isIOS);
    } else {
      throw NotifyException(_errorMessage);
    }
  }
}