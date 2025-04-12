abstract class DeviceNotificationManagerService<T> {
  /// Dismisses a notification by its unique identifier.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  ///
  /// @param id The unique identifier of the notification to dismiss.
  void dismissById(int id);

  /// Dismisses all notifications.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissAll();

  /// Dismisses all notifications from the `Call` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissCallChannelNotifications();

  /// Dismisses all notifications from the `Chat` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissChatChannelNotifications();

  /// Dismisses all notifications from the `Trip` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissTripChannelNotifications();

  /// Dismisses all notifications from the `Schedule` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissScheduleChannelNotifications();

  /// Dismisses all notifications from the `Transaction` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissTransactionChannelNotifications();

  /// Dismisses all notifications from the `Other` channel.
  ///
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissOtherChannelNotifications();

  /// Dismisses all notifications from the group key (Android only).
  ///
  /// @param groupKey The group identifier key for the notification
  /// Throws a `NotifyException` if the method is not implemented.
  void dismissGroupedNotifications(String groupKey);
}