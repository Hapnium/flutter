import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/utilities.dart';

import '../../export.dart';

const SafeAreaConfig _defaultSFConfig = SafeAreaConfig(
  top: false
);

/// {@template modal_bottom_sheet}
/// A modal bottom sheet with a curved top for a more visually appealing design.
/// 
/// This widget displays a modal bottom sheet with rounded top corners.
/// It provides options to customize the background color, padding,
/// border radius, and height of the sheet.
/// 
/// {@endtemplate}
class ModalBottomSheet extends StatelessWidget {
  /// The background color of the modal sheet. Defaults to the app's bottomAppBarTheme color.
  final Color? backgroundColor;

  /// The widget to be displayed inside the modal sheet.
  final Widget child;

  /// Whether to include safe area padding at the top of the sheet. Defaults to false.
  final SafeAreaConfigBuilder? useSafeArea;

  /// Whether to include safe area padding at the top of the sheet. Defaults to false.
  /// 
  /// @deprecated
  @Deprecated('safeArea is now deprecated, please use `useSafeArea`')
  final Boolean safeArea;

  /// This specifies that when `sheetPadding` is not null, default border radius will be applied
  /// 
  /// Can be overriden by making this false
  final Boolean useDefaultBorderRadius;

  /// The border radius of the top corners of the modal sheet. Defaults to a circular radius of 24 for the top corners only.
  /// If margin is set, a borderRadius of BorderRadius.circular(12) will be used instead.
  final BorderRadiusGeometry? borderRadius;

  /// The padding applied to the content area of the modal sheet. Defaults to symmetrical padding of 15dp vertically and 10dp horizontally.
  final EdgeInsetsGeometry? padding;

  /// The padding applied to the modal sheet. Defaults to EdgeInsets.zero.
  /// If padding is set, the borderRadius will be a uniform BorderRadius.circular(12) instead of the default.
  final EdgeInsetsGeometry? sheetPadding;

  /// The height of the modal sheet.
  final Double? height;

  /// UI Config to override other settings
  /// 
  /// Defaults to null
  final UiConfig? uiConfig;

  /// A modal bottom sheet with a curved top for a more visually appealing design.

  /// This widget displays a modal bottom sheet with rounded top corners.
  /// It provides options to customize the background color, padding,
  /// border radius, and height of the sheet.
  /// 
  /// {@macro modal_bottom_sheet}
  const ModalBottomSheet({
    super.key,
    this.backgroundColor,
    required this.child,
    this.useSafeArea,
    this.borderRadius,
    this.padding,
    this.sheetPadding,
    this.height,
    this.uiConfig,

    @Deprecated('safeArea is now deprecated, please use `useSafeArea`')
    this.safeArea = false,
    
    this.useDefaultBorderRadius = true
  });

  @override
  Widget build(BuildContext context) {
    if(uiConfig.isNotNull) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: uiConfig?.statusBarColor,
          systemNavigationBarColor: uiConfig?.systemNavigationBarColor,
          statusBarIconBrightness: uiConfig?.statusBarIconBrightness,
          systemNavigationBarIconBrightness: uiConfig?.systemNavigationBarIconBrightness,
          statusBarBrightness: uiConfig?.statusBarBrightness,
          systemNavigationBarDividerColor: uiConfig?.systemNavigationBarDividerColor,
          systemNavigationBarContrastEnforced: uiConfig?.systemNavigationBarContrastEnforced,
          systemStatusBarContrastEnforced: uiConfig?.systemStatusBarContrastEnforced
        ),
        child: _build(context)
      );
    } else {
      return _build(context);
    }
  }

  SafeArea _build(BuildContext context) {
    Radius radius = Radius.circular(24);
    SafeAreaConfig config = useSafeArea.isNotNull ? useSafeArea!(_defaultSFConfig) : _defaultSFConfig;

    return SafeArea(
      top: config.top,
      bottom: config.bottom,
      left: config.left,
      right: config.right,
      child: Padding(
        padding: sheetPadding ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: sheetPadding != null && useDefaultBorderRadius
            ? BorderRadius.circular(12)
            : borderRadius ?? BorderRadius.only(topLeft: radius, topRight: radius),
          child: Container(
            height: height,
            color: backgroundColor ?? Theme.of(context).bottomAppBarTheme.color,
            padding: padding ?? EdgeInsets.symmetric(vertical: Sizing.space(15), horizontal: Sizing.space(10)),
            child: child
          )
        ),
      ),
    );
  }
}