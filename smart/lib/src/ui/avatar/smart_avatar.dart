import 'package:flutter/material.dart';

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
  /// Optional user image URL to determine if an image is available.
  final String? imageUrl;

  /// Optional full name of the user. Used for generating initials and consistent colors.
  final String? fullName;

  /// Optional first name of the user. Used if [fullName] is not provided.
  final String? firstName;

  /// Optional last name of the user. Used if [fullName] and [firstName] are not provided.
  final String? lastName;

  /// Creates a [SmartAvatar] widget that displays a user profile image, initials, or fallback icon.
  const SmartAvatar({
    super.key,
    required super.radius,
    required super.foregroundImageBuilder,
    this.imageUrl,
    this.fullName,
    this.firstName,
    this.lastName,
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
    super.imageDecorationBuilder
  });

  @override
  Widget? avatar(BuildContext context) {
    if(imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return null;
    }

    final backgroundColor = (fullName != null || firstName != null || lastName != null)
        ? _generateColorFromName(fullName ?? firstName ?? lastName ?? "")
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

  /// Generates a consistent background color from a name string.
  static Color _generateColorFromName(String name) {
    if (name.isEmpty) return Colors.grey.shade400;
    final hash = name.hashCode;
    final hue = (hash % 360).toDouble();

    return HSLColor.fromAHSL(1.0, hue, 0.5, 0.65).toColor();
  }

  /// Builds either the initials text or a fallback icon if no name is provided.
  static Widget _buildInitialsOrFallback({String? fullName, String? firstName, String? lastName}) {
    final String initials = _getInitials(fullName: fullName, firstName: firstName, lastName: lastName);

    if (initials.isEmpty) {
      return const Icon(Icons.person, color: Colors.white54);
    }

    return Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  /// Extracts initials from full name, or falls back to first/last name.
  static String _getInitials({String? fullName, String? firstName, String? lastName}) {
    if (fullName != null && fullName.trim().isNotEmpty) {
      final parts = fullName.trim().split(RegExp(r'\s+'));
      return parts.length >= 2 ? parts[0][0].toUpperCase() + parts[1][0].toUpperCase() : parts[0][0].toUpperCase();
    }

    if (firstName != null && firstName.trim().isNotEmpty) {
      return firstName.trim()[0].toUpperCase();
    }

    if (lastName != null && lastName.trim().isNotEmpty) {
      return lastName.trim()[0].toUpperCase();
    }

    return "";
  }
}