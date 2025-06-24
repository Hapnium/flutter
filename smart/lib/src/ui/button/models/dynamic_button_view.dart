import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

/// {@template dynamic_button_view}
/// Represents a dynamic icon button for navigation.
/// 
/// {@endtemplate}
class DynamicButtonView {
  /// The default icon displayed when inactive.
  final IconData icon;

  /// The icon displayed when the button is active.
  final IconData active;

  /// The index associated with the button.
  final Integer index;

  /// The title of the button.
  final String title;

  /// The navigation path associated with the button.
  final String path;

  /// The image associated with the button.
  final String image;

  /// Creates a `DynamicButtonView` instance.
  /// 
  /// {@macro dynamic_button_view}
  DynamicButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.active = Icons.copy,
    this.title = "",
    this.path = "",
    this.image = ""
  });
}