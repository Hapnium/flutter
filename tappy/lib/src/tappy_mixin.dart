import 'dart:async';

import 'package:tappy/src/models/notifier.dart';

import 'tappy.dart';
import 'tappy_controller.dart';

/// {@template tappy_mixin}
/// A mixin that provides convenient access to notification events and helpers from [TappyController].
///
/// This is useful in BLoCs, services, or UI components that want to listen to
/// notification-related streams or interact with the notification lifecycle
/// (e.g., remove tapped/created notifications, flush buffers, etc.).
///
/// To use this mixin, simply include it in any class:
/// ```dart
/// class MyBloc with TappyMixin {
///   void listenToNotifications() {
///     tappedStream.listen((notifier) {
///       // Handle tapped notification
///     });
///   }
/// }
/// ```
/// {@endtemplate}
mixin TappyMixin {
  /// Access the singleton [TappyController] instance.
  TappyController get controller => Tappy.controller;

  /// Stream of notifications when they are created.
  ///
  /// Emitted when a notification is constructed and delivered.
  Stream<Notifier> get createdStream => controller.createdController.stream;

  /// Stream of notifications that were tapped by the user.
  ///
  /// Emitted when a user taps a delivered notification.
  Stream<Notifier> get tappedStream => controller.tappedController.stream;

  /// Stream of notifications received by the device.
  ///
  /// Emitted when the system delivers a notification (may not yet be shown).
  Stream<Notifier> get receivedStream => controller.receivedController.stream;

  /// Stream of scheduled notifications.
  ///
  /// Emitted when a notification is scheduled for future delivery.
  Stream<Notifier> get scheduledStream => controller.scheduledController.stream;

  /// Stream of in-app notifications received while the app is in foreground.
  Stream<Notifier> get inAppStream => controller.inAppReceivedController.stream;

  /// Stream of notifications that caused the app to launch.
  Stream<Notifier> get launchedAppStream => controller.launchedAppController.stream;

  /// List of all tapped notifications held in memory.
  ///
  /// Useful for retrieving previously tapped notifications.
  List<Notifier> get tappedNotifications => controller.tappedNotifications;

  /// List of all created notifications held in memory.
  ///
  /// These are not flushed until explicitly cleared.
  List<Notifier> get createdNotifications => controller.createdNotifications;

  /// Remove a created notification from memory.
  ///
  /// You can provide either [foreign] (external ID) or [id] (internal ID).
  void removeCreated({String? foreign, int? id}) => controller.removeCreated(foreign: foreign, id: id);

  /// Remove a tapped notification from memory.
  ///
  /// You can provide either [foreign] (external ID) or [id] (internal ID).
  void removeTapped({String? foreign, int? id}) => controller.removeTapped(foreign: foreign, id: id);

  /// Clear all buffered created notifications from memory.
  void flushCreatedNotifications() => controller.flushCreatedNotifications();

  /// Clear all buffered tapped notifications from memory.
  void flushTappedNotifications() => controller.flushPendingTappedNotifications();
}