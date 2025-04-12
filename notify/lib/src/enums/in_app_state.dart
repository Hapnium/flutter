import 'package:flutter/material.dart' show Color, IconData, Icons, Colors;
import 'package:toastification/toastification.dart' show ToastificationType;

/// Represents the different states of an in-app notification, each associated
/// with a specific toast type, icon, and color.
enum InAppState {
  /// Represents an informational notification.
  ///
  /// Displayed with a blue color and an info icon.
  info(ToastificationType.info, Icons.info, Colors.blue),

  /// Represents a warning notification.
  ///
  /// Displayed with a yellow color and a warning icon.
  warning(ToastificationType.warning, Icons.warning_amber_outlined, Colors.yellow),

  /// Represents a success notification.
  ///
  /// Displayed with a green color and a checkmark icon.
  success(ToastificationType.success, Icons.check_circle, Colors.green),

  /// Represents an error notification.
  ///
  /// Displayed with a red color and an error icon.
  error(ToastificationType.error, Icons.error, Colors.red);

  /// The type of toast notification.
  final ToastificationType type;

  /// The icon associated with the notification state.
  final IconData icon;

  /// The color associated with the notification state.
  final Color color;

  /// Creates an [InAppState] enum value.
  const InAppState(this.type, this.icon, this.color);
}