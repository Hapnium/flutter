import 'package:flutter/material.dart';
import 'package:smart/utilities.dart';
import 'package:hapnium/hapnium.dart';

import '../../../styles/colors/common_colors.dart';
import '../../export.dart';
import 'controllers/permission_consent_controller.dart';

part 'permission_consent_state.dart';

/// A widget to display permission consent layout for the user.
///
/// The `PermissionConsentLayout` widget displays a card asking the user for permission to access certain features.
/// The card contains a message, required permissions, and a button to grant permissions.
class PermissionConsentLayout extends StatefulWidget {
  /// The widget displayed as the background content of the layout.
  final Widget child;

  /// A boolean indicating whether permissions have been granted.
  final Boolean isGranted;

  /// A boolean indicating whether the app is running on a web platform.
  final Boolean isWeb;

  /// The device sdk version.
  final Integer sdk;

  /// A string representing the app or service name requesting permissions.
  final String name;

  /// An image resource displayed within the consent card.
  final ImageResource image;

  /// A collection of permission names that the app requires.
  final StringCollection permissions;

  /// A handler function to request the required permissions.
  final PermissionAccessHandler requestAccess;

  /// An optional callback to execute when permissions are granted.
  final OnActionInvoked? onPermissionGranted;

  /// The background color of the consent card.
  final Color? cardColor;

  /// The color of the text displayed on the card.
  final Color? textColor;

  /// The color of the "Grant permissions" button.
  final Color? buttonColor;

  /// The color of the text on the "Grant permissions" button.
  final Color? buttonTextColor;

  /// The width of the image in the consent card.
  final Double? imageWidth;

  /// The height of the image in the consent card (default is 200).
  final Double imageHeight;

  /// The width of the button (default is `null`, meaning it will use full width).
  final Double? buttonWidth;

  /// The width of the consent card.
  final Double cardWidth;

  /// The distance from the bottom of the screen where the card is placed.
  final Double bottomCardPlacement;

  /// The distance from the left side of the screen where the card is placed.
  final Double? leftCardPlacement;

  /// The distance from the left side of the screen when resizing.
  final Double leftResizedCardPlacement;

  /// The distance from the right side of the screen where the card is placed.
  final Double rightCardPlacement;

  /// The distance from the right side of the screen when resizing.
  final Double rightResizedCardPlacement;

  /// The elevation (shadow) of the card.
  final Double cardElevation;

  /// The shape of the card.
  final ShapeBorder? cardShape;

  /// Padding inside the consent card content.
  final EdgeInsetsGeometry? cardContentPadding;

  /// A widget to display permission consent layout for the user.
  ///
  /// The `PermissionConsentLayout` widget displays a card asking the user for permission to access certain features.
  /// The card contains a message, required permissions, and a button to grant permissions.
  const PermissionConsentLayout({
    super.key,
    required this.child,
    required this.isGranted,
    required this.isWeb,
    required this.sdk,
    required this.requestAccess,
    this.onPermissionGranted,
    this.name = "Hapnium",
    required this.image,
    required this.permissions,
    this.cardColor,
    this.textColor,
    this.imageWidth,
    this.imageHeight = 200,
    this.buttonWidth,
    this.cardWidth = 440,
    this.leftCardPlacement,
    this.leftResizedCardPlacement = 6,
    this.bottomCardPlacement = 10,
    this.rightCardPlacement = 16,
    this.rightResizedCardPlacement = 6,
    this.cardElevation = 4,
    this.cardShape,
    this.cardContentPadding,
    this.buttonColor,
    this.buttonTextColor
  });

  @override
  State<PermissionConsentLayout> createState() => _PermissionConsentLayoutState();
}