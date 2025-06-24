import '../socket/socket_client.dart';

/// {@template zap_socket}
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
/// 
/// {@endtemplate}
class ZapSocket extends SocketClient {
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
  /// 
  /// {@macro zap_socket}
  ZapSocket(
    super.url, {
    super.ping,
    super.allowSelfSigned,
  });
}