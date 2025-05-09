import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class NoItemFoundIndicator extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? customIcon;
  final Color? textColor;
  final VoidCallback? onRefresh;
  final Color? buttonColor;
  final double? opacity;
  final double? iconSize;
  final double? textSize;
  final double? spacing;
  final FontWeight? buttonWeight;
  final double? buttonSize;
  final String? buttonText;
  final EdgeInsets? buttonPadding;
  final OutlinedBorder? buttonShape;
  final Color? buttonOverlayColor;
  final Color? buttonBackgroundColor;
  final Color? buttonForegroundColor;

  const NoItemFoundIndicator({
    required this.message,
    this.icon,
    this.customIcon,
    this.textColor,
    this.onRefresh,
    this.buttonColor,
    this.opacity,
    this.iconSize,
    this.textSize,
    this.spacing,
    this.buttonWeight,
    this.buttonSize,
    this.buttonText,
    this.buttonPadding,
    this.buttonShape,
    this.buttonOverlayColor,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: spacing ?? 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(opacity: opacity ?? 0.2, child: _buildIcon(context)),
          TextBuilder.center(
            text: message,
            autoSize: false,
            size: textSize ?? Sizing.font(16),
            color: textColor ?? Theme.of(context).primaryColor,
          ),
          if(onRefresh.isNotNull) ...[
            TextButton(
              onPressed: onRefresh,
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(buttonOverlayColor ?? Theme.of(context).splashColor),
                backgroundColor: WidgetStateProperty.all(buttonBackgroundColor ?? Colors.transparent),
                foregroundColor: WidgetStateProperty.all(buttonForegroundColor ?? Colors.transparent),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(buttonShape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(buttonPadding ?? EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: buttonText ?? "Refresh",
                weight: buttonWeight ?? FontWeight.bold,
                size: buttonSize ?? Sizing.font(14),
                color: buttonColor ?? Theme.of(context).primaryColor,
              )
            )
          ]
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if(icon.isNotNull) {
      return Icon(icon, color: textColor ?? Theme.of(context).primaryColor, size: iconSize ?? 100);
    } else if(customIcon.isNotNull) {
      return customIcon!;
    } else {
      return Container();
    }
  }
}