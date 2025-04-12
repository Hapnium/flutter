import 'dart:async';

import 'package:notify/notify.dart';

/// A singleton controller for managing notification events in the application.
///
/// The `NotifyController` provides a centralized way to handle different types
/// of notification events through various stream controllers. These streams
/// allow for listening to events such as notifications received, created,
/// scheduled, tapped, and more.
///
/// This class is designed as a singleton, and only the global instance
/// `notifyController` is exposed for use. Users cannot create additional
/// instances of this class.
///
/// Example usage:
/// ```dart
/// notifyController.notificationReceivedController.stream.listen((notifier) {
///   // Handle the received notification.
/// });
/// ```
class NotifyController {
  /// Stream controller for notifications received.
  ///
  /// Emits events when a notification is received.
  final StreamController<Notifier> receivedController = StreamController.broadcast();

  /// Stream controller for notifications created.
  ///
  /// Emits events when a notification is created.
  final StreamController<Notifier> createdController = StreamController.broadcast();

  // Internal buffer to store created notifications when no listeners are active.
  final List<Notifier> _createdNotifications = [];

  /// List of created notifications
  List<Notifier> get createdNotifications => _createdNotifications;

  /// Check if the notification has already been created in order to avoid duplicates
  bool hasCreatedNotification(Notifier notifier) {
    return _createdNotifications.any((c) => c.foreign == notifier.foreign);
  }

  /// Add [Notifier] to created notification list
  void addCreated(Notifier notifier) {
    _createdNotifications.add(notifier);
  }

  /// Remove [Notifier] from created notification list
  void removeCreated({String? foreign, int? id}) {
    assert(foreign != null || id != null, "Either foreign or id must be provided");

    _createdNotifications.removeWhere((n) {
      return (foreign != null && n.foreign == foreign) || (id != null && n.id == id);
    });
  }

  // Expose and clear created notifications.
  void flushCreatedNotifications() {
    for (final notifier in _createdNotifications) {
      createdController.add(notifier);
    }

    _createdNotifications.clear();
  }

  /// Stream controller for notifications scheduled.
  ///
  /// Emits events when a notification is scheduled.
  final StreamController<Notifier> scheduledController = StreamController.broadcast();

  /// Stream controller for app launches triggered by notifications.
  ///
  /// Emits events when the app is launched by tapping a notification.
  final StreamController<Notifier> launchedAppController = StreamController.broadcast();

  /// Stream controller for tapped notifications.
  ///
  /// Emits events when a notification is tapped.
  final StreamController<Notifier> tappedController = StreamController.broadcast();

  // Internal buffer to store tapped notifications when no listeners are active.
  final List<Notifier> _tappedNotifications = [];

  /// List of tapped notifications
  List<Notifier> get tappedNotifications => _tappedNotifications;

  // Expose and clear pending notifications when listeners are registered.
  void flushPendingTappedNotifications() {
    for (final notifier in _tappedNotifications) {
      tappedController.add(notifier);
    }

    _tappedNotifications.clear();
  }

  /// Add [Notifier] to tapped notification list
  void addTapped(Notifier notifier) {
    _tappedNotifications.add(notifier);
  }

  /// Remove [Notifier] from tapped notification list
  void removeTapped({String? foreign, int? id}) {
    assert(foreign != null || id != null, "Either foreign or id must be provided");

    _tappedNotifications.removeWhere((n) {
      return (foreign != null && n.foreign == foreign) || (id != null && n.id == id);
    });
  }

  /// Stream controller for in-app notifications received.
  ///
  /// Emits events when an in-app notification is received.
  final StreamController<Notifier> inAppReceivedController = StreamController.broadcast();

  // Private constructor to restrict instantiation.
  NotifyController._internal();

  /// The singleton instance of the class.
  static final NotifyController _instance = NotifyController._internal();

  /// Allows internal access for adding tapped notifications.
  static NotifyController get instance => _instance;
}

/// The singleton instance of [NotifyController] exposed for global use.
final NotifyController notifyController = NotifyController._instance;