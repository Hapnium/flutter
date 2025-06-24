import 'package:flutter/material.dart';
import 'package:smart/utilities.dart';
import 'package:hapnium/hapnium.dart';

import '../../typedefs.dart';

/// {@template button_view}
/// Represents a customizable button with an icon and additional properties.
/// 
/// {@endtemplate}
class ButtonView {
  /// The button icon.
  final IconData icon;

  /// The index associated with the button.
  final Integer index;

  /// The main title/header of the button.
  final String header;

  /// The body text of the button.
  final String body;

  /// A numerical value associated with the button (optional).
  final Double number;

  /// The primary color of the button.
  final Color color;

  /// A list of colors for gradient or multiple states.
  final ColorList colors;

  /// The navigation path associated with the button.
  final String path;

  /// The URL or path of an image to be displayed.
  final String image;

  /// A callback function triggered when the button is clicked.
  final OnActionInvoked? onClick;

  /// An optional child widget inside the button.
  final Widget? child;

  /// An optional image widget that can replace icon and image view
  final Widget? imageWidget;

  /// Creates a `ButtonView` instance.
  /// 
  /// {@macro button_view}
  ButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.header = "",
    this.body = "",
    this.number = 0.0,
    this.color = Colors.white,
    this.path = "/",
    this.onClick,
    this.child,
    this.image = "",
    this.colors = const [],
    this.imageWidget
  });
}