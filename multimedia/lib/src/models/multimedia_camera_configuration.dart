import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart';

/// {@template multimedia_camera_configuration}
/// Configuration for customizing the [MultimediaCamera] widget interface, layout, and lifecycle behavior.
///
/// This class allows fine-tuning of camera modes (photo or video), platform-specific behavior,
/// icon and color customization, action layout positioning, and recording state styling.
///
/// Use this configuration when integrating a camera into your application and want control over:
/// - UI feedback colors (recording, paused, flash, etc.)
/// - Layout (floating button position, back button, icon sizes)
/// - Behavior (callbacks for capture events, camera switching)
/// - Platform modes (e.g., `isWeb`, `showOnlyVideo`)
///
/// ### Example
/// ```dart
/// MultimediaCameraConfiguration(
///   showOnlyPhoto: true,
///   isWeb: false,
///   cameras: availableCameras,
///   onGoingBack: () => Navigator.pop(context),
///   activeColor: Colors.red,
///   recordingColor: Colors.redAccent,
///   cameraIcon: CupertinoIcons.camera,
/// )
/// ```
/// {@endtemplate}
class MultimediaCameraConfiguration {
  /// Optional informational text shown in the camera interface.
  ///
  /// This can be used to communicate capture instructions or status messages to the user.
  ///
  /// Defaults to an empty string.
  final String info;

  /// Whether to show only the video recording option.
  ///
  /// Disables photo capture features when `true`.
  ///
  /// Defaults to `false`.
  final bool showOnlyVideo;

  /// Whether to show only the photo capture option.
  ///
  /// Disables video recording features when `true`.
  ///
  /// Defaults to `true`.
  final bool showOnlyPhoto;

  /// Whether the camera is running in a web environment.
  ///
  /// This may impact platform-specific rendering and feature support.
  ///
  /// Defaults to `false`.
  final bool isWeb;

  /// List of available camera devices (front, back, etc.).
  ///
  /// Used to populate initial camera state and allow switching.
  ///
  /// Defaults to an empty list.
  final List<CameraDescription> cameras;

  /// Called when a camera error occurs, such as permission denial or hardware failure.
  ///
  /// `null` by default.
  final OnErrorReceived? onErrorReceived;

  /// Called when camera emits an informational message.
  ///
  /// For example, focus locked or exposure adjusted.
  ///
  /// `null` by default.
  final OnInformationReceived? onInfoReceived;

  /// Called when a video recording is successfully completed.
  ///
  /// Use this to process or save the captured video.
  ///
  /// `null` by default.
  final SelectedMediaReceived? onRecordingCompleted;

  /// Called when a photo is successfully captured.
  ///
  /// Use this to process or display the captured image.
  ///
  /// `null` by default.
  final SelectedMediaReceived? onImageTaken;

  /// Called when the active camera changes (e.g., front to back).
  ///
  /// `null` by default.
  final CameraDescriptionUpdated? cameraDescriptionUpdated;

  /// Called when the user navigates away from the camera (e.g., taps back).
  ///
  /// This is a required field.
  final VoidCallback onGoingBack;

  /// Custom widget for the back button.
  ///
  /// Allows overriding the default back button UI.
  ///
  /// `null` by default.
  final Widget? backButton;

  /// Vertical position for the floating shutter/record button.
  ///
  /// Controls the bottom spacing of the main action.
  ///
  /// `null` by default.
  final double? floatingPosition;

  /// Color used for currently active UI elements (e.g., selected mode).
  ///
  /// `null` by default.
  final Color? activeColor;

  /// Color used for inactive or unselected UI elements.
  ///
  /// `null` by default.
  final Color? inActiveColor;

  /// Shared color used across common camera UI components.
  ///
  /// `null` by default.
  final Color? commonColor;

  /// Color of the flash icon when flash is active.
  ///
  /// `null` by default.
  final Color? activeFlashColor;

  /// Color of the flash icon when flash is inactive.
  ///
  /// `null` by default.
  final Color? inActiveFlashColor;

  /// Color used while video recording is paused.
  ///
  /// `null` by default.
  final Color? pausedColor;

  /// Color used during active video recording.
  ///
  /// `null` by default.
  final Color? recordingColor;

  /// Background color for the circular progress indicator during recording.
  ///
  /// `null` by default.
  final Color? progressBackgroundColor;

  /// Color animation used for the progress indicator value.
  ///
  /// `null` by default.
  final Animation<Color?>? progressValueColor;

  /// Foreground color for the recording progress indicator.
  ///
  /// `null` by default.
  final Color? progressColor;

  /// Shape of stroke ends in the circular progress indicator.
  ///
  /// Typically [StrokeCap.round] or [StrokeCap.square].
  ///
  /// `null` by default.
  final StrokeCap? progressStrokeCap;

  /// Stroke width of the circular progress indicator.
  ///
  /// `null` by default.
  final double? progressStrokeWidth;

  /// Icon used to indicate photo capture mode.
  ///
  /// `null` by default.
  final IconData? cameraIcon;

  /// Icon used to indicate video recording mode.
  ///
  /// `null` by default.
  final IconData? videoIcon;

  /// Size of action icons like camera or video record.
  ///
  /// `null` by default.
  final double? actionIconSize;

  /// Color applied to stale or idle elements.
  ///
  /// Useful for subdued states like disabled flash.
  ///
  /// `null` by default.
  final Color? staleColor;

  /// The maximum duration to apply as constraint while recording.
  /// 
  /// **Note** [maxDuration] cannot be lesser than [minDuration]
  /// 
  /// Defaults to 30 seconds
  final int maxDuration;

  /// The minimum duration to apply as constraint while recording.
  /// 
  /// **Note** [minDuration] cannot be greater than [maxDuration]
  /// 
  /// Defaults to 1 second
  final int minDuration;

  /// Configuration for customizing layout-related properties like alignment and padding.
  ///
  /// `null` by default.
  final MultimediaLayoutConfiguration? layoutConfiguration;

  /// {@macro multimedia_camera_configuration}
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
    this.maxDuration = 30,
    this.minDuration = 1
  }) : assert(maxDuration > minDuration, "Max duration constraint cannot be lesser or equals to min duration");
}