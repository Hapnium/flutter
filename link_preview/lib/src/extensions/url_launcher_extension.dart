import 'package:url_launcher/url_launcher.dart';

import '../link_preview_interface.dart';

/// Extension that provides common URL launching methods for [LinkPreviewInterface].
extension UrlLauncherExtension on LinkPreviewInterface {
  /// Launches the given [url] in the external application (e.g. browser).
  Future<void> launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Launches the given [url] in an in-app web view.
  Future<void> launchInApp(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }

  /// Launches the given [url] in a new browser tab (for web).
  Future<void> launchInBrowserTab(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }
}