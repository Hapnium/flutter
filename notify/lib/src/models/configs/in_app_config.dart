import 'package:flutter/cupertino.dart';
import 'package:notify/src/services/implementations/in_app_notification.dart';

import '../../utilities/definitions.dart';

const _defaultAlignment = AlignmentDirectional.topEnd;
const _itemAnimationDuration = Duration(milliseconds: 600);
const _defaultWidth = 400.0;
const _defaultClipBehavior = Clip.none;

/// A configuration class for customizing the behavior and appearance of in-app notifications.
///
/// This class allows you to control the alignment, width, animation, margins, and other
/// aspects of how in-app notifications are displayed.
class InAppConfig {
  /// The alignment of the in-app notifications within the overlay.
  final AlignmentGeometry? alignment;

  /// The width of each in-app notification item.
  final double? itemWidth;

  /// The ClipBehavior of [AnimatedList], used as entry point for all [InAppNotification]s' widgets under the hood.
  /// The default value is [Clip.none].
  final Clip? clipBehavior;

  /// The duration of the animation for [InAppNotification]s.
  /// The default value is 600 milliseconds.
  final Duration? animationDuration;

  /// A builder function for creating custom animations for in-app notifications.
  final InAppNotificationAnimationBuilder? animationBuilder;

  /// Builder method for creating margin for InAppNotification Overlay.
  final InAppNotificationMarginBuilder? marginBuilder;

  /// Whether to apply the viewInsets to the margin of the Toastification Overlay.
  /// Basically, this is used to move the Toastification Overlay up or down when the keyboard is shown.
  /// So Toast overlay will not be hidden by the keyboard when the keyboard is shown.
  ///
  /// If set to true, MediaQuery.of(context).viewInsets will be added to the result of the [marginBuilder] method.
  final bool? applyMediaQueryViewInsets;

  /// Creates an [InAppConfig] instance.
  InAppConfig({
    this.alignment = _defaultAlignment,
    this.itemWidth = _defaultWidth,
    this.clipBehavior = _defaultClipBehavior,
    this.animationDuration = _itemAnimationDuration,
    this.animationBuilder,
    this.marginBuilder,
    this.applyMediaQueryViewInsets = true,
  });

  /// Creates a copy of this `InAppConfig` with the specified fields replaced with new values.
  ///
  /// This method is useful for creating modified versions of an `InAppConfig` while
  /// retaining the original object's values for fields not specified in the parameters.
  InAppConfig copyWith({
    AlignmentGeometry? alignment,
    double? itemWidth,
    Clip? clipBehavior,
    Duration? animationDuration,
    InAppNotificationAnimationBuilder? animationBuilder,
    InAppNotificationMarginBuilder? marginBuilder,
    bool? applyMediaQueryViewInsets,
  }) {
    return InAppConfig(
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