import 'package:flutter/material.dart';

import '../typedefs.dart';
import '../link_preview_interface.dart';
import '../ui/link_preview_builder.dart';

/// UI helpers for [LinkPreviewInterface], allowing easier widget construction.
extension UiExtension on LinkPreviewInterface {
  /// Builds a [LinkPreviewBuilder] widget with the provided parameters.
  ///
  /// This is a convenience method to create link preview widgets in UI code.
  Widget builder({
    /// The URL to preview.
    required String link,

    /// Builds the final widget using the fetched preview data.
    required LinkPreviewWidgetBuilder builder,

    /// Widget builder displayed while fetching preview data.
    WidgetBuilder? loadingBuilder,

    /// Duration for the default expand animation. Defaults to 300ms.
    Duration? animationDuration,

    /// Enables expand animation. Defaults to false.
    bool? enableAnimation,

    /// Allows you to define a custom animation wrapper around the result widget.
    LinkPreviewAnimationBuilder? animatedBuilder,

    /// Optional CORS proxy for web use. Not guaranteed to work in all cases.
    String? corsProxy,

    /// User-Agent to be used in the HTTP request to the link
    /// Default: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3', 'WhatsApp/2.21.12.21 A'
    String? userAgent,

    /// Maximum time to wait for a preview request before timing out. Defaults to 5 seconds.
    Duration? requestTimeout,

    /// Callback triggered when preview data is fetched.
    OnPreviewDataFetched? onPreviewDataFetched,

    /// Duration for the cache. Defaults to 24 hours.
    Duration? cacheDuration,
  }) {
    return LinkPreviewBuilder(
      link: link,
      builder: builder,
      loadingBuilder: loadingBuilder,
      animationDuration: animationDuration,
      enableAnimation: enableAnimation,
      animatedBuilder: animatedBuilder,
      corsProxy: corsProxy,
      userAgent: userAgent,
      requestTimeout: requestTimeout,
      onPreviewDataFetched: onPreviewDataFetched,
      cacheDuration: cacheDuration,
    );
  }
}