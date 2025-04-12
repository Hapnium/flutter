import 'package:flutter/material.dart';
import 'package:smart/utilities.dart';
import 'package:hapnium/hapnium.dart';

import '../../../styles/colors/common_colors.dart';
import '../../export.dart';
import 'controllers/cookie_consent_controller.dart';

part 'cookie_consent_state.dart';

/// A widget to display cookie consent layout for the user.
///
/// The `CookieConsentLayout` widget displays a card to ask the user for cookie consent.
/// It provides options for accepting, rejecting, and setting cookie preferences.
class CookieConsentLayout extends StatefulWidget {
  /// The widget displayed in the background of the layout.
  final Widget child;

  /// An object representing the cookie consent state.
  final CookieConsent cookie;

  /// A boolean indicating whether the app is running on a web platform.
  final Boolean isWeb;

  /// A callback handler for when the user rejects cookies.
  final CookieConsentHandler onCookieRejected;

  /// A callback handler for when the user accepts cookies.
  final CookieConsentHandler onCookieAccepted;

  /// The color of the consent card.
  final Color? cardColor;

  /// The color of the text displayed on the card.
  final Color? textColor;

  /// The color of the "Accept" button.
  final Color? acceptButtonColor;

  /// The color of the text on the "Accept" button.
  final Color? acceptButtonTextColor;

  /// The color of the "Reject" button.
  final Color? rejectButtonColor;

  /// The color of the text on the "Reject" button.
  final Color? rejectButtonTextColor;

  /// The color of the "Settings" button.
  final Color? settingsButtonColor;

  /// The color of the text on the "Settings" button.
  final Color? settingsButtonTextColor;

  /// The color for the hint text.
  final Color? hintColor;

  /// The width of the buttons.
  final Double? buttonWidth;

  /// The width of the cookie consent card.
  final Double cardWidth;

  /// The distance from the bottom for the card's position.
  final Double bottomCardPlacement;

  /// The distance from the left side of the screen for card placement.
  final Double? leftCardPlacement;

  /// The left position when the card is resized.
  final Double leftResizedCardPlacement;

  /// The distance from the right side of the screen for card placement.
  final Double rightCardPlacement;

  /// The right position when the card is resized.
  final Double rightResizedCardPlacement;

  /// The elevation (shadow) of the card.
  final Double cardElevation;

  /// The shape of the card.
  final ShapeBorder? cardShape;

  /// Padding inside the card content.
  final EdgeInsetsGeometry? cardContentPadding;

  /// A function to handle visits to the cookie policy URL.
  final UrlHandler? visitCookiePolicy;

  /// A widget to display cookie consent layout for the user.
  ///
  /// The `CookieConsentLayout` widget displays a card to ask the user for cookie consent.
  /// It provides options for accepting, rejecting, and setting cookie preferences.
  const CookieConsentLayout({
    super.key,
    required this.child,
    required this.cookie,
    required this.isWeb,
    required this.onCookieRejected,
    required this.onCookieAccepted,
    this.cardColor,
    this.textColor,
    this.buttonWidth,
    this.cardWidth = 540,
    this.leftCardPlacement,
    this.leftResizedCardPlacement = 6,
    this.bottomCardPlacement = 10,
    this.rightCardPlacement = 16,
    this.rightResizedCardPlacement = 6,
    this.cardElevation = 4,
    this.cardShape,
    this.cardContentPadding,
    this.acceptButtonColor,
    this.acceptButtonTextColor,
    this.rejectButtonColor,
    this.rejectButtonTextColor,
    this.settingsButtonColor,
    this.settingsButtonTextColor,
    this.hintColor,
    this.visitCookiePolicy,
  });

  @override
  State<CookieConsentLayout> createState() => _CookieConsentLayoutState();
}