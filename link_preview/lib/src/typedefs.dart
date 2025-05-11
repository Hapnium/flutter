import 'package:flutter/cupertino.dart' show Animation, BuildContext, Widget;
import 'package:linkify/linkify.dart' show LinkableElement;

import 'models/link_preview_data.dart';

/// A function that builds a widget using the preview data.
typedef LinkPreviewWidgetBuilder = Widget Function(BuildContext context, LinkPreviewData? data);

/// A callback triggered when the preview data is successfully fetched.
typedef OnPreviewDataFetched = void Function(LinkPreviewData? data);

/// A function that builds a custom animation around the preview widget.
typedef LinkPreviewAnimationBuilder = Widget Function(Widget child, Animation<double> animation);

/// Callback clicked link
typedef LinkCallback = void Function(LinkableElement link);