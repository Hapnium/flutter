import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/utilities.dart';

import 'base_avatar.dart';

/// A smart avatar widget that extends [BaseAvatar] and intelligently displays:
///
/// * A user-provided image (when available).
/// * Initials derived from the user's full name, first name, or last name (when image is unavailable).
/// * A fallback avatar icon when no name or image is provided.
/// * A consistent background color based on the user's name for initials-based avatars.
///
/// This widget is ideal for user interfaces where avatars should adapt based on available data.
///
/// ### Usage:
/// ```dart
/// SmartAvatar(
///   radius: 24,
///   fullName: "Jane Doe",
///   imageUrl: "https://example.com/profile.jpg",
///   foregroundImageBuilder: (context, fallback) => NetworkImage("https://example.com/profile.jpg"),
/// )
/// ```
class SmartAvatar extends BaseAvatar {
  /// Optional full name of the user. Used for generating initials and consistent colors.
  final String? fullName;

  /// Optional first name of the user. Used if [fullName] is not provided.
  final String? firstName;

  /// Optional last name of the user. Used if [fullName] and [firstName] are not provided.
  final String? lastName;

  /// Optional text size for the initials text.
  final double? textSize;

  /// Optional text weight for the initials text.
  final FontWeight? textWeight;

  /// Optional text color for the initials text.
  final Color? textColor;

  /// Optional default icon to display when no name or image is provided.
  final IconData? defaultIcon;

  /// Creates a [SmartAvatar] widget that displays a user profile image, initials, or fallback icon.
  const SmartAvatar({
    super.key,
    required super.radius,
    super.foregroundImageBuilder,
    this.fullName,
    this.firstName,
    this.lastName,
    this.textSize,
    this.textWeight,
    this.textColor,
    this.defaultIcon,
    super.onClick,
    super.backgroundColorBuilder,
    super.foregroundColorBuilder,
    super.backgroundImageBuilder,
    super.onBackgroundImageError,
    super.onForegroundImageError,
    super.minRadius,
    super.maxRadius,
    super.isLightTheme,
    super.showLogs,
    super.isCircular,
    super.alignment,
    super.rectangleBorderRadius,
    super.rectangleDecoration,
    super.rectangleForegroundDecoration,
    super.foregroundImageDecorationBuilder,
    super.imageDecorationBuilder,
  });

  @override
  Widget? avatar(BuildContext context) {
    if(super.foregroundImageBuilder.isNotNull) {
      return null;
    }

    final backgroundColor = (fullName.isNotNull || firstName.isNotNull || lastName.isNotNull)
        ? SmartUtils.generateColorFromName(fullName ?? firstName ?? lastName ?? "")
        : const Color(0xFFEEEEEE);
    final Widget child = _buildInitialsOrFallback(fullName: fullName, firstName: firstName, lastName: lastName);

    Widget buildAvatar() {
      if(isCircular) {
        return CircleAvatar(
          radius: radius,
          minRadius: minRadius,
          maxRadius: maxRadius,
          foregroundColor: foregroundColorBuilder?.call(context),
          backgroundColor: backgroundColor,
          child: child,
        );
      } else {
        return Container(
          height: radius,
          width: radius,
          alignment: alignment ?? Alignment.center,
          decoration: rectangleDecoration ?? BoxDecoration(
            color: backgroundColor,
            borderRadius: rectangleBorderRadius ?? BorderRadius.circular(6),
          ),
          child: child,
        );
      }
    }

    return GestureDetector(onTap: onClick, child: buildAvatar());
  }

  /// Builds either the initials text or a fallback icon if no name is provided.
  Widget _buildInitialsOrFallback({String? fullName, String? firstName, String? lastName}) {
    final String initials = SmartUtils.getInitials(fullName: fullName, firstName: firstName, lastName: lastName);

    if (initials.isEmpty) {
      return Icon(defaultIcon ?? Icons.person, color: textColor ?? Colors.white54, size: textSize);
    }

    return Text(
      initials,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontWeight: textWeight ?? FontWeight.w600,
        fontSize: textSize ?? 14,
      ),
    );
  }
}