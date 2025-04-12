import 'package:notify/notify.dart';

import '../utilities/definitions.dart';

abstract class DeviceNotificationService<T> {
  /// Requests permission for notifications.
  ///
  /// This method should be implemented to request necessary permissions for
  /// displaying notifications. Depending on the platform, it may involve requesting
  /// permission to send alerts, badges, or sounds.
  ///
  /// Throws a [NotifyException] since the method is not yet implemented.
  ///
  /// @return A [Future] that resolves to a [bool] indicating if the permission was granted.
  Future<bool> requestPermission();

  /// Checks if notifications are permitted for the device.
  ///
  /// Returns a [Future] that resolves to `true` if notification permissions are granted,
  /// and `false` otherwise.
  ///
  /// @return A [Future] indicating whether notifications are permitted.
  Future<bool> get isPermitted;

  /// Initializes the notification service for the given [info].
  ///
  /// This method sets up the notification service, including info-specific
  /// configurations such as notification channels or permissions.
  ///
  /// @param info The [NotifyAppInformation] for which the notification service is being initialized.
  /// @param showInitializationLogs Whether to show initialization logs
  /// @param handler To handle any notification tap
  /// @param backgroundHandler To handle any background notification tap
  void init(NotifyAppInformation info, bool showInitializationLogs, NotificationTapHandler? handler, NotificationResponseHandler? backgroundHandler);

  /// Registers a callback to handle events when the app is launched via a notification.
  ///
  /// The [onReceived] function is invoked with a [Notifier] containing details about
  /// the notification that launched the app.
  ///
  /// @param onReceived A callback function to handle the notification data.
  void onAppLaunchedByNotification(NotificationTapHandler<T> onReceived);
}