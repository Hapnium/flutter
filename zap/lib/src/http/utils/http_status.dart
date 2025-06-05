/// A utility class representing HTTP status codes and their interpretation.
/// 
/// Use this to check common HTTP response conditions like unauthorized access,
/// server errors, or successful responses. It also provides constants for all
/// standard HTTP status codes.
class HttpStatus {
  /// Creates a new [HttpStatus] instance with the given [code].
  HttpStatus(this.code);

  /// The HTTP status code. If null, indicates a connection or network error.
  final int? code;

  // --- Informational responses (100–199) ---

  /// 100 Continue – Indicates that the initial part of the request has been received.
  static const int continue_ = 100;

  /// 101 Switching Protocols – Protocol change requested by the client.
  static const int switchingProtocols = 101;

  /// 102 Processing – WebDAV: Server has received and is processing the request.
  static const int processing = 102;

  /// 103 Early Hints – Used to return some response headers before the final HTTP message.
  static const int earlyHints = 103;

  // --- Successful responses (200–299) ---

  /// 200 OK – Standard response for successful HTTP requests.
  static const int ok = 200;

  /// 201 Created – Request has succeeded and a resource has been created.
  static const int created = 201;

  /// 202 Accepted – Request accepted for processing, but not completed.
  static const int accepted = 202;

  /// 203 Non-Authoritative Information – Response modified by a proxy.
  static const int nonAuthoritativeInformation = 203;

  /// 204 No Content – Successful request with no content to return.
  static const int noContent = 204;

  /// 205 Reset Content – Client should reset the document view.
  static const int resetContent = 205;

  /// 206 Partial Content – Partial response as per range header.
  static const int partialContent = 206;

  /// 207 Multi-Status – WebDAV: Multiple status codes for a single request.
  static const int multiStatus = 207;

  /// 208 Already Reported – WebDAV: Repeated elements already reported.
  static const int alreadyReported = 208;

  /// 226 IM Used – HTTP Delta encoding response.
  static const int imUsed = 226;

  // --- Redirection messages (300–399) ---

  /// 300 Multiple Choices – More than one possible response.
  static const int multipleChoices = 300;

  /// 301 Moved Permanently – Resource has been permanently moved.
  static const int movedPermanently = 301;

  /// 302 Found – Resource temporarily moved.
  static const int found = 302;

  /// 302 Moved Temporarily – Alias for 302 Found.
  static const int movedTemporarily = 302;

  /// 303 See Other – Response can be found under a different URI.
  static const int seeOther = 303;

  /// 304 Not Modified – Resource has not been modified since last request.
  static const int notModified = 304;

  /// 305 Use Proxy – Must access resource via proxy.
  static const int useProxy = 305;

  /// 306 Switch Proxy – No longer used.
  static const int switchProxy = 306;

  /// 307 Temporary Redirect – Temporary redirection, method not changed.
  static const int temporaryRedirect = 307;

  /// 308 Permanent Redirect – Permanent redirection, method not changed.
  static const int permanentRedirect = 308;

  // --- Client error responses (400–499) ---

  /// 400 Bad Request – Malformed request.
  static const int badRequest = 400;

  /// 401 Unauthorized – Missing or invalid authentication.
  static const int unauthorized = 401;

  /// 402 Payment Required – Reserved for future use.
  static const int paymentRequired = 402;

  /// 403 Forbidden – Server refuses to fulfill the request.
  static const int forbidden = 403;

  /// 404 Not Found – Resource could not be found.
  static const int notFound = 404;

  /// 405 Method Not Allowed – HTTP method not allowed.
  static const int methodNotAllowed = 405;

  /// 406 Not Acceptable – Requested content type not supported.
  static const int notAcceptable = 406;

  /// 407 Proxy Authentication Required – Authentication with proxy required.
  static const int proxyAuthenticationRequired = 407;

  /// 408 Request Timeout – Server timed out waiting for request.
  static const int requestTimeout = 408;

  /// 409 Conflict – Request conflict with current state of the server.
  static const int conflict = 409;

  /// 410 Gone – Resource no longer available.
  static const int gone = 410;

  /// 411 Length Required – Content length not specified.
  static const int lengthRequired = 411;

  /// 412 Precondition Failed – Precondition in request headers failed.
  static const int preconditionFailed = 412;

  /// 413 Payload Too Large – Request body too large.
  static const int requestEntityTooLarge = 413;

  /// 414 URI Too Long – Requested URI too long for server to handle.
  static const int requestUriTooLong = 414;

  /// 415 Unsupported Media Type – Format of request not supported.
  static const int unsupportedMediaType = 415;

  /// 416 Requested Range Not Satisfiable – Invalid byte range in request.
  static const int requestedRangeNotSatisfiable = 416;

  /// 417 Expectation Failed – Expectation given in headers not met.
  static const int expectationFailed = 417;

  /// 418 I'm a teapot – April Fools joke RFC.
  static const int imATeapot = 418;

  /// 421 Misdirected Request – Request sent to wrong server.
  static const int misdirectedRequest = 421;

  /// 422 Unprocessable Entity – Semantic errors in request.
  static const int unprocessableEntity = 422;

  /// 423 Locked – Resource is locked.
  static const int locked = 423;

  /// 424 Failed Dependency – Request failed due to earlier failure.
  static const int failedDependency = 424;

  /// 425 Too Early – Premature request.
  static const int tooEarly = 425;

  /// 426 Upgrade Required – Client should switch to a different protocol.
  static const int upgradeRequired = 426;

  /// 428 Precondition Required – Request needs conditions in headers.
  static const int preconditionRequired = 428;

  /// 429 Too Many Requests – Rate limit exceeded.
  static const int tooManyRequests = 429;

  /// 431 Request Header Fields Too Large – Header fields too large.
  static const int requestHeaderFieldsTooLarge = 431;

  /// 444 Connection Closed Without Response – Server closed connection with no response.
  static const int connectionClosedWithoutResponse = 444;

  /// 451 Unavailable For Legal Reasons – Content blocked due to legal demands.
  static const int unavailableForLegalReasons = 451;

  /// 499 Client Closed Request – Client closed connection before server responded.
  static const int clientClosedRequest = 499;

  // --- Server error responses (500–599) ---

  /// 500 Internal Server Error – Generic server error.
  static const int internalServerError = 500;

  /// 501 Not Implemented – Server does not support the functionality.
  static const int notImplemented = 501;

  /// 502 Bad Gateway – Invalid response from upstream server.
  static const int badGateway = 502;

  /// 503 Service Unavailable – Server is down or overloaded.
  static const int serviceUnavailable = 503;

  /// 504 Gateway Timeout – Timeout from upstream server.
  static const int gatewayTimeout = 504;

  /// 505 HTTP Version Not Supported – HTTP version not supported.
  static const int httpVersionNotSupported = 505;

  /// 506 Variant Also Negotiates – Transparent content negotiation circular reference.
  static const int variantAlsoNegotiates = 506;

  /// 507 Insufficient Storage – WebDAV: Server cannot store representation.
  static const int insufficientStorage = 507;

  /// 508 Loop Detected – Infinite loop detected in processing request.
  static const int loopDetected = 508;

  /// 510 Not Extended – Further extensions required to fulfill request.
  static const int notExtended = 510;

  /// 511 Network Authentication Required – Network login required.
  static const int networkAuthenticationRequired = 511;

  /// 599 Network Connect Timeout Error – Non-standard: Network connection timed out.
  static const int networkConnectTimeoutError = 599;

  // --- Custom helpers ---

  /// True if [code] is null, indicating a connection or network failure.
  bool get connectionError => code == null;

  /// True if [code] is 401 Unauthorized.
  bool get isUnauthorized => code == unauthorized;

  /// True if [code] is 403 Forbidden.
  bool get isForbidden => code == forbidden;

  /// True if [code] is 404 Not Found.
  bool get isNotFound => code == notFound;

  /// True if [code] is between 500 and 599, indicating server-side error.
  bool get isServerError => between(internalServerError, networkConnectTimeoutError);

  /// Checks if [code] falls inclusively between [begin] and [end].
  bool between(int begin, int end) {
    return !connectionError && code! >= begin && code! <= end;
  }

  /// True if [code] is a 2xx success status.
  bool get isOk => between(200, 299);

  /// True if [code] is not successful (i.e., not 2xx).
  bool get hasError => !isOk;
}