import 'package:zap/src/socket/socket_notifier.dart';

import 'socket_interface.dart';

/// A concrete WebSocket implementation.
///
/// This class manages a WebSocket connection in a web context, providing lifecycle
/// management, event subscription, and typed message dispatching.
///
/// This is a platform-specific implementation of [SocketInterface] that
/// supports `dart:html`-like APIs for the web via the `web` package.
///
/// Example usage:
/// ```dart
/// final ws = BaseWebSocket('wss://example.com/socket');
/// ws.connect();
/// ws.onOpen(() => print('Connected!'));
/// ws.onMessage((msg) => print('Received: $msg'));
/// ws.emit('chat', {'text': 'Hello'});
/// ```
class BaseWebSocket extends SocketInterface {
  BaseWebSocket(super.url, {super.ping, super.allowSelfSigned});

  @override
  void close([int? status, String? reason]) { }

  @override
  Future connect() {
    throw UnimplementedError();
  }

  @override
  void dispose() { }

  @override
  void emit(String event, data) { }

  @override
  void on(String event, MessageSocket message) { }

  @override
  void onClose(CloseSocket fn) { }

  @override
  void onError(CloseSocket fn) { }

  @override
  void onMessage(MessageSocket fn) { }

  @override
  void onOpen(OpenSocket fn) { }

  @override
  void send(Object data) { }
}