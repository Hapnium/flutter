// ignore_for_file: constant_identifier_names

/// {@template http_headers}
/// Headers for HTTP requests and responses.
///
/// In some situations, headers are immutable:
///
/// * [HttpRequest] and [HttpClientResponse] always have immutable headers.
///
/// * [HttpResponse] and [HttpClientRequest] have immutable headers
///   from the moment the body is written to.
///
/// In these situations, the mutating methods throw exceptions.
///
/// For all operations on HTTP headers the header name is
/// case-insensitive.
///
/// To set the value of a header use the `set()` method:
///
///     request.headers.set(HttpHeaders.cacheControlHeader,
///                         'max-age=3600, must-revalidate');
///
/// To retrieve the value of a header use the `value()` method:
///
///     print(request.headers.value(HttpHeaders.userAgentHeader));
///
/// An `HttpHeaders` object holds a list of values for each name
/// as the standard allows. In most cases a name holds only a single value,
/// The most common mode of operation is to use `set()` for setting a value,
/// and `value()` for retrieving a value.
/// 
/// {@endtemplate}
abstract interface class HttpHeaders {
  /// The `accept` header.
  /// 
  /// Mostly used to specify the types of content that the client is able to process.
  static const String ACCEPT = "accept";

  /// The `accept-charset` header.
  /// 
  /// Mostly used to specify the character encodings that the client is able to process.
  static const String ACCEPT_CHARSET = "accept-charset";

  /// The `accept-encoding` header.
  /// 
  /// Mostly used to specify the encoding that the client is able to process.
  static const String ACCEPT_ENCODING = "accept-encoding";

  /// The `accept-language` header.
  /// 
  /// Mostly used to specify the language that the client is able to process.
  static const String ACCEPT_LANGUAGE = "accept-language";

  /// The `accept-ranges` header.
  /// 
  /// Mostly used to specify the range that the client is able to process.
  static const String ACCEPT_RANGES = "accept-ranges";

  /// The `access-control-allow-credentials` header.
  /// 
  /// Mostly used to specify the credentials that the client is able to process.
  static const String ACCESS_CONTROL_ALLOW_CREDENTIALS = 'access-control-allow-credentials';

  /// The `access-control-allow-headers` header.
  /// 
  /// Mostly used to specify the headers that the client is able to process.
  static const String ACCESS_CONTROL_ALLOW_HEADERS = 'access-control-allow-headers';

  /// The `access-control-allow-methods` header.
  /// 
  /// Mostly used to specify the methods that the client is able to process.
  static const String ACCESS_CONTROL_ALLOW_METHODS = 'access-control-allow-methods';

  /// The `access-control-allow-origin` header.
  /// 
  /// Mostly used to specify the origin that the client is able to process.
  static const String ACCESS_CONTROL_ALLOW_ORIGIN = 'access-control-allow-origin';

  /// The `access-control-expose-headers` header.
  /// 
  /// Mostly used to specify the headers that the client is able to process.
  static const String ACCESS_CONTROL_EXPOSE_HEADERS = 'access-control-expose-headers';

  /// The `access-control-max-age` header.
  /// 
  /// Mostly used to specify the max age that the client is able to process.
  static const String ACCESS_CONTROL_MAX_AGE = 'access-control-max-age';

  /// The `access-control-request-headers` header.
  /// 
  /// Mostly used to specify the headers that the client is able to process.
  static const String ACCESS_CONTROL_REQUEST_HEADERS = 'access-control-request-headers';

  /// The `access-control-request-method` header.
  /// 
  /// Mostly used to specify the methods that the client is able to process.
  static const String ACCESS_CONTROL_REQUEST_METHOD = 'access-control-request-method';

  /// The `access-control-allow-private-network` header.
  ///
  /// Indicates whether the response to the request can expose the resource
  /// to a private network (non-publicly routable addresses).
  static const String ACCESS_CONTROL_ALLOW_PRIVATE_NETWORK = 'access-control-allow-private-network';

  /// The `origin` header.
  ///
  /// Used in CORS requests to indicate the origin of the request.
  static const String ORIGIN = 'origin';

  /// The `timing-allow-origin` header.
  ///
  /// Indicates whether the resource supports being accessed by timing APIs.
  static const String TIMING_ALLOW_ORIGIN = 'timing-allow-origin';

  /// The `link` header.
  ///
  /// Used to express relationships between the current resource and other resources (e.g., pagination).
  static const String LINK = 'link';

  /// The `retry-after` header (HTTP-date version).
  ///
  /// This may already be defined but ensure you're accounting for both seconds and date format cases.
  /// Commonly used with `429 Too Many Requests`.
  static const String RETRY_AFTER = 'retry-after';

  /// The `age` header.
  /// 
  /// Mostly used to specify the age that the client is able to process.
  static const String AGE = "age";

  /// The `allow` header.
  /// 
  /// Mostly used to specify the methods that the client is able to process.
  static const String ALLOW = "allow";

  /// The `authorization` header.
  /// 
  /// Mostly used to specify the authorization that the client is able to process.
  static const String AUTHORIZATION = "authorization";

  /// The `cache-control` header.
  /// 
  /// Mostly used to specify the cache control that the client is able to process.
  static const String CACHE_CONTROL = "cache-control";

  /// The `connection` header.
  /// 
  /// Mostly used to specify the connection that the client is able to process.
  static const String CONNECTION = "connection";

  /// The `content-encoding` header.
  /// 
  /// Mostly used to specify the encoding that the client is able to process.
  static const String CONTENT_ENCODING = "content-encoding";

  /// The `content-language` header.
  /// 
  /// Mostly used to specify the language that the client is able to process.
  static const String CONTENT_LANGUAGE = "content-language";

  /// The `content-length` header.
  /// 
  /// Mostly used to specify the length that the client is able to process.
  static const String CONTENT_LENGTH = "content-length";

  /// The `content-location` header.
  /// 
  /// Mostly used to specify the location that the client is able to process.
  static const String CONTENT_LOCATION = "content-location";

  /// The `content-md5` header.
  /// 
  /// Mostly used to specify the md5 that the client is able to process.
  static const String CONTENT_MD5 = "content-md5";

  /// The `content-transfer-encoding` header.
  /// 
  /// Mostly used to specify the transfer encoding that the client is able to process.
  static const String CONTENT_TRANSFER_ENCODING = 'content-transfer-encoding';

  /// The `content-range` header.
  /// 
  /// Mostly used to specify the range that the client is able to process.
  static const String CONTENT_RANGE = "content-range";

  /// The `content-type` header.
  /// 
  /// Mostly used to specify the type that the client is able to process.
  static const String CONTENT_TYPE = "content-type";

  /// The `date` header.
  /// 
  /// Mostly used to specify the date that the client is able to process.
  static const String DATE = "date";

  /// The `etag` header.
  /// 
  /// Mostly used to specify the etag that the client is able to process.
  static const String ETAG = "etag";

  /// The `expect` header.
  /// 
  /// Mostly used to specify the expect that the client is able to process.
  static const String EXPECT = "expect";

  /// The `expires` header.
  /// 
  /// Mostly used to specify the expires that the client is able to process.
  static const String EXPIRES = "expires";

  /// The `from` header.
  /// 
  /// Mostly used to specify the from that the client is able to process.
  static const String FROM = "from";

  /// The `host` header.
  /// 
  /// Mostly used to specify the host that the client is able to process.
  static const String HOST = "host";

  /// The `if-match` header.
  /// 
  /// Mostly used to specify the match that the client is able to process.
  static const String IF_MATCH = "if-match";

  /// The `if-modified-since` header.
  /// 
  /// Mostly used to specify the modified since that the client is able to process.
  static const String IF_MODIFIED_SINCE = "if-modified-since";

  /// The `if-none-match` header.
  /// 
  /// Mostly used to specify the none match that the client is able to process.
  static const String IF_NONE_MATCH = "if-none-match";

  /// The `if-range` header.
  /// 
  /// Mostly used to specify the range that the client is able to process.
  static const String IF_RANGE = "if-range";

  /// The `if-unmodified-since` header.
  /// 
  /// Mostly used to specify the unmodified since that the client is able to process.
  static const String IF_UNMODIFIED_SINCE = "if-unmodified-since";

  /// The `last-modified` header.
  /// 
  /// Mostly used to specify the modified since that the client is able to process.
  static const String LAST_MODIFIED = "last-modified";

  /// The `location` header.
  /// 
  /// Mostly used to specify the location that the client is able to process.
  static const String LOCATION = "location";

  /// The `max-forwards` header.
  /// 
  /// Mostly used to specify the forwards that the client is able to process.
  static const String MAX_FORWARDS = "max-forwards";

  /// The `pragma` header.
  /// 
  /// Mostly used to specify the pragma that the client is able to process.
  static const String PRAGMA = "pragma";

  /// The `proxy-authenticate` header.
  /// 
  /// Mostly used to specify the authenticate that the client is able to process.
  static const String PROXY_AUTHENTICATE = "proxy-authenticate";

  /// The `proxy-authorization` header.
  /// 
  /// Mostly used to specify the authorization that the client is able to process.
  static const String PROXY_AUTHORIZATION = "proxy-authorization";

  /// The `range` header.
  /// 
  /// Mostly used to specify the range that the client is able to process.
  static const String RANGE = "range";

  /// The `referer` header.
  /// 
  /// Mostly used to specify the referer that the client is able to process.
  static const String REFERER = "referer";

  /// The `server` header.
  /// 
  /// Mostly used to specify the server that the client is able to process.
  static const String SERVER = "server";

  /// The `te` header.
  /// 
  /// Mostly used to specify the te that the client is able to process.
  static const String TE = "te";

  /// The `trailer` header.
  /// 
  /// Mostly used to specify the trailer that the client is able to process.
  static const String TRAILER = "trailer";

  /// The `transfer-encoding` header.
  /// 
  /// Mostly used to specify the transfer encoding that the client is able to process.
  static const String TRANSFER_ENCODING = "transfer-encoding";

  /// The `upgrade` header.
  /// 
  /// Mostly used to specify the upgrade that the client is able to process.
  static const String UPGRADE = "upgrade";

  /// The `user-agent` header.
  /// 
  /// Mostly used to specify the user agent that the client is able to process.
  static const String USER_AGENT = "user-agent";

  /// The `vary` header.
  /// 
  /// Mostly used to specify the vary that the client is able to process.
  static const String VARY = "vary";

  /// The `via` header.
  /// 
  /// Mostly used to specify the via that the client is able to process.
  static const String VIA = "via";

  /// The `warning` header.
  /// 
  /// Mostly used to specify the warning that the client is able to process.
  static const String WARNING = "warning";

  /// The `www-authenticate` header.
  /// 
  /// Mostly used to specify the authenticate that the client is able to process.
  static const String WWW_AUTHENTICATE = "www-authenticate";

  /// The `content-disposition` header.
  /// 
  /// Mostly used to specify the disposition that the client is able to process.
  static const String CONTENT_DISPOSITION = "content-disposition";

  // Cookie headers from RFC 6265.

  /// The `cookie` header.
  /// 
  /// Mostly used to specify the cookie that the client is able to process.
  static const String COOKIE = "cookie";

  /// The `set-cookie` header.
  /// 
  /// Mostly used to specify the cookie that the client is able to process.
  static const String SET_COOKIE = "set-cookie";

  /// The `x-content-type-options` header.
  ///
  /// Prevents MIME sniffing. Commonly set to `nosniff`.
  static const String X_CONTENT_TYPE_OPTIONS = 'x-content-type-options';

  /// The `x-frame-options` header.
  ///
  /// Indicates whether a browser should be allowed to render a page in a frame, iframe, embed, or object.
  static const String X_FRAME_OPTIONS = 'x-frame-options';

  /// The `x-xss-protection` header.
  ///
  /// Enables or disables the browser’s XSS protection.
  static const String X_XSS_PROTECTION = 'x-xss-protection';

  /// The `x-requested-with` header.
  ///
  /// Commonly used to identify Ajax requests. Most JavaScript frameworks send this field with value `XMLHttpRequest`.
  static const String X_REQUESTED_WITH = 'x-requested-with';

  /// The `x-forwarded-for` header.
  ///
  /// Identifies the originating IP address of a client connecting through a proxy.
  static const String X_FORWARDED_FOR = 'x-forwarded-for';

  /// The `x-forwarded-host` header.
  ///
  /// Identifies the original host requested by the client in the `Host` HTTP request header.
  static const String X_FORWARDED_HOST = 'x-forwarded-host';

  /// The `x-forwarded-proto` header.
  ///
  /// Identifies the protocol (HTTP or HTTPS) that a client used to connect to your proxy or load balancer.
  static const String X_FORWARDED_PROTO = 'x-forwarded-proto';

  /// The `x-real-ip` header.
  ///
  /// Used to pass the real IP address of the client when behind a reverse proxy.
  static const String X_REAL_IP = 'x-real-ip';

  /// The `x-cancelled` header.
  ///
  /// Mostly used to specify the cancelled that the client is able to process.
  static const String X_CANCELLED = "x-cancelled";

  /// The `x-unexpected-error` header.
  ///
  /// Mostly used to specify the unexpected error that the client is able to process.
  static const String X_UNEXPECTED_ERROR = "x-unexpected-error";

  /// The `x-content-error` header.
  ///
  /// Mostly used to specify the content error that the client is able to process.
  static const String X_CONTENT_ERROR = "x-content-error";

  /// The `x-dns-error` header.
  ///
  /// Mostly used to specify the dns error that the client is able to process.
  static const String X_DNS_ERROR = "x-dns-error";

  /// The `x-retry-after` header.
  ///
  /// Mostly used to specify the retry after that the client is able to process.
  static const String X_RETRY_AFTER = "x-retry-after";

  /// The `x-security-error` header.
  ///
  /// Mostly used to specify the security error that the client is able to process.
  static const String X_SECURITY_ERROR = "x-security-error";

  /// The `x-auth-required` header.
  ///
  /// Mostly used to specify the auth required that the client is able to process.
  static const String X_AUTH_REQUIRED = "x-auth-required";

  /// The `x-status-code` header.
  ///
  /// Mostly used to specify the status code that the client is able to process.
  static const String X_STATUS_CODE = "x-status-code";

  /// The `x-error-type` header.
  ///
  /// Mostly used to specify the error type that the client is able to process.
  static const String X_ERROR_TYPE = "x-error-type";

  /// The general headers.
  ///
  /// General headers are used in both requests and responses.
  static const List<String> GENERAL = [
    CACHE_CONTROL,
    CONNECTION,
    DATE,
    PRAGMA,
    TRAILER,
    TRANSFER_ENCODING,
    UPGRADE,
    VIA,
    WARNING
  ];

  /// The entity headers.
  ///
  /// Entity headers are used in both requests and responses.
  static const List<String> ENTITY = [
    ALLOW,
    CONTENT_ENCODING,
    CONTENT_LANGUAGE,
    CONTENT_LENGTH,
    CONTENT_LOCATION,
    CONTENT_MD5,
    CONTENT_RANGE,
    CONTENT_TYPE,
    EXPIRES,
    LAST_MODIFIED
  ];

  /// The response headers.
  ///
  /// Response headers are used in responses.
  static const List<String> RESPONSE = [
    ACCEPT_RANGES,
    AGE,
    ETAG,
    LOCATION,
    PROXY_AUTHENTICATE,
    RETRY_AFTER,
    SERVER,
    VARY,
    WWW_AUTHENTICATE,
    CONTENT_DISPOSITION
  ];

  /// The request headers.
  ///
  /// Request headers are used in requests.
  static const List<String> REQUEST = [
    ACCEPT,
    ACCEPT_CHARSET,
    ACCEPT_ENCODING,
    ACCEPT_LANGUAGE,
    AUTHORIZATION,
    EXPECT,
    FROM,
    HOST,
    IF_MATCH,
    IF_MODIFIED_SINCE,
    IF_NONE_MATCH,
    IF_RANGE,
    IF_UNMODIFIED_SINCE,
    MAX_FORWARDS,
    PROXY_AUTHORIZATION,
    RANGE,
    REFERER,
    TE,
    USER_AGENT
  ];

  /// The date specified by the [dateHeader] header, if any.
  DateTime? date;

  /// The date and time specified by the [expiresHeader] header, if any.
  DateTime? expires;

  /// The date and time specified by the [ifModifiedSinceHeader] header, if any.
  DateTime? ifModifiedSince;

  /// The value of the [hostHeader] header, if any.
  String? host;

  /// The value of the port part of the [hostHeader] header, if any.
  int? port;

  /// The [ContentType] of the [contentTypeHeader] header, if any.
  // ContentType? contentType;

  /// The value of the [contentLengthHeader] header, if any.
  ///
  /// The value is negative if there is no content length set.
  int contentLength = -1;

  /// Whether the connection is persistent (keep-alive).
  late bool persistentConnection;

  /// Whether the connection uses chunked transfer encoding.
  ///
  /// Reflects and modifies the value of the [transferEncodingHeader] header.
  late bool chunkedTransferEncoding;

  /// The values for the header named [name].
  ///
  /// Returns null if there is no header with the provided name,
  /// otherwise returns a new list containing the current values.
  /// Not that modifying the list does not change the header.
  List<String>? operator [](String name);

  /// Convenience method for the value for a single valued header.
  ///
  /// The value must not have more than one value.
  ///
  /// Returns `null` if there is no header with the provided name.
  String? value(String name);

  /// Adds a header value.
  ///
  /// The header named [name] will have a string value derived from [value]
  /// added to its list of values.
  ///
  /// Some headers are single valued, and for these, adding a value will
  /// replace a previous value. If the [value] is a [DateTime], an
  /// HTTP date format will be applied. If the value is an [Iterable],
  /// each element will be added separately. For all other
  /// types the default [Object.toString] method will be used.
  ///
  /// Header names are converted to lower-case unless
  /// [preserveHeaderCase] is set to true. If two header names are
  /// the same when converted to lower-case, they are considered to be
  /// the same header, with one set of values.
  ///
  /// The current case of the a header name is that of the name used by
  /// the last [set] or [add] call for that header.
  void add(String name, Object value, {bool preserveHeaderCase = false});

  /// Sets the header [name] to [value].
  ///
  /// Removes all existing values for the header named [name] and
  /// then [add]s [value] to it.
  void set(String name, Object value, {bool preserveHeaderCase = false});

  /// Removes a specific value for a header name.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// For all other headers and values, the [value] is converted to a string
  /// in the same way as for [add], then that string value is removed from the
  /// current values of [name].
  /// If there are no remaining values for [name], the header is no longer
  /// considered present.
  void remove(String name, Object value);

  /// Removes all values for the specified header name.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// All other values for [name] are removed.
  /// If there are no remaining values for [name], the header is no longer
  /// considered present.
  void removeAll(String name);

  /// Performs the [action] on each header.
  ///
  /// The [action] function is called with each header's name and a list
  /// of the header's values. The casing of the name string is determined by
  /// the last [add] or [set] operation for that particular header,
  /// which defaults to lower-casing the header name unless explicitly
  /// set to preserve the case.
  void forEach(void Function(String name, List<String> values) action);

  /// Disables folding for the header named [name] when sending the HTTP header.
  ///
  /// By default, multiple header values are folded into a
  /// single header line by separating the values with commas.
  ///
  /// The 'set-cookie' header has folding disabled by default.
  void noFolding(String name);

  /// Removes all headers.
  ///
  /// Some headers have system supplied values which cannot be removed.
  /// All other header values are removed, and header names with not
  /// remaining values are no longer considered present.
  void clear();
}