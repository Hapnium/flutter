import '../link_preview.dart';
import 'v1/core_v1.dart';
import 'v2/core_v2.dart';

/// Abstract interface for link preview services.
abstract class LinkPreviewInterface {
  /// Fetches preview metadata for the provided [link] (URL or string with URL).
  ///
  /// Optional parameters allow for customizing CORS proxy, timeout, and user agent headers.
  Future<LinkPreviewData?> get(String link, {
    /// Optional CORS proxy for web use. Not guaranteed to work in all cases.
    String? proxy,

    /// The duration for which the preview data should be cached.
    Duration? cacheDuration,

    /// Maximum time to wait for a preview request before timing out.
    ///
    /// Mostly used in version 1. Defaults to 5 seconds.
    Duration? requestTimeout,

    /// User-Agent to be used in the HTTP request to the link
    String? userAgent
  }) async {
    LinkPreviewData? v1 = await runV1(link, proxy: proxy, cache: cacheDuration, requestTimeout: requestTimeout, userAgent: userAgent);

    if(v1 != null) {
      return v1;
    } else if(LinkPreview.isValidLink(link)) {
      // removing www. from the link if available
      if (link.startsWith('www.')) link = link.replaceFirst('www.', '');
      return await _getMetadata(link, proxyUrl: proxy, cache: cacheDuration, userAgent: userAgent);
    }

    return null;
  }
}

Future<LinkPreviewData?> _getMetadata(String link, {
  Duration? cache = const Duration(days: 1),
  Map<String, String>? headers,
  String? userAgent,
  String? proxyUrl
}) async {
  try {
    var proxyValid = true;
    var proxy_ = proxyUrl ?? '';
    if (proxy_.isNotEmpty) proxyValid = LinkPreview.isValidUrl(proxyUrl!);
    var linkToFetch = link.trim();
    if (proxyValid) linkToFetch = (proxy_ + link).trim();
    var info = await runV2(
      linkToFetch,
      cache: cache,
      headers: headers ?? {},
      userAgent: userAgent,
    );
    if (info == null || info.hasData == false) {
      // if info is null or data is empty ,try to read URL metadata
      // client-side
      info = await runV2ClientSide(linkToFetch, cache: cache, headers: headers ?? {}, userAgent: userAgent);
    }

    var img = info?.image?.url ?? '';
    if (img.isNotEmpty && proxy_.isNotEmpty) {
      info?.image = LinkPreviewImage(height: 0.0, url: LinkPreview.resolveUrl(link, proxy_, img), width: 0.0);
    }

    return info;
  } catch (error) {
    return null;
  }
}