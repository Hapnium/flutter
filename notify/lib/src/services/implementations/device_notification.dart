import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tracing/tracing.dart';
import 'package:notify/notify.dart';
import 'package:notify/src/services/device_notification_service.dart';
import 'package:notify/src/services/notify_update_service.dart';

import '../../utilities/definitions.dart';
import '../../utilities/platform_engine.dart';
import 'notify_update_implementation.dart';

final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

class DeviceNotification<T> implements DeviceNotificationService<T> {
  DeviceNotification();

  final NotifyUpdateService _updateService = NotifyUpdateImplementation();
  final String prefix = "Notify Device Core";

  @override
  Future<bool> requestPermission() async {
    if (PlatformEngine.instance.isIOS) {
      return await plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    } else if (PlatformEngine.instance.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? response = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? grantedNotificationPermission = await response?.requestNotificationsPermission();

      return grantedNotificationPermission ?? false;
    }

    return false;
  }

  AndroidInitializationSettings _androidSettings(NotifyAppInformation info) => AndroidInitializationSettings(info.androidIcon);

  // List<DarwinNotificationCategory> _darwinNotificationCategories() => <DarwinNotificationCategory>[
  //   DarwinNotificationCategory(
  //     darwinNotificationCategoryText,
  //     actions: <DarwinNotificationAction>[
  //       DarwinNotificationAction.text(
  //         'text_1',
  //         'Action 1',
  //         buttonTitle: 'Send',
  //         placeholder: 'Placeholder',
  //       ),
  //     ],
  //   ),
  //   DarwinNotificationCategory(
  //     darwinNotificationCategoryPlain,
  //     actions: <DarwinNotificationAction>[
  //       DarwinNotificationAction.plain('id_1', 'Action 1'),
  //       DarwinNotificationAction.plain(
  //         'id_2',
  //         'Action 2 (destructive)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.destructive,
  //         },
  //       ),
  //       DarwinNotificationAction.plain(
  //         navigationActionId,
  //         'Action 3 (foreground)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.foreground,
  //         },
  //       ),
  //       DarwinNotificationAction.plain(
  //         'id_4',
  //         'Action 4 (auth required)',
  //         options: <DarwinNotificationActionOption>{
  //           DarwinNotificationActionOption.authenticationRequired,
  //         },
  //       ),
  //     ],
  //     options: <DarwinNotificationCategoryOption>{
  //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
  //     },
  //   )
  // ];
  //
  // DarwinInitializationSettings _darwinSettings(AppPlatform info) => DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  //   notificationCategories: _darwinNotificationCategories(),
  // );
  //
  // LinuxInitializationSettings _linuxSettings(AppPlatform info) => LinuxInitializationSettings(
  //   defaultActionName: 'Open notification',
  //   defaultIcon: AssetsLinuxIcon(_icon(info)),
  // );

  InitializationSettings _initializationSettings(NotifyAppInformation info) => InitializationSettings(
    android: _androidSettings(info),
    // iOS: _darwinSettings(info),
    // macOS: _darwinSettings(info),
    // linux: _linuxSettings(info),
  );

  @override
  void init(NotifyAppInformation info, bool showInitializationLogs, NotificationTapHandler? handler, NotificationResponseHandler? backgroundHandler) async {
    if(showInitializationLogs) {
      console.debug("Initializing remote notification for ${info.app.name}", prefix: prefix);
    }

    await plugin.initialize(
      _initializationSettings(info),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if(showInitializationLogs) {
          console.info("Remote notification for ${info.app.name}", prefix: prefix);
        }

        Notifier notifier;

        if(response.payload != null) {
          notifier = Notifier.fromString(response.payload!);
        } else {
          notifier = Notifier.empty();
        }
        notifier = notifier.copyWith(action: response.actionId, input: response.input, id: response.id);

        if(showInitializationLogs) {
          console.info("Remote notification for ${info.app.name} details: ${notifier.toJson()}", prefix: prefix);
        }

        process(handler, onProcess: (value) => value(notifier));

        _updateService.updateTappedNotification(notifier);
      },
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    ).then((v) {
      if(v ?? false) {
        if(showInitializationLogs) {
          console.info("Initialized remote notification for ${info.app.name}", prefix: prefix);
        }
      } else {
        if(showInitializationLogs) {
          console.error("Couldn't initialize remote notification for ${info.app.name}", prefix: prefix);
        }
      }
    });
  }

  @override
  Future<bool> get isPermitted async {
    if (PlatformEngine.instance.isAndroid) {
      return await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;
    } else if (PlatformEngine.instance.isIOS) {
      NotificationsEnabledOptions? response = await plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.checkPermissions();

      if(response != null) {
        return response.isEnabled;
      }

      return false;
    }

    return false;
  }

  @override
  void onAppLaunchedByNotification(NotificationTapHandler<T> onReceived) async {
    final NotificationAppLaunchDetails? details = !PlatformEngine.instance.isWeb
        ? null
        : await plugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      NotificationResponse? response = details.notificationResponse;

      if(response != null) {
        Notifier notifier;

        if(response.payload != null) {
          notifier = Notifier.fromString(response.payload!);
        } else {
          notifier = Notifier.empty();
        }
        notifier = notifier.copyWith(action: response.actionId, input: response.input, id: response.id);

        _updateService.updateAppLaunchedByNotification(notifier);
      }
    }
  }
}