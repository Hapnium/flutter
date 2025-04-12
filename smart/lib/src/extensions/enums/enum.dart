import 'package:smart/enums.dart';

extension EnumExtension on String {
  /// Convert a string to a `ThemeType` enum.
  ThemeType get toThemeType {
    switch (toLowerCase()) {
      case "light":
        return ThemeType.light;
      case "dark":
        return ThemeType.dark;
      default:
        return ThemeType.light;
    }
  }

  /// Convert a string to a `SmartApp` enum.
  SmartApp get toApp {
    switch (toLowerCase()) {
      case "user":
        return SmartApp.user;
      case "hapnium":
        return SmartApp.user;
      case "provider":
        return SmartApp.provider;
      case "business":
        return SmartApp.business;
      default:
        return SmartApp.nearby;
    }
  }

  /// Convert a string to a `PreferenceOption` enum.
  PreferenceOption get toPreferenceOption {
    switch (toLowerCase()) {
      case "phone":
        return PreferenceOption.phone;
      case "in-app":
        return PreferenceOption.inApp;
      case "all":
        return PreferenceOption.all;
      case "none":
        return PreferenceOption.none;
      default:
        return PreferenceOption.all;
    }
  }

  /// Convert a string to a `MediaType` enum.
  MediaType get toMediaType {
    switch (toLowerCase()) {
      case "video":
        return MediaType.video;
      case "photo":
        return MediaType.photo;
      default:
        return MediaType.video;
    }
  }

  /// Convert a string to a `ScheduleTime` enum.
  ScheduleTime get toScheduleTime {
    switch (toLowerCase()) {
      case "30 min":
        return ScheduleTime.thirtyMinutes;
      case "20 min":
        return ScheduleTime.twentyMinutes;
      case "10 min":
        return ScheduleTime.tenMinutes;
      default:
        return ScheduleTime.thirtyMinutes;
    }
  }

  /// Convert a string to a `Gender` enum.
  Gender get toGender {
    switch (toLowerCase()) {
      case "male":
        return Gender.male;
      case "female":
        return Gender.female;
      case "any":
        return Gender.any;
      default:
        return Gender.none;
    }
  }

  /// Convert a string to a `BiometricAuthState` enum.
  BiometricAuthState get toBiometricAuthState {
    switch (toLowerCase()) {
      case "failed":
        return BiometricAuthState.failed;
      case "successful":
        return BiometricAuthState.successful;
      default:
        return BiometricAuthState.none;
    }
  }

  /// Convert a string to a `CallStatus` enum.
  CallStatus get toCallStatus {
    switch (toLowerCase()) {
      case "ringing":
        return CallStatus.ringing;
      case "disconnected":
        return CallStatus.disconnected;
      case "calling":
        return CallStatus.calling;
      case "closed":
        return CallStatus.closed;
      case "reconnecting":
        return CallStatus.reconnecting;
      case "declined":
        return CallStatus.declined;
      case "on call":
        return CallStatus.onCall;
      case "on_call":
        return CallStatus.onCall;
      case "missed":
        return CallStatus.missed;
      default:
        return CallStatus.ringing;
    }
  }

  /// Convert a string to a `CallType` enum.
  CallType get toCallType {
    switch (toLowerCase()) {
      case "voice":
        return CallType.voice;
      case "t2f":
        return CallType.tip2fix;
      case "tip2fix":
        return CallType.tip2fix;
      default:
        return CallType.voice;
    }
  }

  /// Convert a string to a `MfaAuth` enum.
  MfaAuth get toMfaAuth {
    switch (toLowerCase()) {
      case "enable":
        return MfaAuth.enable;
      case "disable":
        return MfaAuth.disable;
      default:
        return MfaAuth.login;
    }
  }

  /// Convert a string to a `SecurityType` enum.
  SecurityType get toSecurityType {
    switch (toLowerCase()) {
      case "biometrics":
        return SecurityType.biometrics;
      case "multi-factor authentication":
        return SecurityType.mfa;
      case "biometrics and multi-factor authentication":
        return SecurityType.both;
      default:
        return SecurityType.none;
    }
  }

  /// Converts a string to a `FeedbackType` enum.
  FeedbackType get toFeedbackType {
    switch (toLowerCase()) {
      case 'account':
        return FeedbackType.account;
      case 'shop':
        return FeedbackType.shop;
      case 'trip':
        return FeedbackType.trip;
      case 'app':
        return FeedbackType.app;
      case 'call':
        return FeedbackType.call;
      case 'event':
        return FeedbackType.event;
      case 'club':
        return FeedbackType.club;
      case 'community':
        return FeedbackType.community;
      default:
        return FeedbackType.app; // Default to 'app' if no match is found
    }
  }
}