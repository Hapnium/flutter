import 'package:flutter/material.dart';
import 'package:smart/utilities.dart'; // Assuming Utilities contains Sizing class

/// {@template go_back}
/// A reusable IconButton for navigating back.
/// 
/// This widget provides a convenient way to add a back button to your screens 
/// with customizable appearance and behavior.
///
/// **Parameters:**
///
/// * **onTap:** An optional callback function that will be executed when the button is pressed.
///             If not provided, it defaults to popping the current route from the navigator.
/// * **size:** The size of the icon. Defaults to Sizing.font(30).
/// * **color:** The color of the icon. Defaults to the primary color of the current theme.
/// * **icon:** The icon to display. Defaults to Icons.keyboard_arrow_left_rounded.
/// * **radius:** The splash radius of the button. Defaults to 25.
/// * **style:** The button style to apply.
/// * **mouseCursor:** The mouse cursor to display when hovering over the button.
/// * **focusNode:** The focus node for the button.
/// * **autofocus:** Whether the button should automatically receive focus. Defaults to false.
/// * **tooltip:** The tooltip to display when hovering over the button.
/// * **enableFeedback:** Whether to enable haptic feedback when the button is pressed.
/// * **constraints:** Constraints for the button's size.
/// * **isSelected:** Whether the button is currently selected.
/// * **selectedIcon:** The icon to display when the button is selected.
/// * **defaultIcon:** The default icon to display.
/// * **result:** The data to be passed to the previous route when popping.
/// 
/// {@endtemplate}
class GoBack<T> extends StatelessWidget {
  /// An optional callback function that will be executed when the button is pressed.
  /// 
  /// If not provided, it defaults to popping the current route from the navigator.
  final VoidCallback? onTap;

  /// The size of the icon. Defaults to Sizing.font(30).
  final double? size;

  /// The color of the icon. Defaults to the primary color of the current theme.
  final Color? color;

  /// The icon to display. Defaults to Icons.keyboard_arrow_left_rounded.
  final IconData? icon;

  /// The splash radius of the button. Defaults to 25.
  final double? radius;

  /// The button style to apply.
  final ButtonStyle? style;

  /// The mouse cursor to display when hovering over the button.
  final MouseCursor? mouseCursor;

  /// The focus node for the button.
  final FocusNode? focusNode;

  /// Whether the button should automatically receive focus. Defaults to false.
  final bool autofocus;

  /// The tooltip to display when hovering over the button.
  final String? tooltip;

  /// Whether to enable haptic feedback when the button is pressed.
  final bool? enableFeedback;

  /// Constraints for the button's size.
  final BoxConstraints? constraints;

  /// Whether the button is currently selected.
  final bool? isSelected;

  /// The icon to display when the button is selected.
  final Widget? selectedIcon;

  /// The default icon to display.
  final Widget? defaultIcon;

  /// The data to be passed to the previous route when popping.
  final T? result;

  /// Creates a [GoBack] widget.
  /// 
  /// {@macro go_back}
  const GoBack({
    super.key,
    this.onTap,
    this.size,
    this.color,
    this.icon,
    this.radius,
    this.style,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.isSelected,
    this.selectedIcon,
    this.result,
    this.defaultIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: radius ?? 25,
      iconSize: size ?? Sizing.font(30),
      onPressed: onTap ?? () => Navigator.pop(context, result),
      style: style,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
      icon: defaultIcon ?? Icon(
        icon ?? Icons.keyboard_arrow_left_rounded,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? Sizing.font(30),
      ),
    );
  }
}