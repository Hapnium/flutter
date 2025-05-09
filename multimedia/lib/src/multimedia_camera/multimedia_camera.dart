import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'restorable_camera_controller.dart';

part 'multimedia_camera_state.dart';

/// A full-screen camera interface supporting photo capture and video recording.
///
/// This widget can be pushed onto the navigation stack to allow users to
/// interact with the camera, using settings defined in [MultimediaCameraConfiguration].
class MultimediaCamera extends StatefulWidget {
  /// The route name of the screen
  final String route;

  /// Configuration settings to customize the camera experience.
  final MultimediaCameraConfiguration configuration;

  /// Creates a [MultimediaCamera] widget.
  const MultimediaCamera({super.key, required this.configuration, required this.route});

  /// Pushes the [MultimediaCamera] widget onto the navigation stack.
  ///
  /// - [context]: The BuildContext to use for navigation.
  /// - [configuration]: Configuration for the camera screen.
  /// - [maintainState]: Whether the route should remain in memory.
  /// - [fullscreenDialog]: Whether to show the camera as a fullscreen dialog.
  /// - [allowSnapshotting]: Whether the page allows snapshotting.
  /// - [barrierDismissible]: If true, the dialog can be dismissed by tapping outside.
  /// - [settings]: Optional route settings.
  /// - [routeName]: Optional name for the route.
  ///
  /// Returns a [Future] resolving to a value of type [T], or null.
  static Future<T?>? to<T>({
    required BuildContext context,
    required MultimediaCameraConfiguration configuration,
    bool maintainState = true,
    bool fullscreenDialog = true,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    RouteSettings? settings,
    String? routeName
  }) {
    String route = routeName ?? settings?.name ?? "/camera";

    return Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => MultimediaCamera(configuration: configuration, route: route),
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
      barrierDismissible: barrierDismissible,
      settings: settings ?? RouteSettings(name: routeName ?? "/camera"),
    ));
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