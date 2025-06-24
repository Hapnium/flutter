import 'package:flutter/cupertino.dart';

import '../config/definitions.dart';

const _defaultAlignment = AlignmentDirectional.topEnd;
const _itemAnimationDuration = Duration(milliseconds: 600);
const _defaultWidth = 400.0;
const _defaultClipBehavior = Clip.none;

/// {@template in_app_config}
/// Configuration for customizing in-app notification behavior and layout.
///
/// The `InAppConfig` class allows control over how in-app notifications are
/// displayed, including their position on the screen, size, animation behavior,
/// margins, and interaction with UI elements like the keyboard.
///
/// Use this class to tailor the look and feel of in-app notifications in your application.
///
/// ### Example usage:
///
/// ```dart
/// final config = InAppConfig(
///   alignment: Alignment.bottomCenter,
///   itemWidth: 300,
///   animationDuration: Duration(milliseconds: 400),
///   animationBuilder: (context, animation, child) {
///     return FadeTransition(opacity: animation, child: child);
///   },
/// );
/// ```
/// {@endtemplate}
class InAppConfiguration {
  /// The alignment of the in-app notification within the overlay.
  ///
  /// Default: [AlignmentDirectional.topEnd]
  final AlignmentGeometry? alignment;

  /// The width of the notification widget.
  ///
  /// Useful for setting a fixed width or adapting layout in responsive design.
  ///
  /// Default: `400.0`
  final double? itemWidth;

  /// Controls how the notification widget is clipped.
  ///
  /// Default: [Clip.none]
  final Clip? clipBehavior;

  /// The duration of the notification's entry/exit animation.
  ///
  /// Default: `Duration(milliseconds: 600)`
  final Duration? animationDuration;

  /// A custom builder function to define how the notification appears/disappears.
  ///
  /// Can be used to implement fade, slide, or other animated transitions.
  ///
  /// Default: `null` (uses default animation)
  final InAppNotificationAnimationBuilder? animationBuilder;

  /// A builder for generating margins around the notification widget.
  ///
  /// This allows spacing customization depending on the UI context.
  ///
  /// Default: `null`
  final InAppNotificationMarginBuilder? marginBuilder;

  /// Whether the notification should adjust its position based on the view insets (e.g., keyboard).
  ///
  /// Helps avoid overlay being hidden by the keyboard when shown.
  ///
  /// Default: `true`
  final bool? applyMediaQueryViewInsets;

  /// {@macro in_app_config}
  InAppConfiguration({
    this.alignment = _defaultAlignment,
    this.itemWidth = _defaultWidth,
    this.clipBehavior = _defaultClipBehavior,
    this.animationDuration = _itemAnimationDuration,
    this.animationBuilder,
    this.marginBuilder,
    this.applyMediaQueryViewInsets = true,
  });

  /// Creates a copy of the current config with selectively overridden values.
  ///
  /// This is useful when you want to preserve existing configuration
  /// and only update a few fields.
  ///
  /// {@macro in_app_config}
  InAppConfiguration copyWith({
    AlignmentGeometry? alignment,
    double? itemWidth,
    Clip? clipBehavior,
    Duration? animationDuration,
    InAppNotificationAnimationBuilder? animationBuilder,
    InAppNotificationMarginBuilder? marginBuilder,
    bool? applyMediaQueryViewInsets,
  }) {
    return InAppConfiguration(
      alignment: alignment ?? this.alignment,
      itemWidth: itemWidth ?? this.itemWidth,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      animationDuration: animationDuration ?? this.animationDuration,
      animationBuilder: animationBuilder ?? this.animationBuilder,
      marginBuilder: marginBuilder ?? this.marginBuilder,
      applyMediaQueryViewInsets: applyMediaQueryViewInsets ?? this.applyMediaQueryViewInsets,
    );
  }
}