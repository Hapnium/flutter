import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

/// Represents a dynamic icon button for navigation.
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
  DynamicButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.active = Icons.copy,
    this.title = "",
    this.path = "",
    this.image = ""
  });
}