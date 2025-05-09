import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart' show OnErrorReceived;

class MultimediaDoneButtonConfiguration {
  final Widget? widget;
  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? overlayColor;
  final OutlinedBorder? shape;
  final EdgeInsets? padding;

  MultimediaDoneButtonConfiguration({
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

class MultimediaIconConfiguration {
  final IconData? grid;
  final IconData? list;
  final Color? color;
  final double? size;

  MultimediaIconConfiguration({this.size, this.color, this.grid, this.list});
}

class MultimediaGridFilterConfiguration {
  final double? spacing;
  final double? runSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final OutlinedBorder? buttonShape;
  final double? buttonTextSize;
  final Color? buttonColor;
  final EdgeInsetsGeometry? padding;
  final WrapAlignment? runAlignment;
  final WrapCrossAlignment? crossAlignment;

  MultimediaGridFilterConfiguration({
    this.spacing,
    this.runSpacing,
    this.buttonPadding,
    this.buttonShape,
    this.buttonTextSize,
    this.buttonColor,
    this.padding,
    this.runAlignment,
    this.crossAlignment
  });
}

class MultimediaNoItemConfiguration {
  final Widget? iconWidget;
  final String? message;
  final IconData? icon;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;
  final double? spacing;
  final double? opacity;

  MultimediaNoItemConfiguration({
    this.iconWidget,
    this.message,
    this.icon,
    this.textColor,
    this.iconSize,
    this.textSize,
    this.spacing,
    this.opacity
  });
}

class MultimediaNoPermissionConfiguration {
  final Widget? iconWidget;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;
  final double? spacing;
  final Color? buttonColor;
  final FontWeight? buttonWeight;
  final double? buttonSize;
  final EdgeInsets? buttonPadding;
  final RoundedRectangleBorder? buttonShape;
  final Color? buttonOverlayColor;
  final double? opacity;
  final Color? buttonBackgroundColor;
  final Color? buttonForegroundColor;
  final IconData? icon;
  final String? message;
  final String? buttonText;

  MultimediaNoPermissionConfiguration({
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
    this.buttonText
  });
}

class MultimediaFileManagerConfiguration {
  final Color? color;
  final String? text;
  final String? body;
  final VoidCallback? onPressed;
  final IconData? icon;
  final OnErrorReceived? onError;

  MultimediaFileManagerConfiguration({this.color, this.text, this.body, this.onPressed, this.icon, this.onError});
}