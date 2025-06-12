import 'http/utils/http_status.dart';
import 'enums/zync_state.dart';
import 'models/session_response.dart';
import 'models/zync_response.dart';

/// Signature for a callback function that handles responses from a socket.
///
/// The `RealtimeCallback` function receives a single argument,
/// a `ZyncResponse` object, which contains information about the
/// received socket message.
typedef RealtimeCallback = void Function(ZyncResponse);

/// Signature for a callback function that handles errors.
/// 
/// The `ErrorCallback` function receives two arguments:
/// 1. `where`: A string representing the location where the error occurred.
/// 2. `error`: The error object or any other relevant information about the error.
typedef ErrorCallback = void Function(String where, dynamic error);

/// Signature for a callback function that handles connection state changes.
/// 
/// The `StateCallback` function receives a single argument,
/// a `ZyncState` object, which contains information about the
/// connection state.
typedef StateCallback = void Function(ZyncState state);

/// Signature for a callback function that handles session events.
///
/// The `SessionCallback` function receives a single argument,
/// a `SessionResponse` object, which contains information about
/// the session event.
typedef SessionCallback = SessionResponse? Function();

/// Signature for a callback function that handles session events.
///
/// The `AsyncSessionCallback` function returns a `SessionResponse` or `null` object when completed
typedef AsyncSessionCallback = Future<SessionResponse?> Function();

/// Signature for a callback function that builds headers.
///
/// The `HeaderBuilder` function receives a `SessionResponse` object and returns a `Headers` object.
typedef HeaderBuilder = Headers Function(SessionResponse session);

/// Signature for a generic callback function with no arguments.
typedef Callback = void Function();

/// Represents a map of HTTP headers.
///
/// Keys are header names (e.g., 'Content-Type', 'Authorization') and
/// values are their corresponding values.
typedef Headers = Map<String, String>;

/// Represents a stream of bytes as the body of a request or response.
/// 
/// This is used to represent the body of a request or response.
typedef BodyByteStream = Stream<BodyBytes>;

/// Represents a list of bytes as the body of a request or response.
/// 
/// This is used to represent the body of a request or response.
typedef BodyBytes = List<int>;

/// Represents a generic message structure.
///
/// Typically used to represent messages exchanged over a socket
/// or other communication channels.
///
/// The `Payload` typedef defines a map where keys are strings
/// and values can be of any type.
typedef Payload = Map<String, dynamic>;

/// Signature for representing request parameters as a map.
///
/// The `RequestParam` typedef defines a map where keys are strings
/// and values can be of any type.
typedef RequestParam = Map<String, dynamic>;

/// Signature for representing the request body.
///
/// The `RequestBody` typedef can represent any type of data
/// that can be sent as the request body, such as
/// `Map`, `List`, `String`, or custom objects.
typedef RequestBody = dynamic;

/// A function that decodes the response body into a specific type [T].
typedef ResponseDecoder<T> = T Function(HttpStatus status, dynamic data);

/// A function used to track upload progress by returning the current percentage (0.0 - 100.0).
typedef Progress = Function(double percent);

/// A function used to find the proxy server to use for a given request URL.
/// 
/// The `ProxyFinder` function receives a `Uri` object and returns a string
/// 
/// Example:
/// ```dart
/// ProxyFinder proxyFinder = (url) => 'http://proxy.example.com:8080';
/// ```
typedef ProxyFinder = String Function(Uri url);