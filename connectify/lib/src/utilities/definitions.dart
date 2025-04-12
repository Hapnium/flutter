import '../../connectify.dart';

/// Signature for a callback function that handles session events.
///
/// The `SessionCallback` function receives a single argument,
/// a `SessionResponse` object, which contains information about
/// the session event.
typedef SessionCallback = void Function(SessionResponse);

/// Signature for a generic callback function with no arguments.
typedef Callback = void Function();

/// Signature for a callback function that provides progress updates.
///
/// The `OnProgressCallback` function receives two integer arguments:
/// 1. `current`: The current progress value.
/// 2. `total`: The total number of steps or the total size of the operation.
typedef OnProgressCallback = void Function(int current, int total);

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

/// Represents a map of HTTP headers.
///
/// Keys are header names (e.g., 'Content-Type', 'Authorization') and
/// values are their corresponding values.
typedef Headers = Map<String, String>;