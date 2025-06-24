import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'restorable_camera_controller.dart';

part 'multimedia_camera_state.dart';

/// {@template multimedia_camera}
/// A full-screen camera interface supporting photo capture and video recording.
///
/// This widget provides a fully customizable camera screen that can be pushed
/// onto the navigation stack. It supports both Android and iOS platforms (and optionally web),
/// enabling features like photo capture, video recording, camera switching,
/// and real-time camera feedback.
///
/// The widget is configured via [MultimediaCameraConfiguration], which provides
/// control over callbacks, UI layout, camera list, and error handling.
///
/// ### Example usage:
/// ```dart
/// MultimediaCamera.to(
///   context: context,
///   configuration: MultimediaCameraConfiguration(
///     onImageTaken: (file) {
///       print('Image taken: $file');
///     },
///     onRecordingCompleted: (file) {
///       print('Video recorded: $file');
///     },
///     cameras: availableCameras,
///   ),
/// );
/// ```
/// {@endtemplate}
class MultimediaCamera extends StatefulWidget {
  /// The route name of the screen.
  ///
  /// Used for navigation and debugging. Default route is `"/camera"` if none is provided.
  final String route;

  /// Configuration settings to customize the camera experience.
  ///
  /// Includes options like callbacks for image/video capture, error handling, UI layout,
  /// available cameras, and whether the screen is being run on the web.
  final MultimediaCameraConfiguration configuration;

  /// {@macro multimedia_camera}
  const MultimediaCamera({
    super.key,
    required this.configuration,
    required this.route,
  });

  /// Pushes the [MultimediaCamera] widget onto the navigation stack.
  ///
  /// This is the recommended way to launch the camera screen.
  ///
  /// - [context]: The BuildContext used to access the Navigator.
  /// - [configuration]: Camera configuration options.
  /// - [maintainState]: Whether the route should remain in memory after being popped.
  /// - [fullscreenDialog]: Whether the screen should be shown as a fullscreen modal.
  /// - [allowSnapshotting]: Whether snapshotting of the screen is allowed.
  /// - [barrierDismissible]: If true, tapping outside will dismiss the dialog.
  /// - [settings]: Optional [RouteSettings] to pass custom arguments or names.
  /// - [routeName]: Optional name for the route (defaults to `"/camera"`).
  ///
  /// Returns a [Future] that resolves to a result (or null) when the screen is popped.
  static Future<T?>? to<T>({
    required BuildContext context,
    required MultimediaCameraConfiguration configuration,
    bool maintainState = true,
    bool fullscreenDialog = true,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    RouteSettings? settings,
    String? routeName,
  }) {
    String route = routeName ?? settings?.name ?? "/camera";

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            MultimediaCamera(configuration: configuration, route: route),
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        settings: settings ?? RouteSettings(name: route),
      ),
    );
  }

  @override
  State<MultimediaCamera> createState() => _MultimediaCameraState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onImageTaken', configuration.onImageTaken));
    properties.add(DiagnosticsProperty('onRecordingCompleted', configuration.onRecordingCompleted));
    properties.add(DiagnosticsProperty('onGoingBack', configuration.onGoingBack));
    properties.add(DiagnosticsProperty('cameraDescriptionUpdated', configuration.cameraDescriptionUpdated));
    properties.add(DiagnosticsProperty('onErrorReceived', configuration.onErrorReceived));
    properties.add(DiagnosticsProperty('onInfoReceived', configuration.onInfoReceived));
    properties.add(DiagnosticsProperty('cameras', configuration.cameras));
    properties.add(DiagnosticsProperty('isWeb', configuration.isWeb));
    properties.add(StringProperty('route', route));
    properties.add(DiagnosticsProperty('layout_configuration', configuration.layoutConfiguration));
  }
}