import '../models/notifier.dart';
import '../tappy_lifecycle.dart';

/// {@template tappy_controller}
/// A singleton controller for managing notification events in the application.
///
/// The `DefaultTappyLifecycle` provides a centralized way to handle different types
/// of notification events through various stream controllers. These streams
/// allow for listening to events such as notifications received, created,
/// scheduled, tapped, and more.
///
/// This class is designed as a singleton, and only the global instance
/// `tappyController` is exposed for use. Users cannot create additional
/// instances of this class.
///
/// Example usage:
/// ```dart
/// notificationReceivedController.stream.listen((notifier) {
///   // Handle the received notification.
/// });
/// ```
/// 
/// {@endtemplate}
final class DefaultTappyLifecycle<T> extends TappyLifecycle<T> {
  @override
  void onAppLaunched(Notifier<T> notifier) {
    super.onAppLaunched(notifier);
  }

  @override
  void onCreated(Notifier<T> notifier) {
    super.onCreated(notifier);
  }

  @override
  void onReceived(Notifier<T> notifier) {
    super.onReceived(notifier);
  }

  @override
  void onScheduled(Notifier<T> notifier) {
    super.onScheduled(notifier);
  }

  @override
  void onTapped(Notifier<T> notifier) {
    super.onTapped(notifier);
  }

  @override
  void onUseInApp(Notifier<T> notifier) {
    super.onUseInApp(notifier);
  }
}