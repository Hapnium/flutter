import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

/// {@template smart_share_item_config}
/// Configuration class for customizing the appearance and behavior of share items in a SmartShare widget.
///
/// This class encapsulates various styling options for individual share items,
/// allowing developers to easily customize their look and feel.
/// 
/// {@endtemplate}
class SmartShareItemConfig {
  /// Determines whether to display the label of the share item.
  ///
  /// Defaults to `true`.
  final bool showLabel;

  /// The color of the share item's icon or main visual element.
  final Color? color;

  /// The background color of the share item.
  final Color? backgroundColor;

  /// The color of the text within the share item.
  final Color? textColor;

  /// The color displayed when the share item is tapped.
  ///
  /// Defaults to `Colors.transparent`.
  final Color? tapColor;

  /// The border radius of the share item.
  final BorderRadiusGeometry? borderRadius;

  /// The border radius of the share item asset.
  final BorderRadiusGeometry? itemBorderRadius;

  /// The height of the share item.
  final double? height;

  /// The width of the share item.
  final double? width;

  /// The size of the share item's icon or main visual element.
  final double? itemSize;

  /// The size of the text within the share item.
  ///
  /// Defaults to `12`.
  final double? textSize;

  /// The font weight of the text within the share item.
  ///
  /// Defaults to `FontWeight.bold`.
  final FontWeight textWeight;

  /// The padding inside the share item.
  final EdgeInsetsGeometry? padding;

  /// The padding inside the share item asset.
  final EdgeInsetsGeometry? itemPadding;

  /// The gradient to be used as the background for the share item.
  final LinearGradient? gradient;

  /// Whether to use the gradient as the background for the share item.
  final Boolean useGradient;

  /// Creates a [SmartShareItemConfig] instance.
  ///
  /// {@macro smart_share_item_config}
  const SmartShareItemConfig({
    this.showLabel = true,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.tapColor = Colors.transparent,
    this.borderRadius,
    this.height,
    this.width,
    this.itemSize,
    this.textSize = 12,
    this.textWeight = FontWeight.bold,
    this.padding,
    this.itemBorderRadius,
    this.itemPadding,
    this.gradient,
    this.useGradient = false
  });

  /// Returns a new instance of [SmartShareItemConfig] with updated values.
  ///
  /// Only the provided parameters will be changed; others will remain the same.
  SmartShareItemConfig copyWith({
    bool? showLabel,
    Color? color,
    Color? backgroundColor,
    Color? textColor,
    Color? tapColor,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double? width,
    double? itemSize,
    double? textSize,
    FontWeight? textWeight,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? itemBorderRadius,
    EdgeInsetsGeometry? itemPadding,
    LinearGradient? gradient,
    Boolean? useGradient,
  }) {
    return SmartShareItemConfig(
      showLabel: showLabel ?? this.showLabel,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      tapColor: tapColor ?? this.tapColor,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      width: width ?? this.width,
      itemSize: itemSize ?? this.itemSize,
      textSize: textSize ?? this.textSize,
      textWeight: textWeight ?? this.textWeight,
      padding: padding ?? this.padding,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemPadding: itemPadding ?? this.itemPadding,
      gradient: gradient ?? this.gradient,
      useGradient: useGradient ?? this.useGradient,
    );
  }
}