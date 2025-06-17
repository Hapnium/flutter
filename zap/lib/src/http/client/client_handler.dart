part of 'zap_client.dart';

class ClientHandler {
  final String? baseUrl;
  final bool sendUserAgent;
  final bool sendContentLength;
  final String userAgent;
  final String defaultContentType;
  final Duration timeout;
  final bool errorSafety;
  final int maxAuthRetries;
  final int maxRedirects;
  final bool followRedirects;
  final ProxyFinder? findProxy;
  final ZapModifier modifier;
  final ControllerAdvice? controllerAdvice;
  final HttpRequestInterface client;
  final ResponseDecoder? defaultDecoder;
  final ResponseInterceptor? defaultResponseInterceptor;

  ClientHandler({
    this.baseUrl,
    this.sendUserAgent = false,
    this.sendContentLength = true,
    this.userAgent = 'hapx-client',
    this.defaultContentType = 'application/json; charset=utf-8',
    this.timeout = const Duration(seconds: 8),
    this.errorSafety = true,
    this.maxAuthRetries = 1,
    this.maxRedirects = 5,
    this.followRedirects = true,
    this.findProxy,
    required this.modifier,
    this.controllerAdvice,
    required this.client,
    this.defaultDecoder,
    this.defaultResponseInterceptor,
  });
  
  /// Builds a fully qualified [Uri] from a path and optional query parameters.
  ///
  /// If [baseUrl] is set, the path will be appended to it. Otherwise,
  /// the path must be a full URL.
  ///
  /// ### Parameters:
  /// - [url]: A relative or absolute URL string.
  /// - [query]: An optional map of query parameters.
  ///
  /// ### Returns:
  Uri createUri(String? url, RequestParam? query) {
    if (baseUrl != null) {
      url = baseUrl! + url!;
    }
    
    final uri = Uri.parse(url!);
    if (query != null) {
      // Convert all query parameter values to strings
      final stringQuery = query.map((key, value) {
        if (value is List) {
          // Convert list to comma-separated string or bracket notation
          return MapEntry(key, value.map((e) => e.toString()).join(','));
          // Alternative bracket notation: return MapEntry(key, '[${value.map((e) => e.toString()).join(',')}]');
        } else {
          return MapEntry(key, value.toString());
        }
      });
      return uri.replace(queryParameters: stringQuery);
    }

    return uri;
  }
}