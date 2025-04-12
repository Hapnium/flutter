import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify/notify.dart';

import '../device_notification_manager_service.dart';
import 'device_notification.dart';

/// Manages device notifications, providing methods to dismiss notifications.
///
/// This class overrides the methods in `NotificationManager` to manage notifications
/// for specific channels such as `Call`, `Chat`, `Trip`, `Schedule`, `Transaction`, and `Other`.
class DeviceNotificationManager<T> implements DeviceNotificationManagerService<T> {
  DeviceNotificationManager();

  @override
  void dismissById(int id) async {
    await plugin.cancel(id);
  }

  @override
  void dismissAll() async {
    await plugin.cancelAll();
  }

  @override
  void dismissCallChannelNotifications() => _dismiss(NotifyChannel.CALL_ID);

  void _dismiss(String id) async {
    List<ActiveNotification> notifications = await plugin.getActiveNotifications();
    notifications = notifications.where((n) => n.channelId == id).toList();

    if(notifications.isNotEmpty) {
      notifications.forEach((n) async {
        if(n.id != null) {
          await plugin.cancel(n.id!);
        }
      });
    }
  }

  @override
  void dismissChatChannelNotifications() => _dismiss(NotifyChannel.CHAT_ID);

  @override
  void dismissTripChannelNotifications() => _dismiss(NotifyChannel.TRIP_ID);

  @override
  void dismissScheduleChannelNotifications() => _dismiss(NotifyChannel.SCHEDULE_ID);

  @override
  void dismissTransactionChannelNotifications() => _dismiss(NotifyChannel.TRANSACTION_ID);

  @override
  void dismissOtherChannelNotifications() => _dismiss(NotifyChannel.OTHER_ID);

  @override
  void dismissGroupedNotifications(String groupKey) async {
    List<ActiveNotification> notifications = await plugin.getActiveNotifications();
    notifications = notifications.where((n) => n.groupKey == groupKey).toList();

    if(notifications.isNotEmpty) {
      notifications.forEach((n) async {
        if(n.id != null) {
          await plugin.cancel(n.id!);
        }
      });
    }
  }
}