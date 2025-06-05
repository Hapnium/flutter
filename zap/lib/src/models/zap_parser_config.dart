import '../http/utils/http_status.dart';

/// Signature for a data parser function that converts raw response data to a specific type.
///
/// The `DataParser` function receives the raw data from the API response
/// and should return a parsed object of type T.
///
/// Example:
/// ```dart
/// DataParser<User> userParser = (data) => User.fromJson(data);
/// DataParser<List<Post>> postsParser = (data) => (data as List)
///     .map((item) => Post.fromJson(item))
///     .toList();
/// ```
typedef DataParser<T> = T Function(dynamic data);

/// A map that associates HTTP status codes with their corresponding data parsers.
///
/// The key is the HTTP status code (e.g., 200, 400, 429) and the value is
/// a `DataParser<T>` function that knows how to parse the response data for that status.
///
/// Example:
/// ```dart
/// MultiParser<dynamic> parsers = {
///   200: (data) => SuccessResponse.fromJson(data),
///   400: (data) => ErrorResponse.fromJson(data),
///   429: (data) => RateLimitResponse.fromJson(data),
/// };
/// ```
typedef MultiParser<T> = Map<HttpStatus, DataParser<T>>;

/// Configuration class for handling response data parsing in ZapPulse HTTP requests.
///
/// `ZapDataParser` allows you to define how response data should be parsed based on
/// HTTP status codes. This is particularly useful when APIs return different response
/// structures for success, error, rate limiting, and other scenarios.
///
/// ## Features
///
/// - **Single Parser**: Use one parser for all responses (backward compatible)
/// - **Multi Parser**: Define different parsers for different HTTP status codes
/// - **Fallback Parser**: Provide a default parser when no status-specific parser is found
/// - **Flexible Parsing**: Handle complex API responses with varying structures
///
/// ## Usage Examples
///
/// ### Single Parser (Backward Compatible)
/// ```dart
/// final response = await server.get<EmailCheckResponse>(
///   endpoint: "/v1/auth/check",
///   query: {
///     "email_address": emailController.text.trim(),
///     "scope": "EMAIL_CHECK"
///   },
///   useAuth: false,
///   parser: ZapDataParser.single((data) => EmailCheckResponse.fromJson(data))
/// );
/// ```
///
/// ### Multiple Parsers for Different Status Codes
/// ```dart
/// final response = await server.get<dynamic>(
///   endpoint: "/v1/auth/check",
///   query: {
///     "email_address": emailController.text.trim(),
///     "scope": "EMAIL_CHECK"
///   },
///   useAuth: false,
///   parser: ZapDataParser.multi({
///     200: (data) => EmailCheckResponse.fromJson(data),
///     400: (data) => ValidationErrorResponse.fromJson(data),
///     429: (data) => RateLimitResponse.fromJson(data),
///     500: (data) => ServerErrorResponse.fromJson(data),
///   })
/// );
/// ```
///
/// ### With Default Fallback Parser
/// ```dart
/// final response = await server.get<dynamic>(
///   endpoint: "/v1/auth/check",
///   query: {
///     "email_address": emailController.text.trim(),
///     "scope": "EMAIL_CHECK"
///   },
///   useAuth: false,
///   parser: ZapDataParser(
///     defaultParser: (data) => GenericResponse.fromJson(data),
///     statusParsers: {
///       200: (data) => EmailCheckResponse.fromJson(data),
///       400: (data) => ValidationErrorResponse.fromJson(data),
///     }
///   )
/// );
/// ```
///
/// ## Parser Selection Logic
///
/// 1. If `statusParsers` is provided, the parser will first look for a parser
///    matching the response's HTTP status code
/// 2. If no status-specific parser is found, it will fall back to `defaultParser`
/// 3. If neither is available, the response data will be returned as-is
///
/// ## Error Handling
///
/// If a parser throws an exception during parsing, ZapPulse will:
/// - Log the error (if error logging is enabled)
/// - Return an error response with details about the parsing failure
/// - Include the original status code for debugging
///
/// ## Best Practices
///
/// - Use `ZapDataParser.single()` for simple APIs with consistent response structure
/// - Use `ZapDataParser.multi()` for APIs that return different structures based on status codes
/// - Always provide a `defaultParser` when using `statusParsers` to handle unexpected status codes
/// - Consider the return type `T` carefully - use `dynamic` when different parsers return different types
/// - Test your parsers with actual API responses to ensure they handle all expected data structures
class ZapDataParser<T> {
  /// The default parser to use when no status-specific parser is found.
  ///
  /// This parser will be used as a fallback when:
  /// - No `statusParsers` are provided
  /// - `statusParsers` are provided but no parser matches the response status code
  ///
  /// If both `defaultParser` and `statusParsers` are null, the response data
  /// will be returned without parsing.
  final DataParser<T>? defaultParser;

  /// A map of HTTP status codes to their corresponding data parsers.
  ///
  /// When a response is received, ZapPulse will look up the response's status code
  /// in this map and use the corresponding parser if found.
  ///
  /// Example:
  /// ```dart
  /// statusParsers: {
  ///   200: (data) => SuccessResponse.fromJson(data),
  ///   400: (data) => ValidationError.fromJson(data),
  ///   401: (data) => AuthError.fromJson(data),
  ///   429: (data) => RateLimitError.fromJson(data),
  ///   500: (data) => ServerError.fromJson(data),
  /// }
  /// ```
  final MultiParser<T>? statusParsers;

  /// Creates a new `ZapDataParser` with optional default and status-specific parsers.
  ///
  /// Parameters:
  /// - [defaultParser]: The fallback parser to use when no status-specific parser matches
  /// - [statusParsers]: A map of status codes to their corresponding parsers
  ///
  /// At least one of [defaultParser] or [statusParsers] should be provided,
  /// otherwise no parsing will occur.
  const ZapDataParser({
    this.defaultParser,
    this.statusParsers,
  });

  /// Creates a `ZapDataParser` with a single parser for all responses.
  ///
  /// This is the backward-compatible way to use parsers and is equivalent to
  /// setting only the [defaultParser].
  ///
  /// Parameters:
  /// - [parser]: The parser function to use for all responses
  ///
  /// Example:
  /// ```dart
  /// ZapDataParser.single((data) => User.fromJson(data))
  /// ```
  const ZapDataParser.single(DataParser<T> parser)
      : defaultParser = parser,
        statusParsers = null;

  /// Creates a `ZapDataParser` with multiple status-specific parsers.
  ///
  /// This constructor is useful when you want different parsing logic for
  /// different HTTP status codes without a default fallback.
  ///
  /// Parameters:
  /// - [parsers]: A map of status codes to their corresponding parser functions
  ///
  /// Example:
  /// ```dart
  /// ZapDataParser.multi({
  ///   200: (data) => SuccessResponse.fromJson(data),
  ///   400: (data) => ErrorResponse.fromJson(data),
  /// })
  /// ```
  const ZapDataParser.multi(MultiParser<T> parsers)
      : defaultParser = null,
        statusParsers = parsers;

  /// Determines if this parser configuration has any parsing capability.
  ///
  /// Returns `true` if either [defaultParser] or [statusParsers] is provided.
  bool get hasParser => defaultParser != null || statusParsers != null;

  /// Gets the appropriate parser for the given HTTP status code.
  ///
  /// Returns the status-specific parser if available, otherwise returns
  /// the default parser. Returns `null` if no suitable parser is found.
  ///
  /// Parameters:
  /// - [statusCode]: The HTTP status code to find a parser for
  ///
  /// Returns:
  /// - The status-specific parser if found in [statusParsers]
  /// - The [defaultParser] if no status-specific parser is found
  /// - `null` if no parser is available
  DataParser<T>? getParser(HttpStatus statusCode) {
    if(hasParserForStatus(statusCode)) {
      return statusParsers![statusCode];
    }

    return defaultParser;
  }

  /// Checks if a specific status code has a dedicated parser.
  ///
  /// Parameters:
  /// - [statusCode]: The HTTP status code to check
  ///
  /// Returns `true` if there's a parser specifically for this status code.
  bool hasParserForStatus(HttpStatus statusCode) {
    return supportedStatusCodes.contains(statusCode);
  }

  /// Returns a list of all status codes that have dedicated parsers.
  ///
  /// Returns an empty list if no status-specific parsers are configured.
  List<HttpStatus> get supportedStatusCodes {
    return statusParsers?.keys.toList() ?? [];
  }
}