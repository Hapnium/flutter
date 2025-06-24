import 'package:flutter/material.dart' show BuildContext, StatelessWidget, Widget, Theme, ThemeData;
import 'package:flutter/foundation.dart' show nonVirtual;
import 'package:smart/responsive.dart' show ResponsiveUtil, ResponsiveConfig;

/// {@template smart_stateless}
/// Base class for stateless widgets using [ResponsiveUtil].
/// 
/// {@endtemplate}
abstract class SmartStateless extends StatelessWidget {
  /// {@macro smart_stateless}
  const SmartStateless({super.key});

  /// Optional responsive settings that override [ResponsiveConfig]'s global settings.
  final ResponsiveConfig settings = const ResponsiveConfig();

  /// Builds the widget by invoking the `create` method with a [ResponsiveUtil].
  ///
  /// This method should not be overridden. Instead, override [create].
  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return create(context, ResponsiveUtil(context, config: settings), Theme.of(context));
  }

  /// A method to construct the body of the screen.
  ///
  /// Must be implemented in subclasses to define the view layout.
  Widget create(BuildContext context, ResponsiveUtil responsive, ThemeData theme);
}