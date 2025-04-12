import '../../notify.dart';

/// An abstract class defining a service for updating notification-related streams.
///
/// The `NotifyUpdateService` provides an interface for updating various streams
/// that notify listeners about notification-related events. This interface
/// serves as a foundation for implementing services that handle notification
/// events such as created, received, scheduled, tapped, and in-app notifications.
///
/// ### Example Usage
/// ```dart
/// class MyNotificationService extends NotifyUpdateService {
///   @override
///   void updateCreatedNotification(Notifier<T> notifier) {
///     // Handle logic for created notifications.
///   }
///
///   @override
///   void updateReceivedNotification(Notifier<T> notifier) {
///     // Handle logic for received notifications.
///   }
///
///   // Implement other methods as needed.
/// }
/// ```
abstract class NotifyUpdateService<T> {
  /// Updates the stream with a created notification.
  ///
  /// This method should be called when a new notification is created.
  ///
  /// For example, a notification is considered "created" when:
  /// - A notification is configured and displayed to the user.
  /// - The notification details (e.g., title, body, payload) are defined and set.
  ///
  /// Implementations of this method should add the `notifier` object to the
  /// appropriate stream, making the created notification data available to
  /// listeners.
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the created notification.
  void updateCreatedNotification(Notifier<T> notifier);

  /// Updates the stream with a received notification.
  ///
  /// This method should be called when the application receives a new
  /// notification. Notifications can be received while the app is in the
  /// foreground, background, or terminated state.
  ///
  /// Use this method to handle notifications received via remote push
  /// notification services (e.g., Firebase Cloud Messaging) or local
  /// notifications triggered by the app.
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the received notification.
  void updateReceivedNotification(Notifier<T> notifier);

  /// Updates the stream with a scheduled notification.
  ///
  /// This method should be called when a notification is successfully
  /// scheduled to trigger at a future time.
  ///
  /// For example, use this method to notify listeners when:
  /// - A notification is scheduled to remind the user of a task.
  /// - Notifications are configured to recur periodically (e.g., daily, weekly).
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the scheduled notification.
  void updateScheduledNotification(Notifier<T> notifier);

  /// Updates the stream with an app launch triggered by a notification.
  ///
  /// This method should be called when a user taps a notification and the app
  /// is launched as a result. Use this method to notify listeners that the app
  /// has been opened via a notification.
  ///
  /// This is particularly useful for:
  /// - Navigating the user to a specific screen or feature.
  /// - Handling any payload or action associated with the notification tap.
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the notification that triggered the app launch.
  void updateAppLaunchedByNotification(Notifier<T> notifier);

  /// Updates the stream with a tapped notification.
  ///
  /// This method should be called when a user taps on a notification while the
  /// app is already running (foreground or background). It allows the app to
  /// respond to user interactions with notifications, such as:
  /// - Opening a specific section of the app.
  /// - Processing user input provided via the notification action.
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the tapped notification.
  void updateTappedNotification(Notifier<T> notifier);

  /// Updates the stream with an in-app notification received.
  ///
  /// This method should be called when an in-app notification is displayed and
  /// received by the user. In-app notifications are typically lightweight
  /// notifications shown within the app, such as banners or popups, without
  /// involving the system's notification tray.
  ///
  /// Use this method to:
  /// - Notify listeners about the in-app notification event.
  /// - Handle custom logic or analytics related to in-app notifications.
  ///
  /// #### Parameters:
  /// - [notifier]: The `Notifier<T>` object containing details about the in-app notification.
  void updateUseInAppNotification(Notifier<T> notifier);
}