// ignore_for_file: unintended_html_in_doc_comment

import '../http/utils/http_status.dart';
import 'zap_page.dart';

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

/// Configuration class for handling response data parsing in Flux HTTP requests.
///
/// `ResponseParser` allows you to define how response data should be parsed based on
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
///   parser: ResponseParser.single((data) => EmailCheckResponse.fromJson(data))
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
///   parser: ResponseParser.multi({
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
///   parser: ResponseParser(
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
/// If a parser throws an exception during parsing, Flux will:
/// - Log the error (if error logging is enabled)
/// - Return an error response with details about the parsing failure
/// - Include the original status code for debugging
///
/// ## Best Practices
///
/// - Use `ResponseParser.single()` for simple APIs with consistent response structure
/// - Use `ResponseParser.multi()` for APIs that return different structures based on status codes
/// - Always provide a `defaultParser` when using `statusParsers` to handle unexpected status codes
/// - Consider the return type `T` carefully - use `dynamic` when different parsers return different types
/// - Test your parsers with actual API responses to ensure they handle all expected data structures
class ResponseParser<T> {
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
  /// When a response is received, Flux will look up the response's status code
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

  /// Creates a new `ResponseParser` with optional default and status-specific parsers.
  ///
  /// Parameters:
  /// - [defaultParser]: The fallback parser to use when no status-specific parser matches
  /// - [statusParsers]: A map of status codes to their corresponding parsers
  ///
  /// At least one of [defaultParser] or [statusParsers] should be provided,
  /// otherwise no parsing will occur.
  const ResponseParser({
    this.defaultParser,
    this.statusParsers,
  });

  /// Creates a `ResponseParser` with a single parser for all responses.
  ///
  /// This is the backward-compatible way to use parsers and is equivalent to
  /// setting only the [defaultParser].
  ///
  /// Parameters:
  /// - [parser]: The parser function to use for all responses
  ///
  /// Example:
  /// ```dart
  /// ResponseParser.single((data) => User.fromJson(data))
  /// ```
  const ResponseParser.single(DataParser<T> parser)
      : defaultParser = parser,
        statusParsers = null;

  /// Creates a `ResponseParser` with multiple status-specific parsers.
  ///
  /// This constructor is useful when you want different parsing logic for
  /// different HTTP status codes without a default fallback.
  ///
  /// Parameters:
  /// - [parsers]: A map of status codes to their corresponding parser functions
  ///
  /// Example:
  /// ```dart
  /// ResponseParser.multi({
  ///   200: (data) => SuccessResponse.fromJson(data),
  ///   400: (data) => ErrorResponse.fromJson(data),
  /// })
  /// ```
  const ResponseParser.multi(MultiParser<T> parsers)
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

  // === HELPER PARSER METHODS ===

  /// Creates a parser that converts response data to a List<R> using the provided item parser.
  ///
  /// This helper automatically handles the list conversion and maps each item through
  /// the provided parser function.
  ///
  /// Example:
  /// ```dart
  /// // Parse a list of users
  /// final parser = ResponseParser.parseAsList<User>((data) => User.fromJson(data));
  /// 
  /// // Use with multi-parser
  /// final multiParser = ResponseParser.multi({
  ///   200: ResponseParser.parseAsList<Post>((data) => Post.fromJson(data)),
  ///   400: (data) => ErrorResponse.fromJson(data),
  /// });
  /// ```
  static DataParser<List<R>> parseAsList<R>(DataParser<R> itemParser) {
    return (dynamic data) {
      if (data == null) return <R>[];
      
      final List<dynamic> list = data is List ? data : [data];
      return list.map((item) => itemParser(item)).toList();
    };
  }

  /// Creates a parser that safely extracts a nested field from the response data.
  ///
  /// Useful when the actual data is nested within the response structure.
  ///
  /// Example:
  /// ```dart
  /// // Extract data from { "result": { "users": [...] } }
  /// final parser = ResponseParser.parseNested<List<User>>(
  ///   ['result', 'users'],
  ///   ResponseParser.parseAsList<User>((data) => User.fromJson(data))
  /// );
  /// ```
  static DataParser<R> parseNested<R>(List<String> path, DataParser<R> parser) {
    return (dynamic data) {
      dynamic current = data;
      
      for (final key in path) {
        if (current is Map<String, dynamic> && current.containsKey(key)) {
          current = current[key];
        } else {
          throw FormatException('Path $path not found in response data');
        }
      }
      
      return parser(current);
    };
  }

  /// Creates a parser that handles paginated responses with metadata.
  ///
  /// Extracts both the data list and pagination information.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parsePaginated<User>(
  ///   dataKey: 'items',
  ///   itemParser: (data) => User.fromJson(data),
  /// );
  /// ```
  static DataParser<ZapPage<R>> parsePaginated<R>({
    required String dataKey,
    required DataParser<R> itemParser,
    String totalKey = 'total',
    String pageKey = 'page',
    String limitKey = 'limit',
  }) {
    return (dynamic data) {
      if (data is! Map<String, dynamic>) {
        throw FormatException('Expected Map for paginated response');
      }

      final items = parseAsList(itemParser)(data[dataKey]);
      
      return ZapPage<R>(
        data: items,
        total: data[totalKey] as int? ?? 0,
        page: data[pageKey] as int? ?? 1,
        limit: data[limitKey] as int? ?? items.length,
      );
    };
  }

  /// Creates a parser that handles optional/nullable data.
  ///
  /// Returns null if the data is null or missing, otherwise applies the parser.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parseOptional<User>((data) => User.fromJson(data));
  /// ```
  static DataParser<R?> parseOptional<R>(DataParser<R> parser) {
    return (dynamic data) {
      if (data == null) return null;
      return parser(data);
    };
  }

  /// Creates a parser that applies different parsers based on a discriminator field.
  ///
  /// Useful for polymorphic responses where the type is determined by a field value.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parsePolymorphic<Animal>(
  ///   discriminatorKey: 'type',
  ///   parsers: {
  ///     'dog': (data) => Dog.fromJson(data),
  ///     'cat': (data) => Cat.fromJson(data),
  ///   },
  ///   fallbackParser: (data) => GenericAnimal.fromJson(data),
  /// );
  /// ```
  static DataParser<R> parsePolymorphic<R>({
    required String discriminatorKey,
    required Map<String, DataParser<R>> parsers,
    DataParser<R>? fallbackParser,
  }) {
    return (dynamic data) {
      if (data is! Map<String, dynamic>) {
        throw FormatException('Expected Map for polymorphic parsing');
      }

      final discriminator = data[discriminatorKey] as String?;
      if (discriminator != null && parsers.containsKey(discriminator)) {
        return parsers[discriminator]!(data);
      }

      if (fallbackParser != null) {
        return fallbackParser(data);
      }

      throw FormatException('No parser found for discriminator: $discriminator');
    };
  }

  /// Creates a parser that transforms the data before applying another parser.
  ///
  /// Useful for data preprocessing or format conversion.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parseWithTransform<User>(
  ///   transform: (data) => data['user_data'], // Extract nested data
  ///   parser: (data) => User.fromJson(data),
  /// );
  /// ```
  static DataParser<R> parseWithTransform<R>({
    required dynamic Function(dynamic) transform,
    required DataParser<R> parser,
  }) {
    return (dynamic data) {
      final transformed = transform(data);
      return parser(transformed);
    };
  }

  /// Creates a parser that validates data before parsing.
  ///
  /// Throws an exception if validation fails.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parseWithValidation<User>(
  ///   validator: (data) => data is Map && data.containsKey('id'),
  ///   parser: (data) => User.fromJson(data),
  ///   errorMessage: 'Invalid user data structure',
  /// );
  /// ```
  static DataParser<R> parseWithValidation<R>({
    required bool Function(dynamic) validator,
    required DataParser<R> parser,
    String errorMessage = 'Data validation failed',
  }) {
    return (dynamic data) {
      if (!validator(data)) {
        throw FormatException(errorMessage);
      }
      return parser(data);
    };
  }

  /// Creates a parser that handles both single items and arrays uniformly.
  ///
  /// Always returns a list, converting single items to single-element lists.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.parseAsListOrSingle<User>((data) => User.fromJson(data));
  /// ```
  static DataParser<List<R>> parseAsListOrSingle<R>(DataParser<R> itemParser) {
    return (dynamic data) {
      if (data == null) return <R>[];
      
      if (data is List) {
        return data.map((item) => itemParser(item)).toList();
      } else {
        return [itemParser(data)];
      }
    };
  }

  // === CONVENIENCE CONSTRUCTORS USING HELPERS ===

  /// Creates a parser specifically for list responses.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.forList<User>((data) => User.fromJson(data));
  /// ```
  static ResponseParser<List<R>> forList<R>(DataParser<R> itemParser) {
    return ResponseParser.single(parseAsList(itemParser));
  }

  /// Creates a parser for paginated responses.
  ///
  /// Example:
  /// ```dart
  /// final parser = ResponseParser.forPaginated<User>(
  ///   itemParser: (data) => User.fromJson(data),
  /// );
  /// ```
  static ResponseParser<ZapPage<R>> forPaginated<R>({
    required DataParser<R> itemParser,
    String dataKey = 'data',
    String totalKey = 'total',
    String pageKey = 'page',
    String limitKey = 'limit',
  }) {
    return ResponseParser.single(
      parsePaginated(
        dataKey: dataKey,
        itemParser: itemParser,
        totalKey: totalKey,
        pageKey: pageKey,
        limitKey: limitKey,
      ),
    );
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