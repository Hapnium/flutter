import '../definitions.dart';
import '../http/certificates/certificates.dart';

/// {@template zap_config}
/// This class handles the configuration of Zap. It is used to modify and define the behaviour of a
/// [ZapClient] throughout the lifecycle of the client.
/// 
/// {@endtemplate}
class ZapConfig {
  /// Whether self-signed or invalid SSL certificates are allowed.
  ///
  /// Useful for development or testing environments, but should be
  /// disabled in production.
  bool allowAutoSignedCert;

  /// The value to be used in the `User-Agent` HTTP header.
  ///
  /// Commonly used to identify the client platform or version to the server.
  String userAgent;

  /// Whether or not the `User-Agent` should be added to all requests.
  ///
  /// If `true`, the [userAgent] value will be included in every request header.
  bool sendUserAgent;

  /// The base URL for all requests made through this client.
  ///
  /// If provided, all relative URLs will be resolved against this value.
  String? baseUrl;

  /// The default content type to send in HTTP requests.
  ///
  /// Defaults to `'application/json; charset=utf-8'`. Can be overridden per request.
  String defaultContentType;

  /// Whether the client should follow HTTP redirects automatically.
  ///
  /// If disabled, the client will return the redirect response directly.
  bool followRedirects;

  /// Maximum number of redirect attempts allowed.
  ///
  /// Prevents infinite redirect loops.
  int maxRedirects;

  /// The maximum number of times to retry authentication (e.g., on 401 responses).
  int maxAuthRetries;

  /// The default decoder to use for decoding HTTP responses.
  ///
  /// Can be overridden on a per-request basis.
  ResponseDecoder? defaultDecoder;

  /// The maximum duration to wait for an HTTP request to complete.
  ///
  /// Applies to all types of requests, including uploads, downloads, and GraphQL.
  Duration timeout;

  /// A list of trusted SSL certificates for secure connections.
  ///
  /// Used when validating server certificates in strict security contexts.
  List<ZapTrustedCertificate>? trustedCertificates;

  /// A function to determine the proxy server to use for a given request URL.
  ///
  /// If specified, will be used to route HTTP requests through a proxy.
  ProxyFinder? findProxy;

  /// Controls whether credentials (e.g., cookies, authorization headers)
  /// are included in cross-origin HTTP requests.
  ///
  /// Mainly relevant in browser environments.
  bool withCredentials;

  /// Whether the client should safely handle errors during request execution.
  ///
  /// If `true`, errors are caught and handled internally. If `false`,
  /// they are allowed to propagate.
  bool errorSafety;

  /// Creates a new instance of the Zap configuration.
  ///
  /// - [userAgent] defines the `User-Agent` header sent with requests.
  /// - [timeout] specifies the maximum duration to wait for a request to complete.
  /// - [followRedirects] controls whether redirects should be followed automatically.
  /// - [maxRedirects] sets the maximum number of allowed redirects before failing.
  /// - [sendUserAgent] determines if the `User-Agent` should be added to the request headers.
  /// - [maxAuthRetries] controls how many times authentication should be retried.
  /// - [allowAutoSignedCert] allows bypassing SSL certificate validation for self-signed certs.
  /// - [withCredentials] controls whether cross-origin requests include credentials (cookies, etc.).
  /// - [errorSafety] controls whether the client should safely handle errors during request execution.
  /// 
  /// {@macro zap_config}
  ZapConfig({
    this.userAgent = 'hapx-client',
    this.timeout = const Duration(seconds: 5),
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.sendUserAgent = false,
    this.maxAuthRetries = 1,
    this.allowAutoSignedCert = false,
    this.withCredentials = false,
    this.baseUrl,
    this.defaultContentType = 'application/json; charset=utf-8',
    this.defaultDecoder,
    this.trustedCertificates,
    this.findProxy,
    this.errorSafety = true,
  });

  /// Copies the current instance of ZapConfig with new updates
  /// 
  /// {@macro zap_config}
  ZapConfig copyWith({
    bool? allowAutoSignedCert,
    String? userAgent,
    bool? sendUserAgent,
    String? baseUrl,
    String? defaultContentType,
    bool? followRedirects,
    int? maxRedirects,
    int? maxAuthRetries,
    ResponseDecoder? defaultDecoder,
    Duration? timeout,
    List<ZapTrustedCertificate>? trustedCertificates,
    ProxyFinder? findProxy,
    bool? withCredentials,
    bool? errorSafety,
  }) {
    return ZapConfig(
      userAgent: userAgent ?? this.userAgent,
      allowAutoSignedCert: allowAutoSignedCert ?? this.allowAutoSignedCert,
      sendUserAgent: sendUserAgent ?? this.sendUserAgent,
      baseUrl: baseUrl ?? this.baseUrl,
      defaultContentType: defaultContentType ?? this.defaultContentType,
      followRedirects: followRedirects ?? this.followRedirects,
      maxAuthRetries: maxAuthRetries ?? this.maxAuthRetries,
      maxRedirects: maxRedirects ?? this.maxRedirects,
      defaultDecoder: defaultDecoder ?? this.defaultDecoder,
      timeout: timeout ?? this.timeout,
      trustedCertificates: trustedCertificates ?? this.trustedCertificates,
      findProxy: findProxy ?? this.findProxy,
      withCredentials: withCredentials ?? this.withCredentials,
      errorSafety: errorSafety ?? this.errorSafety,
    );
  }
}