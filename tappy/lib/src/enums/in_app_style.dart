import 'package:toastification/toastification.dart' show ToastificationStyle;

/// {@template in_app_style}
/// Represents the visual styling options available for in-app notifications.
///
/// This enum wraps around [ToastificationStyle] to provide descriptive and
/// customizable display styles for different notification types.
///
/// Each [TappyInAppStyle] corresponds to a visual layout and behavior that
/// affects how notifications appear on screen—ranging from minimal alerts
/// to filled backgrounds with text and icons.
///
/// ### Example usage:
/// ```dart
/// final style = InAppStyle.fillColored;
/// showToast(
///   style: style.toast,
///   title: "Upload Complete",
///   description: "Your file was uploaded successfully"
/// );
/// ```
/// {@endtemplate}
enum TappyInAppStyle {
  /// {@macro in_app_style}
  ///
  /// Displays a compact and subtle notification.
  /// - Style: [ToastificationStyle.minimal]
  minimal(ToastificationStyle.minimal),

  /// {@macro in_app_style}
  ///
  /// Displays the notification with a prominent filled background color.
  /// Suitable for high-visibility alerts.
  /// - Style: [ToastificationStyle.fillColored]
  fillColored(ToastificationStyle.fillColored),

  /// {@macro in_app_style}
  ///
  /// Displays a notification with a solid flat background color.
  /// Cleaner and bolder than [minimal], but less visually intense than [fillColored].
  /// - Style: [ToastificationStyle.flatColored]
  flatColored(ToastificationStyle.flatColored),

  /// {@macro in_app_style}
  ///
  /// Displays a notification with a flat layout and no background color.
  /// Best for non-intrusive informational messages.
  /// - Style: [ToastificationStyle.flat]
  flat(ToastificationStyle.flat),

  /// {@macro in_app_style}
  ///
  /// A bare-bones notification showing only the title text.
  /// No icons, actions, or decorations are included.
  /// - Style: [ToastificationStyle.simple]
  simple(ToastificationStyle.simple);

  /// The associated [ToastificationStyle] that defines the visual behavior.
  final ToastificationStyle toast;

  /// Creates an [TappyInAppStyle] enum value.
  ///
  /// This links the style to its corresponding [ToastificationStyle] for UI rendering.
  /// 
  /// {@macro in_app_style}
  const TappyInAppStyle(this.toast);
}