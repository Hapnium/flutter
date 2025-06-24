part of 'zap_client.dart';

/// {@template client_handler}
/// 
/// This class is used to handle HTTP requests and responses.
/// It provides a high-level interface for making HTTP requests and handling responses.
/// 
/// {@endtemplate}
class ClientHandler {
  /// This is the base URL for all requests.
  final String? baseUrl;
  
  /// Whether to send the user agent in the request headers.
  final bool sendUserAgent;
  
  /// Whether to send the content length in the request headers.
  final bool sendContentLength;
  
  /// The user agent to send in the request headers.
  final String userAgent;
  
  /// The default content type to send in the request headers.
  final String defaultContentType;
  
  /// The timeout for the request.
  final Duration timeout;
  
  /// Whether to enable error safety.
  final bool errorSafety;
  
  /// The maximum number of authentication retries.
  final int maxAuthRetries;
  
  /// The maximum number of redirects.
  final int maxRedirects;
  
  /// Whether to follow redirects.
  final bool followRedirects;
  
  /// The proxy finder.
  final ProxyFinder? findProxy;
  
  /// The modifier.
  final ZapModifier modifier;
  
  /// The controller advice.
  final ControllerAdvice? controllerAdvice;
  
  /// The HTTP client.
  final HttpRequestInterface client;
  
  /// The default decoder.
  final ResponseDecoder? defaultDecoder;
  
  /// The default response interceptor.
  final ResponseInterceptor? defaultResponseInterceptor;

  /// {@macro client_handler}
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