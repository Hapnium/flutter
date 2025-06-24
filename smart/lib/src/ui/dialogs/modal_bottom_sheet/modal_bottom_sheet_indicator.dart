import 'package:flutter/material.dart';
import 'package:smart/extensions.dart';
import 'package:smart/src/styles/colors/common_colors.dart';
import 'package:smart/utilities.dart';

import '../../button/info_button.dart';

/// {@template modal_bottom_sheet_indicator}
/// A visual indicator for a modal bottom sheet.
/// 
/// This widget provides a customizable indicator that can be used to 
/// visually cue users to the presence of a modal bottom sheet. 
/// It can optionally display an `InfoButton` for user interaction.
/// 
/// **Parameters:**
/// 
/// * **onTap:** The callback function to be executed when the indicator is tapped.
/// * **color:** The background color of the indicator.
/// * **overlayColor:** The color of the overlay when the indicator is pressed.
/// * **backgroundColor:** The background color of the `InfoButton`.
/// * **icon:** The icon to display within the `InfoButton`.
/// * **size:** The size of the indicator.
/// * **padding:** The padding of the indicator.
/// * **margin:** The margin of the indicator.
/// * **radius:** The border radius of the indicator.
/// * **showButton:** Whether to display an `InfoButton` within the indicator.
/// 
/// {@endtemplate}
class ModalBottomSheetIndicator extends StatelessWidget {
  /// The callback function to be executed when the indicator is tapped.
  final VoidCallback? onTap;

  /// The background color of the indicator.
  final Color? color;

  /// The color of the overlay when the indicator is pressed.
  final Color? overlayColor;

  /// The background color of the `InfoButton`.
  final Color? backgroundColor;

  /// The icon to display within the `InfoButton`.
  final IconData? icon;

  /// The size of the indicator.
  final Size? size;

  /// The padding of the indicator.
  final double? padding;

  /// The margin of the indicator.
  final double? margin;

  /// The border radius of the indicator.
  final double? radius;

  /// Whether to display an `InfoButton` within the indicator.
  final bool showButton;

  /// Creates a [ModalBottomSheetIndicator] widget.
  /// 
  /// {@macro modal_bottom_sheet_indicator}
  const ModalBottomSheetIndicator({
    super.key,
    this.onTap,
    this.color,
    this.overlayColor,
    this.backgroundColor,
    this.icon,
    this.size,
    this.padding,
    this.margin,
    this.radius,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showButton) {
      return Center(
        child: InfoButton(
          onPressed: onTap ?? (() => Navigator.pop(context)),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            return overlayColor ?? CommonColors.instance.darkTheme2.lighten(58);
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return backgroundColor ?? CommonColors.instance.darkTheme2.lighten(18);
          }),
          defaultIconColor: color ?? CommonColors.instance.darkTheme2,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.resolveWith((state) => size ?? Size(20, 20)),
          defaultIcon: icon ?? Icons.keyboard_arrow_down_rounded,
        ),
      );
    } else {
      return Center(
        child: Container(
          padding: EdgeInsets.all(Sizing.space(padding ?? 2)),
          margin: EdgeInsets.all(Sizing.space(margin ?? 10)),
          alignment: Alignment.center,
          width: size?.width ?? 60,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
        ),
      );
    }
  }
}