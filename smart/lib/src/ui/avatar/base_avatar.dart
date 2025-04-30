import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/assets.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/utilities.dart';
import 'package:tracing/tracing.dart';

import '../export.dart';

/// A base class for creating circular avatars with customizable appearance and behavior.
///
/// This abstract class provides a foundation for building various types of avatars,
/// such as user profile pictures, initials avatars, and more. It offers
/// extensive customization options, including:
///
/// * **Size:** Control the size of the avatar using `radius`, `minRadius`, and `maxRadius`.
/// * **Background:** Customize the background color and image.
/// * **Foreground:** Customize the foreground image (e.g., profile picture).
/// * **Error Handling:** Handle image loading errors gracefully.
/// * **Click ability:** Define an `onClick` callback for user interactions.
/// * **Theming:** Adapt to the current theme with `isLightTheme`.
/// * **Logging:** Enable/disable logging for image loading errors.
abstract class BaseAvatar extends StatelessWidget {
  /// The size of the avatar, expressed as the radius (half the diameter).
  ///
  /// If [radius] is specified, then neither [minRadius] nor [maxRadius] may be
  /// specified. Specifying [radius] is equivalent to specifying a [minRadius]
  /// and [maxRadius], both with the value of [radius].
  ///
  /// If neither [minRadius] nor [maxRadius] are specified, defaults to 20
  /// logical pixels. This is the appropriate size for use with
  /// [ListTile.leading].
  ///
  /// Changes to the [radius] are animated (including changing from an explicit
  /// [radius] to a [minRadius]/[maxRadius] pair or vice versa).
  final double radius;

  /// Action to be performed on avatar click.
  final VoidCallback? onClick;

  /// The color with which to fill the avatar. Changing the background
  /// color will cause the avatar to animate to the new color.
  ///
  /// If a [backgroundColorBuilder] is not specified and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.primaryContainer] will be used, otherwise the theme's
  /// [ThemeData.primaryColorLight] is used with dark foreground colors, and
  /// [ThemeData.primaryColorDark] with light foreground colors.
  final ColorBuilder? backgroundColorBuilder;

  /// The default text color for text in the avatar.
  ///
  /// Defaults to the primary text theme color if no [backgroundColorBuilder] is
  /// specified.
  ///
  /// If a [foregroundColorBuilder] is not specified and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.onPrimaryContainer] will be used, otherwise the theme's
  /// [ThemeData.primaryColorLight] for dark background colors, and
  /// [ThemeData.primaryColorDark] for light background colors.
  final ColorBuilder? foregroundColorBuilder;

  /// The background image of the avatar. Changing the background
  /// image will cause the avatar to animate to the new image.
  ///
  /// Typically used as a fallback image for [foregroundImageBuilder].
  ///
  /// If the [CircleAvatar] is to have the user's initials, use [child] instead.
  final ImageResourceBuilder? backgroundImageBuilder;

  /// The foreground image of the avatar.
  ///
  /// Typically used as profile image. For fallback use [backgroundImageBuilder].
  final ImageResourceBuilder foregroundImageBuilder;

  /// An optional error callback for errors emitted when loading
  /// [backgroundImageBuilder].
  final ImageErrorListener? onBackgroundImageError;

  /// An optional error callback for errors emitted when loading
  /// [foregroundImageBuilder].
  final ImageErrorListener? onForegroundImageError;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? maxRadius;

  /// Whether the current theme is light or dark.
  final bool isLightTheme;

  /// Enables or disables logging for image loading errors.
  final bool showLogs;

  /// The child for extra details like the user's initials
  final Widget? child;

  /// Constructor for `BaseAvatar`. The `foregroundImageBuilder` is required for extensions.
  const BaseAvatar({
    super.key,
    required this.foregroundImageBuilder,
    required this.radius,
    this.backgroundColorBuilder,
    this.onClick,
    this.foregroundColorBuilder,
    this.backgroundImageBuilder,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.minRadius,
    this.maxRadius,
    this.isLightTheme = false,
    this.showLogs = false,
    this.child
  });

  /// Builds the CircleAvatar with customizable behavior.
  @override
  @protected
  @nonVirtual
  Widget build(BuildContext context) {
    return avatar(context) ?? _default(context);
  }

  Widget _default(BuildContext context) {
    String fallback = isLightTheme ? SmartAnimAssets.darkWallpaper : SmartAnimAssets.lightWallpaper;

    final ImageProvider foreground = foregroundImageBuilder(context, fallback);
    final ImageErrorListener foregroundError = onForegroundImageError ?? (Object exception, StackTrace? stackTrace) {
      if (showLogs) {
        console.log("${exception} || ${stackTrace}", from: "[BASE AVATAR - onForegroundImageError]");
      }
    };

    final ImageProvider? background = backgroundImageBuilder.isNotNull ? backgroundImageBuilder!(context, fallback) : null;
    final ImageErrorListener? backgroundError = background.isNotNull
        ? onBackgroundImageError ?? (Object exception, StackTrace? stackTrace) {
      if (showLogs) {
        console.log("${exception} || ${stackTrace}", from: "[BASE AVATAR - onBackgroundImageError]");
      }
    }
        : null;

    return GestureDetector(
      onTap: onClick,
      child: CircleAvatar(
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
        foregroundColor: foregroundColorBuilder.isNotNull ? foregroundColorBuilder!(context) : null,
        backgroundColor: backgroundColorBuilder.isNotNull ? backgroundColorBuilder!(context) : Theme.of(context).unselectedWidgetColor,
        foregroundImage: foreground,
        backgroundImage: background,
        onForegroundImageError: foregroundError,
        onBackgroundImageError: backgroundError,
        child: child,
      ),
    );
  }

  @optionalTypeArgs
  Widget? avatar(BuildContext context) => null;
}