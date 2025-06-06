import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../extensions/get_extension.dart';
import 'parsers/html_parser.dart';
import 'parsers/json_id_parser.dart';
import 'parsers/og_parser.dart';
import 'parsers/other_parser.dart';
import 'parsers/twitter_parser.dart';
import 'parsers/youtube_parser.dart';
import 'http_utils.dart';

import 'package:link_preview/link_preview.dart';

CacheManager _manager = LinkPreview.cacheManager();

/// Twitter generates meta tags client-side so it's impossible to read their
/// values from a server request. We use this hack to fetch server-side
/// rendered meta tags.
///
/// This method is useful for URLs that use client-side meta tag generation
/// technique.
Future<LinkPreviewData?> runV2ClientSide(String url, {
  Duration? cache = const Duration(hours: 24),
  Map<String, String> headers = const {},
  String? userAgent = 'WhatsApp/2.21.12.21 A',
}) => runV2(url, cache: cache, headers: headers, userAgent: userAgent);

/// Fetches a [url], validates it, then returns [LinkPreviewData].
Future<LinkPreviewData?> runV2(String url, {
  Duration? cache = const Duration(hours: 24),
  Map<String, String> headers = const {},
  String? userAgent,
}) async {
  LinkPreviewData? info;
  if ((cache?.inSeconds ?? 0) > 0) {
    info = await _manager.get(url);
  } else {
    _manager.delete(url);
  }
  if (info != null) return info;

  if (!LinkPreview.isURL(url)) return null;

  // Default values; Domain name as the [title],
  // URL as the [description]
  info?.title = getDomain(url);
  info?.description = url;
  info?.siteName = getDomain(url);
  info?.url = url;

  try {
    // Make our network call
    String? videoId = getYouTubeVideoId(url);
    http.Response response = videoId == null
        ? await fetchWithRedirects(url, headers: headers, userAgent: userAgent)
        : await getYoutubeData(videoId, headers: headers, userAgent: userAgent);
    String? headerContentType = response.headers['content-type'];

    if (headerContentType != null && headerContentType.startsWith('image/')) {
      info?.title = '';
      info?.description = '';
      info?.siteName = '';
      info?.image = LinkPreviewImage(url: url, height: 0.0, width: 0.0);
      return info;
    }

    final document = responseToDocument(response);
    if (document == null) return info;

    final data_ = _extractMetadata(document, url: url);

    if (data_ == null) {
      return info;
    } else if (cache != null) {
      data_.timeout = DateTime.now().add(cache);
      _manager.set(url, data_);
    }

    return data_;
  } catch (error) {
    debugPrint('AnyLinkPreview - Error in $url response ($error)');
    // Any sort of exceptions due to wrong URL's, host lookup failure etc.
    return null;
  }
}

/// Takes an [http.Response] and returns a [Document].
Document? responseToDocument(http.Response response) {
  if (response.statusCode != 200) return null;

  Document? document;
  try {
    document = parse(utf8.decode(response.bodyBytes));
  } catch (err) {
    return document;
  }

  return document;
}

/// Returns instance of [LinkPreviewData] with data extracted from the
/// [Document]. Provide a [url] as a fallback when there are no
/// Document URLs extracted by the parsers.
///
/// Future: Can pass in a strategy, e.g.: to retrieve only OpenGraph, or
/// OpenGraph and Json+LD only.
LinkPreviewData? _extractMetadata(Document document, {String? url}) => _parse(document, url: url);

/// This is the default strategy for building our [LinkPreviewData].
///
/// It tries [OpenGraphParser], then [TwitterParser], then [JsonLdParser],
/// and then falls back to [HtmlMetaParser] tags for missing data. You may
/// optionally provide a URL to the function, used to resolve relative images
/// or to compensate for the lack of URI identifiers from the metadata
/// parsers.
LinkPreviewData _parse(Document? document, {String? url}) {
  final output = LinkPreviewData();

  final parsers = [
    _openGraph(document),
    _twitterCard(document),
    _youtubeCard(document),
    _jsonLdSchema(document),
    _htmlMeta(document),
    _otherParser(document),
  ];

  for (final p in parsers) {
    if (p == null) continue;

    output.title ??= p.title;
    output.description ??= p.description;
    output.image ??= p.image;
    output.siteName ??= p.siteName;
    output.url ??= p.url ?? url;

    if (output.hasAllMetadata) break;
  }
  // If the parsers did not extract a URL from the metadata, use the given
  // url, if available. This is used to attempt to resolve relative images.
  final url_ = output.url ?? url;
  final img = output.image;
  if (url_ != null && img != null) {
    output.image = LinkPreviewImage(height: 0.0, url: Uri.parse(url_).resolve(img.url).toString(), width: 0.0);
  }

  return output;
}

LinkPreviewData? _openGraph(Document? document) {
  try {
    return OpenGraphParser(document).parse();
  } catch (e) {
    return null;
  }
}

LinkPreviewData? _htmlMeta(Document? document) {
  try {
    return HtmlMetaParser(document).parse();
  } catch (e) {
    return null;
  }
}

LinkPreviewData? _jsonLdSchema(Document? document) {
  try {
    return JsonLdParser(document).parse();
  } catch (e) {
    return null;
  }
}

LinkPreviewData? _youtubeCard(Document? document) {
  try {
    return YoutubeParser(document).parse();
  } catch (e) {
    return null;
  }
}

LinkPreviewData? _twitterCard(Document? document) {
  try {
    return TwitterParser(document).parse();
  } catch (e) {
    return null;
  }
}

LinkPreviewData? _otherParser(Document? document) {
  try {
    return OtherParser(document).parse();
  } catch (e) {
    return null;
  }
}