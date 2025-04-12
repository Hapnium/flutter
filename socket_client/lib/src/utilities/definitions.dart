import '../../socket_client.dart';

/// Signature for a callback function that handles responses from a socket.
///
/// The `SocketCallback` function receives a single argument,
/// a `SocketResponse` object, which contains information about the
/// received socket message.
typedef SocketCallback = void Function(SocketResponse);

/// Signature for a callback function that handles session events.
///
/// The `SessionCallback` function receives a single argument,
/// a `SessionResponse` object, which contains information about
/// the session event.
typedef SessionCallback = void Function(SessionResponse);

/// Signature for a generic callback function with no arguments.
typedef Callback = void Function();

/// Signature for a callback function that handles errors.
///
/// The `ErrorCallback` function receives two arguments:
/// 1. `action`: A string representing the action that failed.
/// 2. `error`: The error object or any other relevant information about the error.
typedef ErrorCallback = void Function(String action, dynamic error);

/// Represents a map of HTTP headers.
///
/// Keys are header names (e.g., 'Content-Type', 'Authorization') and
/// values are their corresponding values.
typedef Headers = Map<String, String>;

/// Represents a generic message structure.
///
/// Typically used to represent messages exchanged over a socket
/// or other communication channels.
///
/// The `Message` typedef defines a map where keys are strings
/// and values can be of any type.
typedef Message = Map<String, dynamic>;