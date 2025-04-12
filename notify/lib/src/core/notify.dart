import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify/notify.dart';

import '../services/device_notification_builder_service.dart';
import '../services/device_notification_manager_service.dart';
import '../services/device_notification_service.dart';
import '../services/implementations/notify_update_implementation.dart';
import '../services/in_app_notification_service.dart';
import '../services/implementations/device_notification.dart';
import '../services/implementations/device_notification_builder.dart';
import '../services/implementations/device_notification_manager.dart';
import '../services/implementations/in_app_notification.dart';
import '../services/notify_update_service.dart';
import '../utilities/definitions.dart';

/// A class that provides access to various notification services.
///
/// The `Notify` class serves as an entry point to manage different types of
/// notifications, offering a unified interface for:
///
/// - **In-App Notifications**: Notifications displayed within the app interface.
/// - **Remote Notifications**: Notifications received from external servers or services.
/// - **Device-Level Notifications**: Notifications managed at the device level.
/// - **Action-Based Notifications**: Fine-grained control over managing and dismissing notifications.
class Notify<T> {
  Notify._internal();
  static Notify _instance = Notify._internal();
  static Notify get instance => _instance;

  /// Initializes the notification service for **in-app notifications**.
  ///
  /// This constructor provides access to the in-app notification functionality,
  /// such as showing notifications directly within the app's UI.
  InAppNotificationService<T> inApp() {
    return InAppNotification<T>();
  }

  /// Initializes the notification service for **remote notifications**.
  ///
  /// This constructor provides access to the remote notification functionality,
  /// enabling the handling of notifications received from external sources such
  /// as servers.
  DeviceNotificationBuilderService<T> builder() {
    return DeviceNotificationBuilder<T>();
  }

  /// Initializes the notification service for **device-level notifications**.
  ///
  /// This constructor provides access to functionalities specific to the device,
  /// such as global notification management and device-level permissions.
  DeviceNotificationService<T> remote() {
    return DeviceNotification<T>();
  }

  /// Initializes the notification service for **action-based notifications**.
  ///
  /// This constructor allows fine-grained control over notification actions,
  /// such as creating, dismissing, or managing notifications based on specific
  /// channels or identifiers.
  DeviceNotificationManagerService<T> manager() {
    return DeviceNotificationManager<T>();
  }

  void handleNotificationResponse(NotificationResponse response, {NotificationTapHandler? handler}) {
    final NotifyUpdateService _updateService = NotifyUpdateImplementation();

    Notifier notifier = NotifyTypeBuilder.instance.parse(response);
    process(handler, onProcess: (value) => value(notifier));

    _updateService.updateTappedNotification(notifier);
  }
}