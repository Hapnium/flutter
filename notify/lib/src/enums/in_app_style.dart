import 'package:toastification/toastification.dart' show ToastificationStyle;

/// Defines the different styles for displaying in-app notifications.
enum InAppStyle {
  /// A minimal style notification with a subtle appearance.
  minimal(ToastificationStyle.minimal),

  /// A notification with a filled colored background.
  fillColored(ToastificationStyle.fillColored),

  /// A notification with a flat colored background.
  flatColored(ToastificationStyle.flatColored),

  /// A flat notification with no background color.
  flat(ToastificationStyle.flat),

  /// A simple notification that only displays the title text.
  /// It does not include any icon or other widgets.
  simple(ToastificationStyle.simple);

  /// The corresponding ToastificationStyle for this InAppStyle.
  final ToastificationStyle toast;

  /// Creates an [InAppStyle] enum value.
  const InAppStyle(this.toast);
}