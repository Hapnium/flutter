import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tracing/tracing.dart';
import 'package:notify/notify.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../enums/notify_type.dart';
import '../../models/base/remote_notification.dart';
import '../../utilities/definitions.dart';
import '../../utilities/notify_sound.dart';
import '../../utilities/platform_engine.dart';
import '../device_notification_builder_service.dart';
import '../notify_update_service.dart';
import 'device_notification.dart';
import 'notify_update_implementation.dart';

class DeviceNotificationBuilder<T> implements DeviceNotificationBuilderService<T> {
  DeviceNotificationBuilder();

  final NotifyUpdateService _updateService = NotifyUpdateImplementation();

  final String prefix = "[Notify Device Builder]";

  RemoteNotificationConfig<T>? _config;
  int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

  Int64List lowVibrationPattern = Int64List.fromList([0, 200, 200, 200]);
  Int64List mediumVibrationPattern = Int64List.fromList([0, 500, 200, 200, 200, 200]);
  Int64List highVibrationPattern = Int64List.fromList([0, 1000, 200, 200, 200, 200, 200, 200]);

  @protected
  Color get _COMMON_BUTTON_COLOR => _config?.buttonColor ?? Colors.blueGrey;

  @protected
  Color get _COMMON_DANGER_BUTTON_COLOR => _config?.dangerButtonColor ?? Colors.red;

  @protected
  Color get _NOTIFICATION_COLOR => _config?.backgroundColor ?? Color(0xfff1f1f1);

  @protected
  bool get _isColored => _config != null && _config!.backgroundColor != null;

  @protected
  String _sound(String fallback) => _config?.sound ?? fallback;

  @protected
  RawResourceAndroidNotificationSound androidSound(String fallback) => RawResourceAndroidNotificationSound(_sound(fallback));

  Future<void> _configureLocalTimeZone(String timezone) async {
    if (PlatformEngine.instance.isWeb) {
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timezone.isNotEmpty ? timezone : "Africa/Lagos"));
  }

  @override
  void build(RemoteNotificationConfig<T> config) {
    PlatformEngine.instance.init(config.platform);
    _config = config;
    
    if(config.isCall) {
      return _buildCall(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isChat) {
      return _buildChat(config.notification, config.isBackground, config.useInApp, config.showLogs, config.onMessageDecrypted);
    } else if(config.isSchedule) {
      _configureLocalTimeZone(config.timezone);

      return _buildSchedule(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isTransaction) {
      return _buildTransaction(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isTrip) {
      return _buildTrip(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isGoBCap) {
      return _buildGoBCap(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isGoActivity) {
      return _buildGoActivity(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else if(config.isGoTrend) {
      return _buildGoTrend(config.notification, config.isBackground, config.useInApp, config.showLogs);
    } else {
      return _buildOthers(config.notification, config.isBackground, config.useInApp, config.showLogs);
    }
  }

  void _buildChat(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs, MessageDecryptionCallback? decryptor) async {
    if(showLogs) {
      console.debug("Building chat notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    ChatResponse message = NotifyTypeBuilder.instance.chat(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.chat,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.foreign, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.CHAT_ID,
        'Chat Notification',
        channelDescription: 'Notification for chat messaging',
        channelShowBadge: true,
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        vibrationPattern: lowVibrationPattern,
        sound: androidSound(NotifySound.message),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'chat_ticker',
        showWhen: true,
        subText: message.summary,
        category: AndroidNotificationCategory.message,
        groupKey: message.room,
        color: _NOTIFICATION_COLOR,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            NotifyEventKey.REPLY_MESSAGE,
            'Reply',
            titleColor: _COMMON_BUTTON_COLOR,
            inputs: [
              AndroidNotificationActionInput(label: "Reply message")
            ],
            cancelNotification: false
          ),
          AndroidNotificationAction(
            NotifyEventKey.VIEW_CHAT,
            "Open",
            titleColor: _COMMON_BUTTON_COLOR,
            cancelNotification: false
          ),
          AndroidNotificationAction(
            NotifyEventKey.MARK_MESSAGE_AS_READ,
            "Mark read",
            titleColor: _COMMON_BUTTON_COLOR,
            cancelNotification: false
          ),
        ],
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.CHAT_ID,
        // sound: 'message.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      String body = process(
        decryptor,
        onProcess: (value) => value(notification.body),
      ) ?? "";
      body = body.isEmpty ? "Chat message from ${message.name}" : body;

      if(showLogs) {
        console.info("Notification body info: Encrypted = ${notification.body} | Decrypted = ${body}", prefix: prefix);
      }

      await plugin.show(id, notification.title, body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildCall(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building call notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    CallNotification message = NotifyTypeBuilder.instance.call(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.call,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify("${message.channel}:::${message.type}", orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.info("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.CALL_ID,
        'Call Notification',
        channelDescription: 'Notification for incoming calls (Video, Audio and T2F)',
        channelShowBadge: message.isMissed ? true : false,
        playSound: message.isMissed ? false : true,
        groupAlertBehavior: GroupAlertBehavior.children,
        sound: androidSound(NotifySound.incoming),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'call_ticker',
        showWhen: true,
        fullScreenIntent: true,
        timeoutAfter: 3000,
        vibrationPattern: highVibrationPattern,
        ongoing: message.isRinging,
        category: message.isMissed ? AndroidNotificationCategory.missedCall : AndroidNotificationCategory.call,
        groupKey: message.isMissed ? 'missed_calls' : message.channel,
        color: _NOTIFICATION_COLOR,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            NotifyEventKey.VIEW_CALL,
            'Open',
            titleColor: _COMMON_BUTTON_COLOR,
            cancelNotification: false
          ),
        ],
        // actions: <AndroidNotificationAction>[
        //   AndroidNotificationAction(
        //     NotifyEventKey.ANSWER_INCOMING_CALL,
        //     'Answer',
        //     titleColor: Colors.greenAccent,
        //   ),
        //   AndroidNotificationAction(
        //     NotifyEventKey.DECLINE_INCOMING_CALL,
        //     "Decline",
        //     titleColor: _COMMON_DANGER_BUTTON_COLOR,
        //   ),
        // ],
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.CALL_ID,
        // sound: 'incoming.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildTransaction(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building transaction notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    TransactionResponse message = NotifyTypeBuilder.instance.transaction(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.transaction,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.foreign, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.TRANSACTION_ID,
        'Transaction Notification',
        channelDescription: 'Notification for platform transactions',
        playSound: true,
        vibrationPattern: mediumVibrationPattern,
        sound: androidSound(NotifySound.notify),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'transaction_ticker',
        showWhen: true,
        groupKey: 'payment_transactions',
        color: _NOTIFICATION_COLOR,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            NotifyEventKey.VIEW_TRANSACTION,
            'View details',
            titleColor: _COMMON_BUTTON_COLOR,
            cancelNotification: false
          ),
        ],
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.TRANSACTION_ID,
        // sound: 'notify.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildSchedule(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building schedule notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    ScheduleNotification message = NotifyTypeBuilder.instance.schedule(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.schedule,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.id, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.SCHEDULE_ID,
        'Schedule Notification',
        channelDescription: 'Notification for trip schedules',
        playSound: true,
        vibrationPattern: highVibrationPattern,
        sound: androidSound(NotifySound.schedule),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'schedule_ticker',
        showWhen: true,
        groupKey: 'schedules',
        color: _NOTIFICATION_COLOR,
        actions: <AndroidNotificationAction>[
          if(message.isPending) ...[
            AndroidNotificationAction(
              NotifyEventKey.ACCEPT_SCHEDULE,
              'Accept',
              titleColor: _COMMON_BUTTON_COLOR,
              cancelNotification: false
            ),
            AndroidNotificationAction(
              NotifyEventKey.DECLINE_SCHEDULE,
              'Decline',
              titleColor: _COMMON_DANGER_BUTTON_COLOR,
              cancelNotification: false,
              inputs: [
                AndroidNotificationActionInput(label: "Let us know the reason for cancellation")
              ]
            ),
          ],
          AndroidNotificationAction(
            NotifyEventKey.VIEW_SCHEDULE,
            'View details',
            titleColor: _COMMON_BUTTON_COLOR,
          ),
        ],
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.SCHEDULE_ID,
        // sound: 'schedule.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }

    _buildScheduledNotification(id, notification, message, notifier, showLogs);
  }

  /// Combines the current date with a given time string.
  ///
  /// The time string must be in the format "Minute:Seconds AM/PM",
  /// such as "9:00 AM" or "9:00PM".
  ///
  /// Returns a [DateTime] object representing the combined date and time.
  ///
  /// Example:
  /// ```dart
  /// DateTime result = parseTimeToDate("9:00 AM");
  /// print(result); // Prints: 2025-01-07 09:00:00.000
  /// ```
  String _parseTimeToDate(String time) {
    // Get the current date
    DateTime now = DateTime.now();

    // Normalize the time string (remove extra spaces and ensure uppercase AM/PM)
    time = time.trim().toUpperCase();

    // Extract hours, minutes, and period (AM/PM)
    final timeRegex = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
    final match = timeRegex.firstMatch(time);

    if (match == null) {
      throw FormatException("Invalid time format. Expected format is 'H:MM AM/PM'.");
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String period = match.group(3)!;

    // Convert hour to 24-hour format if necessary
    if (period == "PM" && hour != 12) {
      hour += 12;
    } else if (period == "AM" && hour == 12) {
      hour = 0;
    }

    // Combine the parsed time with the current date
    return DateTime(now.year, now.month, now.day, hour, minute).toIso8601String();
  }

  void _buildScheduledNotification(int id, RemoteNotification notification, ScheduleNotification message, Notifier notifier, bool showLogs) async {
    if(showLogs) {
      console.debug("Building scheduled notification", prefix: prefix);
    }

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      NotifyChannel.SCHEDULED_ID,
      'Scheduled Notification',
      channelDescription: 'Notification for scheduled trips',
      ledColor: Color(0xff050404),
      playSound: true,
      vibrationPattern: highVibrationPattern,
      sound: androidSound(NotifySound.schedule),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'schedule_ticker',
      showWhen: true,
      groupKey: 'scheduled_trips',
      color: _NOTIFICATION_COLOR,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          NotifyEventKey.START_SCHEDULED_TRIP,
          'Start scheduled trip',
          titleColor: _COMMON_BUTTON_COLOR,
          cancelNotification: false
        ),
      ],
    );

    DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      categoryIdentifier: NotifyChannel.SCHEDULED_ID,
      sound: 'schedule.aiff',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await plugin.zonedSchedule(
      id,
      notification.title,
      notification.body,
      tz.TZDateTime.parse(tz.local, _parseTimeToDate(message.time)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: notifier.toString()
    );

    _updateService.updateScheduledNotification(notifier);
  }

  void _buildTrip(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building trip notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    TripNotification message = NotifyTypeBuilder.instance.trip(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.trip,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.trip, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.TRIP_ID,
        'Trip Notification',
        channelDescription: 'Notification for service trips',
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        vibrationPattern: mediumVibrationPattern,
        sound: androidSound(NotifySound.connect),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'trip_ticker',
        showWhen: true,
        groupKey: message.trip,
        color: _NOTIFICATION_COLOR,
        ongoing: message.isWaiting || message.isActive,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            NotifyEventKey.VIEW_TRIP_DETAILS,
            'View details',
            titleColor: _COMMON_BUTTON_COLOR,
            cancelNotification: false
          ),
        ],
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.TRIP_ID,
        // sound: 'connect.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildGoBCap(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building go-bcap notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    GoBCapNotification message = NotifyTypeBuilder.instance.goBCap(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.goBCap,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.title, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.GO_BCAP_ID,
        'Go BCap Notification',
        channelDescription: 'Notification for go bcap notifications, showing updates about an event.',
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        vibrationPattern: mediumVibrationPattern,
        sound: androidSound(NotifySound.notify),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'go-bcap_ticker',
        showWhen: true,
        groupKey: "${message.interest}",
        color: _NOTIFICATION_COLOR,
        colorized: _isColored,
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.GO_BCAP_ID,
        // sound: 'connect.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildGoActivity(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building go-activity notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    GoActivityNotification message = NotifyTypeBuilder.instance.goActivity(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.goActivity,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.title, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.GO_ACTIVITY_ID,
        'Go Activity Notification',
        channelDescription: 'Notification for go activity notifications, showing updates about an activity.',
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        vibrationPattern: mediumVibrationPattern,
        sound: androidSound(NotifySound.notify),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'go-activity_ticker',
        subText: message.summary,
        showWhen: true,
        groupKey: "${message.interest}",
        color: _NOTIFICATION_COLOR,
        colorized: _isColored,
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.GO_ACTIVITY_ID,
        // sound: 'connect.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildGoTrend(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building go-trend notification", prefix: prefix);
    }

    if(notification.data == null) {
      if(showLogs) {
        console.warn("Couldn't complete notification building due to null data", prefix: prefix);
      }

      return;
    }

    int id = createUniqueId();
    GoTrendNotification message = NotifyTypeBuilder.instance.goTrend(notification.data);
    Notifier notifier = Notifier(
      type: NotifyType.goTrend,
      id: id,
      data: message.toJson(),
      from: notification.token,
      foreign: qualify(message.title, orElse: notification.title)
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.GO_TREND_ID,
        'Go Trend Notification',
        channelDescription: 'Notification for go trend notifications, showing updates about an interest trends.',
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        vibrationPattern: mediumVibrationPattern,
        sound: androidSound(NotifySound.notify),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'go-trend_ticker',
        showWhen: true,
        groupKey: "${message.interest}",
        color: _NOTIFICATION_COLOR,
        colorized: _isColored,
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.GO_TREND_ID,
        // sound: 'connect.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString()).then((v) {
        if(showLogs) {
          console.info("Notification builder done", prefix: prefix);
        }
      });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  void _buildOthers(RemoteNotification notification, bool isBackground, bool useInApp, bool showLogs) async {
    if(showLogs) {
      console.debug("Building other notifications", prefix: prefix);
    }

    int id = createUniqueId();
    Notifier notifier = Notifier(
      type: NotifyType.others,
      id: id,
      data: notification.data,
      from: notification.token,
      foreign: notification.title
    );

    if(notifyController.hasCreatedNotification(notifier)) {
      if(showLogs) {
        console.trace("Notification with foreign key: ${notifier.foreign} has already been created", prefix: prefix);
      }

      return;
    }

    if(useInApp && !isBackground) {
      if(showLogs) {
        console.debug("Sending notification to `inAppNotificationController` for inApp builder", prefix: prefix);
      }

      _updateService.updateUseInAppNotification(notifier);
      return;
    } else {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        NotifyChannel.OTHER_ID,
        'Other Notifications',
        channelDescription: 'Notification for services not defined or independent',
        playSound: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        sound: androidSound(NotifySound.notify),
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'other_ticker',
        showWhen: true,
        groupKey: "Hapnium Inc.",
        color: _NOTIFICATION_COLOR,
      );

      DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: NotifyChannel.OTHER_ID,
        // sound: 'notify.aiff',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await plugin.show(id, notification.title, notification.body, notificationDetails, payload: notifier.toString())
        .then((v) {
          if(showLogs) {
            console.info("Notification builder done", prefix: prefix);
          }
        });

      if(showLogs) {
        console.info("Notification built successfully. Sending it to `createdNotification` controller", prefix: prefix);
      }

      _updateService.updateCreatedNotification(notifier);
    }
  }

  @override
  void handleFirebase(RemoteNotificationConfig<T> config) {
    // TODO: implement handleFirebase
  }
}