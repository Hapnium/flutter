import 'package:flutter/material.dart';
import 'package:smart/src/styles/colors/common_colors.dart';
import 'package:smart/utilities.dart';

/// {@template info_button}
/// A custom IconButton designed to display information.
/// 
/// **Parameters:**
/// * **onPressed:** The callback function to be executed when the button is pressed.
/// * **icon:** The custom icon to display on the button.
/// * **tip:** The tooltip text to display when hovering over the button.
/// * **defaultIcon:** The default icon to display if no custom icon is provided. 
///                   Defaults to `Icons.info_outline_rounded`.
/// * **defaultIconSize:** The default size of the icon. Defaults to 22.
/// * **defaultIconColor:** The default color of the icon. 
///                       Defaults to the primary color of the current theme.
/// * **shape:** The shape of the button. Defaults to a CircleBorder.
/// * **overlayColor:** The color of the overlay when the button is pressed.
/// * **backgroundColor:** The background color of the button.
/// * **textStyle:** The text style for the button's text (if applicable).
/// * **foregroundColor:** The color of the button's text (if applicable).
/// * **shadowColor:** The color of the button's shadow.
/// * **surfaceTintColor:** The surface tint color of the button.
/// * **elevation:** The elevation of the button.
/// * **padding:** The padding of the button.
/// * **minimumSize:** The minimum size of the button.
/// * **fixedSize:** The fixed size of the button.
/// * **maximumSize:** The maximum size of the button.
/// * **iconColor:** The color of the icon.
/// * **iconSize:** The size of the icon.
/// * **side:** The border of the button.
/// * **mouseCursor:** The mouse cursor to display when hovering over the button.
/// * **visualDensity:** The visual density of the button.
/// * **tapTargetSize:** The tap target size of the button.
/// * **animationDuration:** The duration of the button's animations.
/// * **enableFeedback:** Whether to enable haptic feedback when the button is pressed.
/// * **alignment:** The alignment of the button's contents.
/// * **splashFactory:** The splash factory used to create the button's splash effect.
/// * **backgroundBuilder:** A builder function for the button's background.
/// * **foregroundBuilder:** A builder function for the button's foreground. 
/// 
/// {@endtemplate}
class InfoButton extends StatelessWidget {
  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// The custom icon to display on the button.
  final Widget? icon;

  /// The tooltip text to display when hovering over the button.
  final String? tip;

  /// The default icon to display if no custom icon is provided. 
  /// Defaults to `Icons.info_outline_rounded`.
  final IconData? defaultIcon;

  /// The default size of the icon. Defaults to 22.
  final double? defaultIconSize;

  /// The icon button size
  final double? iconButtonSize;

  /// The default color of the icon. 
  /// Defaults to the primary color of the current theme.
  final Color? defaultIconColor;

  /// The shape of the button. Defaults to a CircleBorder.
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// The color of the overlay when the button is pressed.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The background color of the button.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The text style for the button's text (if applicable).
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// The color of the button's text (if applicable).
  final WidgetStateProperty<Color?>? foregroundColor;

  /// The color of the button's shadow.
  final WidgetStateProperty<Color?>? shadowColor;

  /// The surface tint color of the button.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// The elevation of the button.
  final WidgetStateProperty<double?>? elevation;

  /// The padding of the button.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// The minimum size of the button.
  final WidgetStateProperty<Size?>? minimumSize;

  /// The fixed size of the button.
  final WidgetStateProperty<Size?>? fixedSize;

  /// The maximum size of the button.
  final WidgetStateProperty<Size?>? maximumSize;

  /// The color of the icon.
  final WidgetStateProperty<Color?>? iconColor;

  /// The size of the icon.
  final WidgetStateProperty<double?>? iconSize;

  /// The border of the button.
  final WidgetStateProperty<BorderSide?>? side;

  /// The mouse cursor to display when hovering over the button.
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// The visual density of the button.
  final VisualDensity? visualDensity;

  /// The tap target size of the button.
  final MaterialTapTargetSize? tapTargetSize;

  /// The duration of the button's animations.
  final Duration? animationDuration;

  /// Whether to enable haptic feedback when the button is pressed.
  final bool? enableFeedback;

  /// The alignment of the button's contents.
  final AlignmentGeometry? alignment;

  /// The splash factory used to create the button's splash effect.
  final InteractiveInkFeatureFactory? splashFactory;

  /// A builder function for the button's background.
  final Widget Function(BuildContext, Set<WidgetState>, Widget?)? backgroundBuilder;

  /// A builder function for the button's foreground. 
  final Widget Function(BuildContext, Set<WidgetState>, Widget?)? foregroundBuilder;

  /// Creates a [InfoButton] widget.
  /// 
  /// {@macro info_button}
  const InfoButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.tip,
    this.defaultIcon,
    this.defaultIconSize,
    this.defaultIconColor,
    this.shape,
    this.overlayColor,
    this.backgroundColor,
    this.textStyle,
    this.foregroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.iconColor,
    this.iconSize,
    this.side,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
    this.backgroundBuilder,
    this.foregroundBuilder,
    this.iconButtonSize
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: iconButtonSize,
      style: ButtonStyle(
        backgroundColor: backgroundColor ?? WidgetStateProperty.resolveWith((states) {
          return Colors.transparent;
        }),
        overlayColor: overlayColor ?? WidgetStateProperty.resolveWith((states) {
          return CommonColors.instance.shimmerBase.withValues(alpha: .48);
        }),
        shape: shape ?? WidgetStateProperty.all(const CircleBorder()),
        backgroundBuilder: backgroundBuilder,
        foregroundBuilder: foregroundBuilder,
        visualDensity: visualDensity,
        mouseCursor: mouseCursor,
        tapTargetSize: tapTargetSize,
        animationDuration: animationDuration,
        enableFeedback: enableFeedback,
        alignment: alignment,
        splashFactory: splashFactory,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        fixedSize: fixedSize,
        side: side,
        padding: padding,
        iconColor: iconColor,
        iconSize: iconSize,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        foregroundColor: foregroundColor,
        textStyle: textStyle,
      ),
      tooltip: tip ?? "Learn more",
      icon: icon ?? Icon(
        defaultIcon ?? Icons.info_outline_rounded,
        color: defaultIconColor ?? Theme.of(context).primaryColor,
        size: Sizing.space(defaultIconSize ?? 22),
      ),
    );
  }
}