import 'package:flutter/material.dart' show Color, IconData, Icons, Colors;
import 'package:toastification/toastification.dart' show ToastificationType;

/// {@template in_app_state}
/// Defines the visual and behavioral characteristics of in-app notification states.
///
/// Each [TappyInAppState] corresponds to a type of notification with a predefined:
/// - [ToastificationType] to control toast style
/// - [IconData] to visually indicate the context
/// - [Color] to signal urgency or type (e.g., info, error)
///
/// This enum simplifies UI feedback logic by centralizing styling and toast logic
/// in one place, which improves consistency across the application.
///
/// ### Example usage:
/// ```dart
/// final state = InAppState.warning;
/// showToast(
///   type: state.type,
///   icon: Icon(state.icon, color: state.color),
///   message: "This is a warning!"
/// );
/// ```
/// {@endtemplate}
enum TappyInAppState {
  /// {@macro in_app_state}
  ///
  /// Used for general informational messages that require no user action.
  /// - Toast type: [ToastificationType.info]
  /// - Icon: [Icons.info]
  /// - Color: [Colors.blue]
  info(ToastificationType.info, Icons.info, Colors.blue),

  /// {@macro in_app_state}
  ///
  /// Used to alert users of a potential issue or something to pay attention to.
  /// - Toast type: [ToastificationType.warning]
  /// - Icon: [Icons.warning_amber_outlined]
  /// - Color: [Colors.yellow]
  warning(ToastificationType.warning, Icons.warning_amber_outlined, Colors.yellow),

  /// {@macro in_app_state}
  ///
  /// Used to indicate successful completion of a task or process.
  /// - Toast type: [ToastificationType.success]
  /// - Icon: [Icons.check_circle]
  /// - Color: [Colors.green]
  success(ToastificationType.success, Icons.check_circle, Colors.green),

  /// {@macro in_app_state}
  ///
  /// Used to tappy the user of errors or critical problems.
  /// - Toast type: [ToastificationType.error]
  /// - Icon: [Icons.error]
  /// - Color: [Colors.red]
  error(ToastificationType.error, Icons.error, Colors.red);

  /// The toastification type used to determine the style of the notification.
  ///
  /// This influences the animation, background, and general layout of the toast.
  final ToastificationType type;

  /// The icon used in the UI for the toast, corresponding to the notification's context.
  final IconData icon;

  /// The primary color used for the toast's visual cues (e.g., icon tint or background).
  final Color color;

  /// Creates an instance of [TappyInAppState] with associated metadata.
  ///
  /// All fields are required and constant.
  /// 
  /// {@macro in_app_state}
  const TappyInAppState(this.type, this.icon, this.color);
}