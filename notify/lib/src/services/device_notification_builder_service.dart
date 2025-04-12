import 'package:notify/notify.dart';

/// Abstract class to define the base structure for a notification service that handles
/// displaying different types of notifications.
abstract class DeviceNotificationBuilderService<T> {
  /// Builds a generic notification.
  ///
  /// This method constructs the notification based on the server's payload and provides
  /// options for navigating to a specific screen or displaying the notification in-app.
  ///
  /// - [config]: The notification config payload from the server.
  void build(RemoteNotificationConfig<T> config);

  /// Handle firebase background messaging notification.
  ///
  /// This method constructs the notification based on the server's payload and provides
  /// options for navigating to a specific screen or displaying the notification in-app.
  ///
  /// - [config]: The notification config payload from the server.
  @deprecated
  void handleFirebase(RemoteNotificationConfig<T> config);
}