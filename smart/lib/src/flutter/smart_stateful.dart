import 'package:flutter/material.dart' show BuildContext, StatefulWidget, Widget, Theme, ThemeData, State;
import 'package:flutter/foundation.dart' show nonVirtual;
import 'package:smart/responsive.dart' show ResponsiveUtil, ResponsiveConfig;

/// A base class for stateful widgets that integrates responsive utilities.
///
/// This widget provides a default [ResponsiveConfig] which can be overridden
/// by individual screens to define their own responsive behavior. Subclasses
/// should extend this class and pair it with a [SmartState].
abstract class SmartStateful extends StatefulWidget {
  const SmartStateful({super.key});

  /// Optional responsive settings that override the global [ResponsiveConfig].
  ///
  /// Override this property in subclasses to provide custom responsive breakpoints.
  final ResponsiveConfig settings = const ResponsiveConfig();
}

/// A base state class for [SmartStateful] that includes responsive and theme support.
///
/// Subclasses must override [create] instead of [build] to construct their UI
/// with access to [ResponsiveUtil] and [ThemeData].
abstract class SmartState<T extends SmartStateful> extends State<T> {
  /// Builds the widget using a responsive utility and theme.
  ///
  /// Do not override this method. Use [create] to define the layout instead.
  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return create(context, ResponsiveUtil(context, config: widget.settings), Theme.of(context));
  }

  /// A method to construct the UI with responsive and theme context.
  ///
  /// Must be implemented in subclasses to define the screen layout.
  Widget create(BuildContext context, ResponsiveUtil responsive, ThemeData theme);
}