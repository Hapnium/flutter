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
abstract interface class HttpHeaders {
  /// The `accept` header.
  static const acceptHeader = "accept";

  /// The `accept-charset` header.
  static const acceptCharsetHeader = "accept-charset";

  /// The `accept-encoding` header.
  static const acceptEncodingHeader = "accept-encoding";

  /// The `accept-language` header.
  static const acceptLanguageHeader = "accept-language";

  /// The `accept-ranges` header.
  static const acceptRangesHeader = "accept-ranges";

  /// The `access-control-allow-credentials` header.
  static const accessControlAllowCredentialsHeader = 'access-control-allow-credentials';

  /// The `access-control-allow-headers` header.
  static const accessControlAllowHeadersHeader = 'access-control-allow-headers';

  /// The `access-control-allow-methods` header.
  static const accessControlAllowMethodsHeader = 'access-control-allow-methods';

  /// The `access-control-allow-origin` header.
  static const accessControlAllowOriginHeader = 'access-control-allow-origin';

  /// The `access-control-expose-headers` header.
  static const accessControlExposeHeadersHeader = 'access-control-expose-headers';

  /// The `access-control-max-age` header.
  static const accessControlMaxAgeHeader = 'access-control-max-age';

  /// The `access-control-request-headers` header.
  static const accessControlRequestHeadersHeader = 'access-control-request-headers';

  /// The `access-control-request-method` header.
  static const accessControlRequestMethodHeader = 'access-control-request-method';

  /// The `age` header.
  static const ageHeader = "age";

  /// The `allow` header.
  static const allowHeader = "allow";

  /// The `authorization` header.
  static const authorizationHeader = "authorization";

  /// The `cache-control` header.
  static const cacheControlHeader = "cache-control";

  /// The `connection` header.
  static const connectionHeader = "connection";

  /// The `content-encoding` header.
  static const contentEncodingHeader = "content-encoding";

  /// The `content-language` header.
  static const contentLanguageHeader = "content-language";

  /// The `content-length` header.
  static const contentLengthHeader = "content-length";

  /// The `content-location` header.
  static const contentLocationHeader = "content-location";

  /// The `content-md5` header.
  static const contentMD5Header = "content-md5";

  /// The `content-range` header.
  static const contentRangeHeader = "content-range";

  /// The `content-type` header.
  static const contentTypeHeader = "content-type";

  /// The `date` header.
  static const dateHeader = "date";

  /// The `etag` header.
  static const etagHeader = "etag";

  /// The `expect` header.
  static const expectHeader = "expect";

  /// The `expires` header.
  static const expiresHeader = "expires";

  /// The `from` header.
  static const fromHeader = "from";

  /// The `host` header.
  static const hostHeader = "host";

  /// The `if-match` header.
  static const ifMatchHeader = "if-match";

  /// The `if-modified-since` header.
  static const ifModifiedSinceHeader = "if-modified-since";

  /// The `if-none-match` header.
  static const ifNoneMatchHeader = "if-none-match";

  /// The `if-range` header.
  static const ifRangeHeader = "if-range";

  /// The `if-unmodified-since` header.
  static const ifUnmodifiedSinceHeader = "if-unmodified-since";

  /// The `last-modified` header.
  static const lastModifiedHeader = "last-modified";

  /// The `location` header.
  static const locationHeader = "location";

  /// The `max-forwards` header.
  static const maxForwardsHeader = "max-forwards";

  /// The `pragma` header.
  static const pragmaHeader = "pragma";

  /// The `proxy-authenticate` header.
  static const proxyAuthenticateHeader = "proxy-authenticate";

  /// The `proxy-authorization` header.
  static const proxyAuthorizationHeader = "proxy-authorization";

  /// The `range` header.
  static const rangeHeader = "range";

  /// The `referer` header.
  static const refererHeader = "referer";

  /// The `retry-after` header.
  static const retryAfterHeader = "retry-after";

  /// The `server` header.
  static const serverHeader = "server";

  /// The `te` header.
  static const teHeader = "te";

  /// The `trailer` header.
  static const trailerHeader = "trailer";

  /// The `transfer-encoding` header.
  static const transferEncodingHeader = "transfer-encoding";

  /// The `upgrade` header.
  static const upgradeHeader = "upgrade";

  /// The `user-agent` header.
  static const userAgentHeader = "user-agent";

  /// The `vary` header.
  static const varyHeader = "vary";

  /// The `via` header.
  static const viaHeader = "via";

  /// The `warning` header.
  static const warningHeader = "warning";

  /// The `www-authenticate` header.
  static const wwwAuthenticateHeader = "www-authenticate";

  /// The `content-disposition` header.
  static const contentDisposition = "content-disposition";

  // Cookie headers from RFC 6265.
  static const cookieHeader = "cookie";
  static const setCookieHeader = "set-cookie";

  /// The general headers.
  ///
  /// General headers are used in both requests and responses.
  static const generalHeaders = [
    cacheControlHeader,
    connectionHeader,
    dateHeader,
    pragmaHeader,
    trailerHeader,
    transferEncodingHeader,
    upgradeHeader,
    viaHeader,
    warningHeader
  ];

  /// The entity headers.
  ///
  /// Entity headers are used in both requests and responses.
  static const entityHeaders = [
    allowHeader,
    contentEncodingHeader,
    contentLanguageHeader,
    contentLengthHeader,
    contentLocationHeader,
    contentMD5Header,
    contentRangeHeader,
    contentTypeHeader,
    expiresHeader,
    lastModifiedHeader
  ];

  /// The response headers.
  ///
  /// Response headers are used in responses.
  static const responseHeaders = [
    acceptRangesHeader,
    ageHeader,
    etagHeader,
    locationHeader,
    proxyAuthenticateHeader,
    retryAfterHeader,
    serverHeader,
    varyHeader,
    wwwAuthenticateHeader,
    contentDisposition
  ];

  /// The request headers.
  ///
  /// Request headers are used in requests.
  static const requestHeaders = [
    acceptHeader,
    acceptCharsetHeader,
    acceptEncodingHeader,
    acceptLanguageHeader,
    authorizationHeader,
    expectHeader,
    fromHeader,
    hostHeader,
    ifMatchHeader,
    ifModifiedSinceHeader,
    ifNoneMatchHeader,
    ifRangeHeader,
    ifUnmodifiedSinceHeader,
    maxForwardsHeader,
    proxyAuthorizationHeader,
    rangeHeader,
    refererHeader,
    teHeader,
    userAgentHeader
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