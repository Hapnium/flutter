Here's the README file for your `notify` package:

---

# **Notify Package**

A powerful and easy-to-use Flutter package for managing notifications across your applications. With `Notify`, you can seamlessly handle **in-app**, **remote**, and **device-level notifications**, including notifications tapped in the background.

## **Features**

- Initialize notifications easily with `NotifyWrapper`.
- Support for in-app and device-level notifications.
- Background and foreground notification handling.
- App-specific notification tap handlers.
- Simple and flexible API for creating and managing notifications.
- Supports both Android and iOS platforms.

---

## Authentication

For local development, leverage the `.netrc` file for secure credential storage. This eliminates the need to embed credentials directly in URLs.

**Steps:**

1. **Create a `.netrc` File:**
    - In your home directory (e.g., `~/.netrc`), create a file with the following content:

   ```bash
   machine github.com
   login your_username
   password your_personal_access_token
   ```

2. **Set Permissions:**
    - Ensure the file is not readable by others for security:

   ```bash
   chmod 600 ~/.netrc
   ```

## Installation

Install `notify` using Flutter:

```yaml
dependencies:
  notify:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: notify
```

Run `flutter pub get` to install the package.

---

## **Usage**

### **1. Wrapping Your App with `NotifyWrapper`**

Wrap your app with the `NotifyWrapper` to initialize and manage notifications:

```dart
import 'package:flutter/material.dart';
import 'package:notify/notify.dart';

void main() {
  runApp(
    NotifyWrapper(
      info: AppInfo(
        androidIcon: "ic_launcher",
        app: App.user,
      ),
      platform: DevicePlatform.ANDROID,
      showInitializationLogs: true,
      onPermitted: (isPermitted) {
        debugPrint('Notification permission: $isPermitted');
      },
      onLaunchedByNotification: (notification) {
        debugPrint('App launched by notification: $notification');
      },
      child: MaterialApp(
        home: MyHomePage(),
      ),
    ),
  );
}
```

### **2. Listening for Notification Updates**

To listen for updates from notifications, you can use a `Stream`:

```dart
import 'package:flutter/material.dart';
import 'package:notify/notify.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final StreamSubscription<Notifier> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Notify.instance.remote().notificationStream.listen((notifier) {
      debugPrint("Notification tapped: ${notifier.id}");
      // Handle the notification response here.
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notify Example")),
      body: Center(child: Text("Listen for notifications here!")),
    );
  }
}
```

---

### **3. Handling Background Notifications**

For apps requiring custom handling of background notifications, add a VM entry point in your app:

```dart
import 'package:notify/notify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  Notify.instance.handleNotificationResponse(response, handler: (notifier) {
    debugPrint("Background notification tapped: ${notifier.id}");
    // Custom logic for the app.
  });
}
```

**Remember to optionally add `flutter_local_notifications: ` under dependencies in your `pubspec.yaml` file.**
**This eliminates the `depend_on_referenced_package` lint issue in flutter. Leave the version empty for version compatibility.**
---

### **4. Adding App-Specific Notification Tap Handlers**

You can add app-specific handlers to process notifications tapped while the app is in the background or foreground.

#### Example:

```dart
import 'package:notify/notify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotifyWrapper(
    info: AppInfo(
      androidIcon: "ic_launcher",
      app: App.user,
    ),
    platform: DevicePlatform.ANDROID,
    handler: (notifier) {
      debugPrint("Notification tapped while app in foreground: ${notifier.id}");
    },
    backgroundHandler: notificationTapBackground,
    child: MaterialApp(
      home: MyHomePage(),
    ),
  );
}
```

---

## **Features of the `Notify` Class**

The `Notify` class provides multiple services for notifications:

- **In-App Notifications:**
  ```dart
  Notify.instance.inApp().showNotification("In-App Message", "Hello from Notify!");
  ```

- **Remote Notifications:**
  ```dart
  Notify.instance.remote().sendNotification("Remote Title", "Remote message body.");
  ```

- **Device-Level Notifications:**
  ```dart
  Notify.instance.manager().dismissNotification(notificationId: 123);
  ```

- **Notification Tap Handlers:**
  ```dart
  Notify.instance.handleNotificationResponse(
    response,
    handler: (notifier) {
      debugPrint("Notification tapped: ${notifier.id}");
    },
  );
  ```

---

## **API Reference**

### **NotifyWrapper Parameters**

| Parameter                  | Type                         | Description                                                                                       | Default  |
|----------------------------|------------------------------|---------------------------------------------------------------------------------------------------|----------|
| `child`                    | `Widget`                    | The root widget of the app, typically `MaterialApp` or `CupertinoApp`.                           | Required |
| `info`                     | `AppInfo`                   | Provides information about the application.                                                      | Required |
| `platform`                 | `DevicePlatform`            | Specifies the target platform, e.g., `DevicePlatform.ANDROID` or `DevicePlatform.IOS`.           | Required |
| `showInitializationLogs`   | `bool`                      | Enables logging during initialization for debugging purposes.                                     | `false`  |
| `onPermitted`              | `Function(bool)`            | Callback for checking notification permission status.                                             | `null`   |
| `onLaunchedByNotification` | `Function(Notifier)`         | Callback triggered when the app is launched via a notification.                                  | `null`   |
| `handler`                  | `NotificationTapHandler`    | Handles notification taps when the app is in the foreground.                                      | `null`   |
| `backgroundHandler`        | `NotificationResponseHandler` | Handles notification taps when the app is in the background.                                      | `null`   |

---

## **License**

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---