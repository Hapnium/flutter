import 'dart:ui' show Color;

import 'package:notify/notify.dart';

import '../../utilities/definitions.dart';
import '../base/remote_notification.dart';

/// Configuration for a remote notification.
///
/// This class encapsulates notification data and provides flags for identifying
/// the type of notification. It also ensures that non-standard notifications
/// (i.e., those not matching specific types like chat, call, etc.) will have
/// their title and body copied to the notification object.
class RemoteNotificationConfig<T> {
  final RemoteNotification<T> notification;
  final bool isBackground;
  final bool useInApp;
  final String timezone;
  final bool isChat;
  final bool isCall;
  final bool isTransaction;
  final bool isTrip;
  final bool isSchedule;
  final bool isGoActivity;
  final bool isGoBCap;
  final bool isGoTrend;
  final NotifyApp app;
  final NotifyPlatform platform;
  final bool showLogs;
  final Color? buttonColor;
  final Color? backgroundColor;
  final Color? dangerButtonColor;
  final String? sound;
  final MessageDecryptionCallback? onMessageDecrypted;

  // Private constructor to restrict instantiation.
  RemoteNotificationConfig._({
    required this.notification,
    required this.isBackground,
    required this.useInApp,
    required this.timezone,
    required this.isChat,
    required this.isCall,
    required this.isTransaction,
    required this.isTrip,
    required this.isSchedule,
    required this.app,
    required this.showLogs,
    required this.platform,
    required this.onMessageDecrypted,
    required this.isGoActivity,
    required this.isGoBCap,
    required this.buttonColor,
    required this.backgroundColor,
    required this.dangerButtonColor,
    required this.sound,
    required this.isGoTrend,
  });

    /// Factory constructor to create a [RemoteNotificationConfig] from data.
    ///
    /// Ensures users can only create an instance using this method.
    ///
    /// Parameters:
    /// - [data]: A map containing the raw notification data.
    /// - [isBackground]: Indicates if the notification is being processed in the background. Defaults to `false`.
    /// - [useInApp]: Specifies whether the notification should trigger in-app actions or UI changes. Defaults to `false`.
    /// - [timezone]: The timezone in which the notification is relevant. Defaults to an empty string.
    /// - [title]: The fallback title for the notification, used when the notification type is unrecognized. Defaults to an empty string.
    /// - [body]: The fallback body for the notification, used when the notification type is unrecognized. Defaults to an empty string.
    /// - [app]: The application platform (e.g., user, provider, business, nearby) that this configuration is associated with.
    /// - [showLogs]: Determines whether logs should be displayed for debugging purposes. Defaults to `false`.
    /// - [platform]: Specifies the device platform (e.g., Android, iOS) that this configuration targets.
    /// - [onMessageDecrypted]: A message decrypting method for notification messages, mostly used in chat notifications.
    factory RemoteNotificationConfig.fromData({
      required Data data,
      bool isBackground = false,
      bool useInApp = false,
      String timezone = "",
      String title = "",
      String body = "",
      required NotifyApp app,
      bool showLogs = false,
      required NotifyPlatform platform,
      Color? buttonColor,
      Color? backgroundColor,
      Color? dangerButtonColor,
      String? sound,
      MessageDecryptionCallback? onMessageDecrypted
    }) {
      bool isChat = NotifyTypeChecker.instance.isChat(data);
      bool isCall = NotifyTypeChecker.instance.isCall(data);
      bool isTransaction = NotifyTypeChecker.instance.isTransaction(data);
      bool isTrip = NotifyTypeChecker.instance.isTrip(data);
      bool isSchedule = NotifyTypeChecker.instance.isSchedule(data);
      bool isGoActivity = NotifyTypeChecker.instance.isGoActivity(data);
      bool isGoBCap = NotifyTypeChecker.instance.isGoBCap(data);
      bool isGoTrend = NotifyTypeChecker.instance.isGoTrend(data);

      // Parse the notification data.
      RemoteNotification<T> notification = RemoteNotification.fromJson(data);

      // If it's not a known notification type, copy the title and body.
      if (!isChat && !isCall && !isTransaction && !isTrip && !isSchedule && !isGoActivity && !isGoBCap && !isGoTrend) {
        notification = notification.copyWith(title: title, body: body);
      }

      return RemoteNotificationConfig._(
        notification: notification,
        isBackground: isBackground,
        useInApp: useInApp,
        timezone: timezone,
        isChat: isChat,
        isCall: isCall,
        isTransaction: isTransaction,
        isTrip: isTrip,
        isSchedule: isSchedule,
        isGoActivity: isGoActivity,
        isGoBCap: isGoBCap,
        isGoTrend: isGoTrend,
        app: app,
        showLogs: showLogs,
        platform: platform,
        buttonColor: buttonColor,
        backgroundColor: backgroundColor,
        dangerButtonColor: dangerButtonColor,
        sound: sound,
        onMessageDecrypted: onMessageDecrypted
      );
    }

  /// Converts the RemoteNotificationConfig object to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'notification': notification.toJson(),
      'isBackground': isBackground,
      'useInApp': useInApp,
      'timezone': timezone,
      'isChat': isChat,
      'isCall': isCall,
      'isTransaction': isTransaction,
      'isTrip': isTrip,
      'isSchedule': isSchedule,
      'isGoActivity': isGoActivity,
      'isGoBCap': isGoBCap,
      'isGoTrend': isGoTrend,
      'app': app.toString(),
      'platform': platform.toString(),
      'showLogs': showLogs,
      'buttonColor': buttonColor?.toARGB32(),
      'backgroundColor': backgroundColor?.toARGB32(),
      'dangerButtonColor': dangerButtonColor?.toARGB32(),
      'sound': sound,
    };
  }
}