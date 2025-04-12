import 'package:notify/notify.dart';

import '../../services/notify_update_service.dart';

class NotifyUpdateImplementation<T> implements NotifyUpdateService<T> {
  @override
  void updateAppLaunchedByNotification(Notifier<T> notifier) {
    notifyController.launchedAppController.add(notifier);
  }

  @override
  void updateCreatedNotification(Notifier<T> notifier) {
    if(!notifyController.hasCreatedNotification(notifier)) {
      notifyController.addCreated(notifier);
      notifyController.createdController.add(notifier);
    }
  }

  @override
  void updateReceivedNotification(Notifier<T> notifier) {
    notifyController.receivedController.add(notifier);
  }

  @override
  void updateScheduledNotification(Notifier<T> notifier) {
    notifyController.scheduledController.add(notifier);
  }

  @override
  void updateTappedNotification(Notifier<T> notifier) {
    if (notifyController.tappedController.hasListener) {
      notifyController.tappedController.add(notifier);
    } else {
      notifyController.addTapped(notifier);
    }
  }

  @override
  void updateUseInAppNotification(Notifier<T> notifier) {
    notifyController.inAppReceivedController.add(notifier);
  }
}