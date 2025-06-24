import 'dart:ui' show Color;

import '../config/definitions.dart';
import '../enums/tappy_type.dart';
import 'remote_notification.dart';

/// {@template remote_notification_config}
/// A configuration object for handling remote notifications in a structured way.
///
/// `RemoteNotificationConfig` encapsulates metadata about incoming notifications
/// along with flags to help classify the type of notification (e.g., chat, call, trip).
/// It also manages UI behaviors and platform-specific details that determine
/// how a notification should be processed in different contexts.
///
/// Use this class when consuming notification payloads from external services,
/// and route your app logic (UI, in-app behavior, logging, etc.) based on the provided flags.
///
/// ### Example usage:
///
/// ```dart
/// final config = RemoteNotificationConfig.fromData(
///   data: rawData,
///   isBackground: true,
///   app: TappyApp.user,
///   platform: TappyPlatform.android,
///   title: 'Default Title',
///   body: 'Default Body',
/// );
///
/// if (config.isChat) {
///   showChatMessage(config.notification);
/// }
/// ```
/// {@endtemplate}
class RemoteNotificationConfig<T> {
  /// The parsed and typed notification payload.
  final RemoteNotification<T> notification;

  /// Indicates whether the notification is handled in the background.
  ///
  /// Default: `false`
  final bool isBackground;

  /// Whether this notification should trigger in-app logic or UI.
  ///
  /// Default: `false`
  final bool useInApp;

  /// The timezone associated with the notification event.
  ///
  /// Default: `""`
  final String timezone;

  /// True if the notification is classified as a chat message.
  ///
  /// Used to trigger chat-specific handling logic.
  final TappyType type;

  /// The color used for primary action buttons in the notification UI.
  ///
  /// Default: `null`
  final Color? buttonColor;

  /// Background color for the notification card or popup.
  ///
  /// Default: `null`
  final Color? backgroundColor;

  /// Color used for destructive or danger-style buttons.
  ///
  /// Default: `null`
  final Color? dangerButtonColor;

  /// The custom sound to be played when the notification is received.
  ///
  /// Default: `null`
  final String? sound;

  /// A callback function that gets triggered when the notification message is decrypted.
  ///
  /// Commonly used in chat messages for secure handling.
  ///
  /// Default: `null`
  final MessageDecryptionCallback? onMessageDecrypted;

  /// {@macro remote_notification_config}
  const RemoteNotificationConfig._({
    required this.notification,
    required this.isBackground,
    required this.useInApp,
    required this.timezone,
    required this.type,
    required this.onMessageDecrypted,
    required this.buttonColor,
    required this.backgroundColor,
    required this.dangerButtonColor,
    required this.sound,
  });

  /// Factory constructor to create a [RemoteNotificationConfig] from a raw data map.
  ///
  /// This method uses [TappyTypeChecker] to classify the notification
  /// and fills in fallback values if the type is unrecognized.
  ///
  /// Returns an instance of [RemoteNotificationConfig] with all computed flags and UI preferences.
  ///
  /// {@macro remote_notification_config}
  factory RemoteNotificationConfig.fromData({
    required Data data,
    bool isBackground = false,
    bool useInApp = false,
    String timezone = "",
    String title = "",
    String body = "",
    Color? buttonColor,
    Color? backgroundColor,
    Color? dangerButtonColor,
    String? sound,
    MessageDecryptionCallback? onMessageDecrypted,
  }) {
    return RemoteNotificationConfig._(
      notification: TappyType.build(data, title, body),
      type: TappyType.fromData(data),
      isBackground: isBackground,
      useInApp: useInApp,
      timezone: timezone,
      onMessageDecrypted: onMessageDecrypted,
      buttonColor: buttonColor,
      backgroundColor: backgroundColor,
      dangerButtonColor: dangerButtonColor,
      sound: sound,
    );
  }

  /// Serializes the notification config into a JSON-compatible map.
  ///
  /// Useful for analytics, debugging, or persistence.
  Map<String, dynamic> toJson() {
    return {
      'notification': notification.toJson(),
      'isBackground': isBackground,
      'useInApp': useInApp,
      'timezone': timezone,
      'type': type.getType(),
      'buttonColor': buttonColor?.toARGB32(),
      'backgroundColor': backgroundColor?.toARGB32(),
      'dangerButtonColor': dangerButtonColor?.toARGB32(),
      'sound': sound,
    };
  }
}