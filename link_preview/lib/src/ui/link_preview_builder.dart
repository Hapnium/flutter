import 'package:flutter/material.dart';

import '../link_preview.dart';
import '../models/link_preview_data.dart';
import '../typedefs.dart' show LinkPreviewAnimationBuilder, LinkPreviewWidgetBuilder, OnPreviewDataFetched;

/// A widget that fetches link preview metadata and builds a widget using the provided builder.
///
/// It optionally supports animated expansion and loading widgets. You can also provide
/// your own animation builder if the default animation doesn't fit your use case.
class LinkPreviewBuilder extends StatefulWidget {
  /// The URL to preview.
  final String link;

  /// Builds the final widget using the fetched preview data.
  final LinkPreviewWidgetBuilder builder;

  /// Widget builder displayed while fetching preview data.
  final WidgetBuilder? loadingBuilder;

  /// Duration for the default expand animation. Defaults to 300ms.
  final Duration? animationDuration;

  /// Enables expand animation. Defaults to false.
  final bool? enableAnimation;

  /// Allows you to define a custom animation wrapper around the result widget.
  ///
  /// If not provided, a default [SizeTransition] is used.
  final LinkPreviewAnimationBuilder? animatedBuilder;

  /// Optional CORS proxy for web use. Not guaranteed to work in all cases.
  final String? corsProxy;

  /// User agent to send as a GET header when requesting the preview data.
  ///
  /// User-Agent to be used in the HTTP request to the link
  /// Default: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
  final String? userAgent;

  /// Maximum time to wait for a preview request before timing out. Defaults to 5 seconds.
  final Duration? requestTimeout;

  /// Duration for the cache. Defaults to 24 hours.
  final Duration? cacheDuration;

  /// Callback triggered when preview data is fetched.
  final OnPreviewDataFetched? onPreviewDataFetched;

  const LinkPreviewBuilder({
    super.key,
    required this.link,
    required this.builder,
    this.loadingBuilder,
    this.animationDuration,
    this.enableAnimation,
    this.animatedBuilder,
    this.corsProxy,
    this.userAgent,
    this.requestTimeout,
    this.onPreviewDataFetched,
    this.cacheDuration = const Duration(hours: 24)
  });

  @override
  State<LinkPreviewBuilder> createState() => _LinkPreviewBuilderState();
}

class _LinkPreviewBuilderState extends State<LinkPreviewBuilder> with SingleTickerProviderStateMixin {
  bool isFetchingPreviewData = false;
  bool shouldAnimate = false;

  late final Animation<double> _animation;
  late final AnimationController _controller;

  LinkPreviewData? _previewData;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    _fetchData(widget.link);
  }

  @override
  void didUpdateWidget(covariant LinkPreviewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.link != oldWidget.link) {
      _fetchData(widget.link);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Determines whether animation should be run.
  bool get runAnimation => widget.enableAnimation == true && shouldAnimate;

  /// Fetches preview data for the given link.
  Future<void> _fetchData(String link) async {
    setState(() {
      isFetchingPreviewData = true;
    });

    final previewData = await LinkPreview.get(
      link,
      cacheDuration: widget.cacheDuration,
      proxy: widget.corsProxy,
      requestTimeout: widget.requestTimeout,
      userAgent: widget.userAgent,
    );

    setState(() {
      shouldAnimate = true;
      _previewData = previewData;
    });

    _controller.reset();
    _controller.forward();

    await _handlePreviewDataFetched(previewData);
  }

  Future<void> _handlePreviewDataFetched(LinkPreviewData? previewData) async {
    await Future.delayed(widget.animationDuration ?? const Duration(milliseconds: 300));

    if (mounted) {
      widget.onPreviewDataFetched?.call(previewData);
      setState(() {
        isFetchingPreviewData = false;
      });
    }
  }

  Widget _defaultAnimated(Widget child) => SizeTransition(
    axis: Axis.vertical,
    axisAlignment: -1,
    sizeFactor: _animation,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    if (isFetchingPreviewData) {
      return widget.loadingBuilder != null ? widget.loadingBuilder!(context) : const SizedBox.shrink();
    }

    final child = widget.builder(context, _previewData);

    if (runAnimation) {
      return widget.animatedBuilder != null ? widget.animatedBuilder!(child, _animation) : _defaultAnimated(child);
    } else {
      return child;
    }
  }
}