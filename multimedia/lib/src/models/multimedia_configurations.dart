import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart' show OnErrorReceived;

/// {@template multimedia_done_button_config}
/// Configuration for customizing the "Done" button used in multimedia interfaces,
/// such as image pickers, file browsers, or media editors.
///
/// This class allows overriding the entire button widget or customizing
/// individual aspects like text, size, color, and padding.
///
/// ### Example:
/// ```dart
/// MultimediaDoneButtonConfiguration(
///   text: 'Finish',
///   backgroundColor: Colors.green,
///   shape: RoundedRectangleBorder(
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
/// ```
/// {@endtemplate}
class MultimediaDoneButtonConfiguration {
  /// A custom widget to completely override the default "Done" button.
  ///
  /// Default: `null`
  final Widget? widget;

  /// Text label for the button.
  ///
  /// Default: `null`
  final String? text;

  /// Font size of the button's text.
  ///
  /// Default: `null`
  final double? size;

  /// Font weight of the button's text.
  ///
  /// Default: `null`
  final FontWeight? fontWeight;

  /// Color of the button's text.
  ///
  /// Default: `null`
  final Color? color;

  /// Background color of the button.
  ///
  /// Default: `null`
  final Color? backgroundColor;

  /// Foreground color for icon or text.
  ///
  /// Default: `null`
  final Color? foregroundColor;

  /// Overlay color when the button is hovered or pressed.
  ///
  /// Default: `null`
  final Color? overlayColor;

  /// Shape of the button (e.g., `RoundedRectangleBorder`).
  ///
  /// Default: `null`
  final OutlinedBorder? shape;

  /// Padding inside the button.
  ///
  /// Default: `null`
  final EdgeInsets? padding;

  /// {@macro multimedia_done_button_config}
  const MultimediaDoneButtonConfiguration({
    this.widget,
    this.text,
    this.size,
    this.fontWeight,
    this.color,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shape,
    this.padding,
  });
}

/// {@template multimedia_icon_config}
/// Configuration for customizing icons used in media selection UIs,
/// such as toggles for grid and list views.
///
/// ### Example:
/// ```dart
/// MultimediaIconConfiguration(
///   grid: Icons.grid_view,
///   list: Icons.list,
///   color: Colors.grey,
///   size: 20,
/// )
/// ```
/// {@endtemplate}
class MultimediaIconConfiguration {
  /// Icon for grid layout view.
  ///
  /// Default: `null`
  final IconData? grid;

  /// Icon for list layout view.
  ///
  /// Default: `null`
  final IconData? list;

  /// Color applied to both icons.
  ///
  /// Default: `null`
  final Color? color;

  /// Size of the icons.
  ///
  /// Default: `null`
  final double? size;

  /// {@macro multimedia_icon_config}
  const MultimediaIconConfiguration({
    this.size,
    this.color,
    this.grid,
    this.list,
  });
}

/// {@template multimedia_grid_filter_config}
/// Configuration for filter chips or buttons in a grid layout,
/// often used for filtering media types or categories.
///
/// ### Example:
/// ```dart
/// MultimediaGridFilterConfiguration(
///   spacing: 8,
///   runSpacing: 4,
///   buttonTextSize: 12,
///   buttonColor: Colors.blueAccent,
/// )
/// ```
/// {@endtemplate}
class MultimediaGridFilterConfiguration {
  /// Horizontal spacing between buttons.
  ///
  /// Default: `null`
  final double? spacing;

  /// Vertical spacing between rows of buttons.
  ///
  /// Default: `null`
  final double? runSpacing;

  /// Padding inside each filter button.
  ///
  /// Default: `null`
  final EdgeInsetsGeometry? buttonPadding;

  /// Shape of the filter buttons.
  ///
  /// Default: `null`
  final OutlinedBorder? buttonShape;

  /// Font size of the button text.
  ///
  /// Default: `null`
  final double? buttonTextSize;

  /// Background or text color of the filter buttons.
  ///
  /// Default: `null`
  final Color? buttonColor;

  /// Outer padding for the filter container.
  ///
  /// Default: `null`
  final EdgeInsetsGeometry? padding;

  /// Main axis alignment for button rows.
  ///
  /// Default: `null`
  final WrapAlignment? runAlignment;

  /// Cross axis alignment for button content.
  ///
  /// Default: `null`
  final WrapCrossAlignment? crossAlignment;

  /// {@macro multimedia_grid_filter_config}
  const MultimediaGridFilterConfiguration({
    this.spacing,
    this.runSpacing,
    this.buttonPadding,
    this.buttonShape,
    this.buttonTextSize,
    this.buttonColor,
    this.padding,
    this.runAlignment,
    this.crossAlignment,
  });
}

/// {@template multimedia_no_item_config}
/// Configuration used when there are no media items to display.
/// This allows showing a custom empty state with an icon and message.
///
/// ### Example:
/// ```dart
/// MultimediaNoItemConfiguration(
///   icon: Icons.image_not_supported,
///   message: 'No media found',
///   iconSize: 48,
///   textSize: 16,
///   spacing: 12,
///   opacity: 0.6,
/// )
/// ```
/// {@endtemplate}
class MultimediaNoItemConfiguration {
  /// Custom widget to use instead of the default icon.
  ///
  /// Default: `null`
  final Widget? iconWidget;

  /// Message to be displayed (e.g., "No files found").
  ///
  /// Default: `null`
  final String? message;

  /// Default icon shown when no custom widget is provided.
  ///
  /// Default: `null`
  final IconData? icon;

  /// Text color of the message.
  ///
  /// Default: `null`
  final Color? textColor;

  /// Icon size.
  ///
  /// Default: `null`
  final double? iconSize;

  /// Font size of the message text.
  ///
  /// Default: `null`
  final double? textSize;

  /// Space between icon and message.
  ///
  /// Default: `null`
  final double? spacing;

  /// Overall opacity of the empty state widget.
  ///
  /// Default: `null`
  final double? opacity;

  /// {@macro multimedia_no_item_config}
  const MultimediaNoItemConfiguration({
    this.iconWidget,
    this.message,
    this.icon,
    this.textColor,
    this.iconSize,
    this.textSize,
    this.spacing,
    this.opacity,
  });
}

/// {@template multimedia_no_permission_config}
/// Configuration for the UI displayed when required permissions
/// (e.g., storage, camera) are not granted by the user.
///
/// Includes styling and content for icon, message, and call-to-action button.
///
/// ### Example:
/// ```dart
/// MultimediaNoPermissionConfiguration(
///   icon: Icons.lock,
///   message: 'Storage permission is required',
///   buttonText: 'Open Settings',
///   buttonBackgroundColor: Colors.red,
/// )
/// ```
/// {@endtemplate}
class MultimediaNoPermissionConfiguration {
  /// Custom icon widget.
  ///
  /// Default: `null`
  final Widget? iconWidget;

  /// Color of the message text.
  ///
  /// Default: `null`
  final Color? textColor;

  /// Size of the icon.
  ///
  /// Default: `null`
  final double? iconSize;

  /// Size of the permission text.
  ///
  /// Default: `null`
  final double? textSize;

  /// Spacing between icon, message, and button.
  ///
  /// Default: `null`
  final double? spacing;

  /// Text color of the action button.
  ///
  /// Default: `null`
  final Color? buttonColor;

  /// Font weight of the button text.
  ///
  /// Default: `null`
  final FontWeight? buttonWeight;

  /// Font size of the button text.
  ///
  /// Default: `null`
  final double? buttonSize;

  /// Padding inside the button.
  ///
  /// Default: `null`
  final EdgeInsets? buttonPadding;

  /// Shape of the action button.
  ///
  /// Default: `null`
  final RoundedRectangleBorder? buttonShape;

  /// Overlay color when the button is interacted with.
  ///
  /// Default: `null`
  final Color? buttonOverlayColor;

  /// Overall opacity of the widget.
  ///
  /// Default: `null`
  final double? opacity;

  /// Background color of the button.
  ///
  /// Default: `null`
  final Color? buttonBackgroundColor;

  /// Foreground color (text or icon) for the button.
  ///
  /// Default: `null`
  final Color? buttonForegroundColor;

  /// Icon to display (if no widget is given).
  ///
  /// Default: `null`
  final IconData? icon;

  /// Message explaining why permission is needed.
  ///
  /// Default: `null`
  final String? message;

  /// Text on the button (e.g., "Grant Access").
  ///
  /// Default: `null`
  final String? buttonText;

  /// {@macro multimedia_no_permission_config}
  const MultimediaNoPermissionConfiguration({
    this.iconWidget,
    this.textColor,
    this.iconSize,
    this.textSize,
    this.spacing,
    this.buttonColor,
    this.buttonWeight,
    this.buttonSize,
    this.buttonPadding,
    this.buttonShape,
    this.buttonOverlayColor,
    this.opacity,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
    this.icon,
    this.message,
    this.buttonText,
  });
}

/// {@template multimedia_file_manager_config}
/// Configuration for customizing the multimedia file manager view,
/// such as in a media picker or asset manager. Controls text, icons,
/// and callbacks including error handling.
///
/// ### Example:
/// ```dart
/// MultimediaFileManagerConfiguration(
///   text: 'Browse Files',
///   icon: Icons.folder,
///   onPressed: () => openFilePicker(),
///   onError: (e) => print('Error: $e'),
/// )
/// ```
/// {@endtemplate}
class MultimediaFileManagerConfiguration {
  /// Primary color for text or icon.
  ///
  /// Default: `null`
  final Color? color;

  /// Title or heading text in the file manager.
  ///
  /// Default: `null`
  final String? text;

  /// Description or body text under the title.
  ///
  /// Default: `null`
  final String? body;

  /// Callback triggered when the file manager's primary action is pressed.
  ///
  /// Default: `null`
  final VoidCallback? onPressed;

  /// Icon used to represent the file manager's function.
  ///
  /// Default: `null`
  final IconData? icon;

  /// Callback when an error is received during media loading.
  ///
  /// Default: `null`
  final OnErrorReceived? onError;

  /// {@macro multimedia_file_manager_config}
  const MultimediaFileManagerConfiguration({
    this.color,
    this.text,
    this.body,
    this.onPressed,
    this.icon,
    this.onError,
  });
}