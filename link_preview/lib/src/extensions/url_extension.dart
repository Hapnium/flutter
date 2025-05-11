import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';

import '../link_preview_interface.dart';

extension UrlExtension on LinkPreviewInterface {
  /// Resolve a relative image URL with a base URL and a proxy URL.
  String resolveUrl(String baseUrl, String proxyUrl, String imageUrl) {
    try {
      // Parse the base and proxy URLs
      final baseUri = Uri.parse(baseUrl);
      final proxyUri = Uri.parse(proxyUrl);

      // Resolve the relative image URL with the base URL
      final resolvedUri = baseUri.resolve(imageUrl);

      // Combine the proxy URL with the resolved URI
      return proxyUri.resolve(resolvedUri.toString()).toString();
    } catch (e) {
      // Return the original image URL if resolution fails
      return imageUrl;
    }
  }

  /// Extracts and decodes SVG content from a Base64-encoded data URI.
  String? extractSvgContent(String data) {
    try {
      if (data.contains('base64,')) {
        final base64String = data.substring(data.indexOf('base64,') + 7);
        return utf8.decode(base64.decode(base64String));
      } else {
        return kIsWeb
            ? Uri.decodeComponent(data.substring('data:image/svg+xml,'.length))
            : Uri.decodeFull(data.substring('data:image/svg+xml,'.length));
      }
    } catch (e) {
      debugPrint('Failed to decode SVG content -> $e');
      return null;
    }
  }

  /// Checks if a URL is valid.
  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath;
  }

  /// Checks if the input is a Base64-encoded SVG data URI.
  bool isSvgDataUri(String data) {
    return data.contains('data:image/svg+xml');
  }

  /// Checks if the input is a Base64-encoded SVG data URI.
  bool isValidSvg(String svgString) {
    try {
      final document = XmlDocument.parse(svgString);
      final svgElement = document.rootElement;

      // Check if root element is 'svg'
      if (svgElement.name.local != 'svg') {
        return false;
      }

      // Validate 'viewBox' attribute if necessary
      final viewBox = svgElement.getAttribute('viewBox');
      if (viewBox != null) {
        final parts = viewBox.split(RegExp(r'\s+'));
        if (parts.length != 4 || parts.any((v) => double.tryParse(v) == null)) {
          return false; // 'viewBox' is incorrectly specified
        }
      }

      // Recursively check for at least one graphical element
      return _containsGraphicContent(svgElement);
    } catch (e) {
      // XML parsing error or other exception
      return false;
    }
  }

  /// Checks if the input is a Base64-encoded SVG data URI.
  bool isSvgAndValid(String imageUrl) {
    final svgContent = extractSvgContent(imageUrl);
    if (svgContent != null) {
      debugPrint('Valid SVG data found.');
      return isValidSvg(svgContent);
    }

    debugPrint('Invalid SVG data; using fallback image.');
    return false;
  }

  /// check if the string is a URL
  ///
  /// `options` is a `Map` which defaults to
  /// `{ 'protocols': ['http','https','ftp'], 'require_tld': true,
  /// 'require_protocol': false, 'allow_underscores': false }`.
  bool isURL(String? input, [Map<String, Object>? options]) {
    var str = input;
    if (str == null || str.isEmpty || str.length > 2083 || str.indexOf('mailto:') == 0) {
      return false;
    }

    final defaultUrlOptions = {
      'protocols': ['http', 'https', 'ftp'],
      'require_tld': true,
      'require_protocol': false,
      'allow_underscores': false,
    };

    options = _merge(options, defaultUrlOptions);

    // check protocol
    var split = str.split('://');
    if (split.length > 1) {
      final protocol = _shift(split);
      final protocols = options['protocols'] as List<String>;
      if (!protocols.contains(protocol)) {
        return false;
      }
    } else if (options['require_protocol'] == true) {
      return false;
    }
    str = split.join('://');

    // check hash
    split = str.split('#');
    str = _shift(split);
    final hash = split.join('#');
    if (hash.isNotEmpty && RegExp(r'\s').hasMatch(hash)) {
      return false;
    }

    // check query params
    split = str?.split('?') ?? [];
    str = _shift(split);
    final query = split.join('?');
    if (query != "" && RegExp(r'\s').hasMatch(query)) {
      return false;
    }

    // check path
    split = str?.split('/') ?? [];
    str = _shift(split);
    final path = split.join('/');
    if (path != "" && RegExp(r'\s').hasMatch(path)) {
      return false;
    }

    // check auth type urls
    split = str?.split('@') ?? [];
    if (split.length > 1) {
      final auth = _shift(split);
      if (auth != null && auth.contains(':')) {
        // final auth = auth.split(':');
        final parts = auth.split(':');
        final user = _shift(parts);
        if (user == null || !RegExp(r'^\S+$').hasMatch(user)) {
          return false;
        }
        final pass = parts.join(':');
        if (!RegExp(r'^\S*$').hasMatch(pass)) {
          return false;
        }
      }
    }

    // check hostname
    final hostname = split.join('@');
    split = hostname.split(':');
    final host = _shift(split);
    if (split.isNotEmpty) {
      final portStr = split.join(':');
      final port = int.tryParse(portStr, radix: 10);
      if (!RegExp(r'^[0-9]+$').hasMatch(portStr) ||
          port == null ||
          port <= 0 ||
          port > 65535) {
        return false;
      }
    }

    if (host == null || !isIP(host) && !isFQDN(host, options) && host != 'localhost') {
      return false;
    }

    return true;
  }

  /// check if the string is an IP (version 4 or 6)
  ///
  /// `version` is a String or an `int`.
  bool isIP(String str, [Object? version]) {
    assert(version == null || version is String || version is int);
    version = version.toString();
    if (version == 'null') {
      return isIP(str, 4) || isIP(str, 6);
    } else if (version == '4') {
      if (!_ipv4Maybe.hasMatch(str)) {
        return false;
      }
      var parts = str.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && _ipv6.hasMatch(str);
  }

  /// check if the string is a fully qualified domain name (e.g. domain.com).
  ///
  /// `options` is a `Map` which defaults to `{ 'require_tld': true, 'allow_underscores': false }`.
  bool isFQDN(String str, [Map<String, Object>? options]) {
    final defaultFqdnOptions = {'require_tld': true, 'allow_underscores': false};

    options = _merge(options, defaultFqdnOptions);
    final parts = str.split('.');
    if (options['require_tld'] as bool) {
      var tld = parts.removeLast();
      if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    for (final part in parts) {
      if (options['allow_underscores'] as bool) {
        if (part.contains('__')) {
          return false;
        }
      }
      if (!RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
        return false;
      }
      if (part[0] == '-' ||
          part[part.length - 1] == '-' ||
          part.contains('---')) {
        return false;
      }
    }
    return true;
  }

  bool isValidLink(String link, {
    List<String> protocols = const ['http', 'https', 'ftp'],
    List<String> hostWhitelist = const [],
    List<String> hostBlacklist = const [],
    bool requireTld = true,
    bool requireProtocol = false,
    bool allowUnderscore = false,
  }) {
    if (link.isEmpty) return false;
    final options = <String, Object>{
      'require_tld': requireTld,
      'require_protocol': requireProtocol,
      'allow_underscores': allowUnderscore,
      // 'require_port': false,
      // 'require_valid_protocol': true,
      // 'allow_trailing_dot': false,
      // 'allow_protocol_relative_urls': false,
      // 'allow_fragments': true,
      // 'allow_query_components': true,
      // 'disallow_auth': false,
      // 'validate_length': true
    };
    if (protocols.isNotEmpty) options['protocols'] = protocols;
    if (hostWhitelist.isNotEmpty) options['host_whitelist'] = hostWhitelist;
    if (hostBlacklist.isNotEmpty) options['host_blacklist'] = hostBlacklist;

    return isURL(link, options);
  }
}

bool _containsGraphicContent(XmlNode node) {
  if (node is XmlElement) {
    // Check if the current element is a graphical element
    if ([
      'circle',
      'ellipse',
      'line',
      'path',
      'polygon',
      'polyline',
      'rect',
      'text',
    ].contains(node.name.local)) {
      return true;
    }

    // Recursively check child elements
    for (final child in node.children) {
      if (_containsGraphicContent(child)) {
        return true;
      }
    }
  }

  return false;
}

// Helper functions for validator and sanitizer.

String? _shift(List<String> elements) {
  if (elements.isEmpty) return null;
  return elements.removeAt(0);
}

Map<String, Object> _merge(Map<String, Object>? obj, Map<String, Object> defaults) {
  if (obj == null) {
    return defaults;
  }
  defaults.forEach((key, val) => obj.putIfAbsent(key, () => val));
  return obj;
}

RegExp _ipv4Maybe = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
RegExp _ipv6 = RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');