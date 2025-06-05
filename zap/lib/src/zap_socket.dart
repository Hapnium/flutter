// Import the correct socket implementation based on platform.
// - On web (with `dart:js_interop`), it imports 'html_socket.dart'.
// - On native platforms (mobile, desktop, server with `dart:io`), it imports 'io_socket.dart'.
// - If neither is available, it falls back to 'socket_stub.dart', which throws errors.
//
// This allows ZapSocket to work cross-platform without manually switching imports.
import 'socket/stub_socket.dart'
    if (dart.library.js_interop) 'socket/html_socket.dart'
    if (dart.library.io) 'socket/io_socket.dart';

/// [ZapSocket] is a platform-agnostic WebSocket abstraction that delegates
/// to the correct implementation based on where the app is running:
///
/// - On **web**, it uses `BaseWebSocket` from `html_socket.dart`.
/// - On **mobile/server/desktop**, it uses `BaseWebSocket` from `io_socket.dart`.
/// - If neither `dart:io` nor `dart:js_interop` is available, it throws via `socket_stub.dart`.
///
/// This class allows the rest of your app to use a consistent WebSocket API,
/// while the implementation details (HTML vs IO sockets) are handled automatically.
///
/// ### Example usage:
/// ```dart
/// final socket = ZapSocket('wss://example.com/socket');
/// socket.connect();
/// socket.onOpen(() => print('Connected'));
/// socket.onMessage((msg) => print('Received: $msg'));
/// socket.emit('chat', {'message': 'Hi!'});
/// ```
class ZapSocket extends BaseWebSocket {
  /// Constructs a [ZapSocket] with a given WebSocket [url].
  ///
  /// The [ping] duration determines how often a ping message is sent to keep the
  /// connection alive. The default is 5 seconds.
  ///
  /// If [allowSelfSigned] is true, connections to servers with self-signed
  /// SSL certificates may be allowed (on supported platforms).
  ///
  /// The actual behavior of this constructor is determined by the imported
  /// platform-specific `BaseWebSocket` implementation.
  ZapSocket(
    super.url, {
    super.ping,
    super.allowSelfSigned,
  });
}