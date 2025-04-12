import 'package:flutter/cupertino.dart';

/// Represents a list of colors.
///
/// This typedef defines a list of `Color` objects.
typedef ColorList = List<Color>;

/// A function that builds a color based on the given context.
///
/// The `ColorBuilder` typedef defines a function signature for
/// functions that return a `Color` object based on the provided
/// `BuildContext`. This allows for dynamic color determination
/// based on the current theme or other contextual factors.
typedef ColorBuilder = Color Function(BuildContext context);