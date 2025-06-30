import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

import 'pull_to_refresh_type.dart';

/// A customizable pull-to-refresh widget that adapts to different platforms.
///
/// This widget wraps the platform-appropriate refresh indicator:
/// - **Android:** Uses [RefreshIndicator] (Material Design)
/// - **iOS:** Uses [CupertinoSliverRefreshControl] (Cupertino-style)
/// - **Web/Desktop:** Defaults to Material design unless specified.
///
/// The user can also specify a custom loading indicator icon.
class PullToRefresh extends StatelessWidget {
  final bool _isAdaptive;

  /// Callback function triggered when the user pulls to refresh.
  final Supplier<void>? onRefreshed;

  /// Callback future function triggered when the user pulls to refresh.
  final Supplier<Future<void>>? onAsyncRefreshed;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// Defines how this [RefreshIndicator] can be triggered when users overscroll.
  ///
  /// The [RefreshIndicator] can be pulled out in two cases,
  /// 1, Keep dragging if the scrollable widget at the edge with zero scroll position
  ///    when the drag starts.
  /// 2, Keep dragging after overscroll occurs if the scrollable widget has
  ///    a non-zero scroll position when the drag starts.
  ///
  /// If this is [RefreshIndicatorTriggerMode.anywhere], both of the cases above can be triggered.
  ///
  /// If this is [RefreshIndicatorTriggerMode.onEdge], only case 1 can be triggered.
  ///
  /// Defaults to [RefreshIndicatorTriggerMode.onEdge].
  final RefreshIndicatorTriggerMode triggerMode;

  /// The color of the refresh indicator.
  final Color? color;

  /// The background color of the refresh indicator.
  final Color? backgroundColor;

  /// The widget to be refreshed.
  final Widget child;

  /// Determines whether to use Material, Cupertino, or a custom refresh view.
  ///
  /// If `null`, the widget will automatically select the best view based on the OS.
  final PullToRefreshType? refreshType;

  /// A custom indicator widget to replace the default ones.
  ///
  /// If provided, this widget will be used instead of the default Material or Cupertino indicators.
  final Widget? customIndicator;

  /// The displacement distance from the top of the scrollable content before triggering the refresh.
  final Double displacement;

  /// The stroke width of the refresh indicator (for Material style).
  final Double strokeWidth;

  /// The edge offset for where the indicator starts.
  final Double edgeOffset;

  /// Defines the elevation of the underlying [RefreshIndicator].
  ///
  /// Defaults to 2.0.
  final double elevation;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  ///
  /// This will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel]
  /// if it is null.
  final String? semanticsLabel;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsValue}
  final String? semanticsValue;

  /// Creates a [PullToRefresh] widget.
  ///
  /// - [onRefreshed] or [onAsyncRefreshed] is required to handle refresh logic.
  /// - [refreshType] allows manual control of the refresh style.
  /// - [customIndicator] can be used to provide a fully custom refresh UI.
  PullToRefresh({
    super.key,
    this.onRefreshed,
    this.onAsyncRefreshed,
    required this.child,
    this.color,
    this.backgroundColor,
    this.refreshType,
    this.displacement = 40.0,
    this.strokeWidth = 2.0,
    this.edgeOffset = 0.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : customIndicator = null, _isAdaptive = false, assert(elevation >= 0.0);

  /// Creates an adaptive [PullToRefresh] widget which renders based on the current platform.
  ///
  /// - [onRefreshed] or [onAsyncRefreshed] is required to handle refresh logic.
  /// - [refreshType] allows manual control of the refresh style.
  /// - [customIndicator] can be used to provide a fully custom refresh UI.
  PullToRefresh.adaptive({
    super.key,
    this.onRefreshed,
    this.onAsyncRefreshed,
    required this.child,
    this.color,
    this.backgroundColor,
    this.refreshType,
    this.displacement = 40.0,
    this.strokeWidth = 2.0,
    this.edgeOffset = 0.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : _isAdaptive = true, customIndicator = null, assert(elevation >= 0.0);

  /// Creates a custom [PullToRefresh] widget with a fully custom refresh view.
  ///
  /// - [onRefreshed] or [onAsyncRefreshed] is required to handle refresh logic.
  /// - [refreshType] allows manual control of the refresh style.
  /// - [customIndicator] can be used to provide a fully custom refresh UI.
  PullToRefresh.custom({
    super.key,
    this.onRefreshed,
    this.onAsyncRefreshed,
    required this.child,
    this.color,
    this.backgroundColor,
    required this.customIndicator,
    this.displacement = 40.0,
    this.strokeWidth = 2.0,
    this.edgeOffset = 0.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.elevation = 2.0,
  }) : refreshType = null, _isAdaptive = false, assert(elevation >= 0.0);

  @override
  Widget build(BuildContext context) {
    assert(onRefreshed != null || onAsyncRefreshed != null, "onRefreshed and onAsyncRefreshed cannot be null at the same time");

    // Determine the onComplete function based on sync or async refresh callbacks
    Future<void> completer() => onRefreshed.isNotNull
        ? Future.sync(onRefreshed!)
        : onAsyncRefreshed!();

    if (customIndicator != null) {
      // If the user provides a custom indicator, wrap it in a NotificationListener
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentBefore.equals(0) && notification is OverscrollNotification) {
            completer();
          }
          return false;
        },
        child: Stack(
          children: [
            child,
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: customIndicator!,
            ),
          ],
        ),
      );
    }

    if (_isAdaptive) {
      return RefreshIndicator.adaptive(
        color: color ?? Theme.of(context).primaryColor,
        backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        displacement: displacement,
        strokeWidth: strokeWidth,
        edgeOffset: edgeOffset,
        onRefresh: completer,
        elevation: elevation,
        notificationPredicate: notificationPredicate,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        triggerMode: triggerMode,
        child: child,
      );
    }

    // Default to Material-style refresh indicator (Android, Web, Desktop)
    return RefreshIndicator(
      color: color ?? Theme.of(context).primaryColor,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      displacement: displacement,
      strokeWidth: strokeWidth,
      edgeOffset: edgeOffset,
      onRefresh: completer,
      elevation: elevation,
      notificationPredicate: notificationPredicate,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      triggerMode: triggerMode,
      child: child,
    );
  }
}