import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart';

/// Configuration for customizing the [MultimediaCamera] widget.
///
/// This class allows fine-grained control over the appearance, behavior, and
/// callbacks for handling camera interactions, errors, recording, and layout.
class MultimediaCameraConfiguration {
  /// Optional informational message to display in the UI.
  final String info;

  /// Whether to show only video recording capabilities.
  final bool showOnlyVideo;

  /// Whether to show only photo capturing capabilities.
  final bool showOnlyPhoto;

  /// Whether the app is running on the web.
  final bool isWeb;

  /// A list of available camera descriptions to choose from.
  final List<CameraDescription> cameras;

  /// Callback for receiving error messages during camera operation.
  final OnErrorReceived? onErrorReceived;

  /// Callback for receiving informational messages.
  final OnInformationReceived? onInfoReceived;

  /// Callback when video recording is completed.
  final SelectedMediaReceived? onRecordingCompleted;

  /// Callback when a photo is successfully captured.
  final SelectedMediaReceived? onImageTaken;

  /// Callback when the camera description (e.g., front/rear camera) is updated.
  final CameraDescriptionUpdated? cameraDescriptionUpdated;

  /// Callback to be triggered when the user presses the back button or exits the camera.
  final VoidCallback onGoingBack;

  /// A custom back button widget.
  final Widget? backButton;

  /// The vertical position for the floating camera action button.
  final double? floatingPosition;

  /// The active color for UI elements (e.g., selected tab, enabled flash).
  final Color? activeColor;

  /// The inactive color for UI elements.
  final Color? inActiveColor;

  /// A common color applied to general camera UI elements.
  final Color? commonColor;

  /// Color used when flash is actively enabled.
  final Color? activeFlashColor;

  /// Color used when flash is disabled or inactive.
  final Color? inActiveFlashColor;

  /// Color displayed when recording is paused.
  final Color? pausedColor;

  /// Color displayed during active recording.
  final Color? recordingColor;

  /// Background color of the progress indicator.
  final Color? progressBackgroundColor;

  /// Color animation for the progress indicator.
  final Animation<Color?>? progressValueColor;

  /// Foreground color of the progress indicator.
  final Color? progressColor;

  /// Shape of the progress stroke's edge.
  final StrokeCap? progressStrokeCap;

  /// Width of the progress stroke.
  final double? progressStrokeWidth;

  /// Icon for the photo camera mode.
  final IconData? cameraIcon;

  /// Icon for the video recording mode.
  final IconData? videoIcon;

  /// Size of the camera action icons.
  final double? actionIconSize;

  /// Color used for "stale" or inactive states.
  final Color? staleColor;

  /// Layout options for positioning and styling the camera interface.
  final MultimediaLayoutConfiguration? layoutConfiguration;

  /// Creates a [MultimediaCameraConfiguration] with optional customization.
  const MultimediaCameraConfiguration({
    this.showOnlyVideo = false,
    this.showOnlyPhoto = true,
    this.isWeb = false,
    this.cameras = const [],
    this.onErrorReceived,
    this.onInfoReceived,
    this.onRecordingCompleted,
    this.info = "",
    this.onImageTaken,
    this.cameraDescriptionUpdated,
    required this.onGoingBack,
    this.backButton,
    this.floatingPosition,
    this.activeColor,
    this.inActiveColor,
    this.commonColor,
    this.activeFlashColor,
    this.inActiveFlashColor,
    this.pausedColor,
    this.recordingColor,
    this.progressBackgroundColor,
    this.progressValueColor,
    this.progressColor,
    this.progressStrokeCap,
    this.progressStrokeWidth,
    this.cameraIcon,
    this.videoIcon,
    this.actionIconSize,
    this.layoutConfiguration,
    this.staleColor,
  });
}