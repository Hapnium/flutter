import 'package:flutter/cupertino.dart' hide TargetPlatform;
import 'package:flutter/foundation.dart';
import 'package:notify/notify.dart';
import 'package:toastification/toastification.dart';

import '../../utilities/definitions.dart';
import '../../utilities/platform_engine.dart';

part 'notify_wrapper_state.dart';

/// A wrapper widget that initializes and manages notifications for the application.
///
/// This widget must wrap the root `MaterialApp` widget in the widget tree to ensure
/// proper notification handling and initialization. It provides notification services,
/// permission checks, and handles app launches triggered by notifications.
///
/// Example usage:
/// ```dart
/// void main() {
///   runApp(
///     NotifyWrapper(
///       app: AppInfo(
///         androidIcon: "",
///         app: App.user
///       ),
///       platform: NotifyPlatform.ANDROID,
///       showInitializationLogs: true,
///       onPermitted: (isPermitted) {
///         debugPrint('Notification permission: $isPermitted');
///       },
///       onLaunchedByNotification: (notification) {
///         debugPrint('App launched by notification: $notification');
///       },
///       child: MaterialApp(
///         home: MyHomePage(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// Parameters:
/// - [child]: The child widget, usually the `MaterialApp` or `CupertinoApp`, that this wrapper manages.
/// - [info]: Specifies the information about the application running this package.
/// - [platform]: Defines the target device platform (e.g., `NotifyPlatform.ANDROID`, `NotifyPlatform.IOS`).
/// - [showInitializationLogs]: Enables or disables logs during initialization for debugging. Defaults to `false`.
/// - [onPermitted]: A callback function that is invoked with the current notification permission status.
/// - [onLaunchedByNotification]: A callback function triggered when the app is launched via a notification.
class NotifyWrapper extends StatefulWidget {
  /// The child widget, typically the `MaterialApp` or `CupertinoApp`, that this wrapper manages.
  final Widget child;

  /// The application platform, such as `AppPlatform.user` or `AppPlatform.provider`.
  final NotifyAppInformation info;

  /// The target device platform, such as `NotifyPlatform.ANDROID` or `NotifyPlatform.IOS`.
  final NotifyPlatform platform;

  /// Whether to show logs during initialization. Useful for debugging.
  final bool showInitializationLogs;

  /// Callback triggered when notification permission status is determined.
  final PermissionCallback? onPermitted;

  /// Callback triggered when the info is launched by a notification.
  final NotificationTapHandler? onLaunchedByNotification;

  /// Handler for notification tapped when app is not in background
  final NotificationTapHandler? handler;

  /// Handles background tap for any notification
  final NotificationResponseHandler? backgroundHandler;

  /// A typedef for a function that configures an [InAppConfig] object.
  ///
  /// This allows for a more concise way to customize the in-app notification
  /// configuration.  You can create a function that takes an existing
  /// [InAppConfig] and returns a modified version.
  final InAppNotificationConfigurer? inAppConfigurer;

  const NotifyWrapper({
    super.key,
    required this.child,
    required this.info,
    required this.platform,
    this.onPermitted,
    this.showInitializationLogs = false,
    this.onLaunchedByNotification,
    this.handler,
    this.backgroundHandler,
    this.inAppConfigurer,
  });

  @override
  State<NotifyWrapper> createState() => _NotifyWrapperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('child', child));
    properties.add(DiagnosticsProperty<NotifyAppInformation>('info', info));
    properties.add(EnumProperty<NotifyPlatform>('platform', platform));
    properties.add(FlagProperty(
      'showInitializationLogs',
      value: showInitializationLogs,
      ifTrue: 'show logs enabled',
      ifFalse: 'show logs disabled',
    ));
    properties.add(ObjectFlagProperty<PermissionCallback?>.has('onPermitted', onPermitted));
    properties.add(ObjectFlagProperty<NotificationTapHandler?>.has('onLaunchedByNotification', onLaunchedByNotification));
    properties.add(ObjectFlagProperty<NotificationTapHandler?>.has('handler', handler));
    properties.add(ObjectFlagProperty<NotificationResponseHandler?>.has('backgroundHandler', backgroundHandler));
    properties.add(ObjectFlagProperty<InAppNotificationConfigurer?>.has('inAppConfigurer', inAppConfigurer));
  }
}