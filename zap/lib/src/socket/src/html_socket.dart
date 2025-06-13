import 'dart:async';
import 'dart:js_interop';

import 'package:tracing/tracing.dart' show console;
import 'package:web/web.dart' as html;

import '../../enums/socket_type.dart';
import '../../models/socket_messenger.dart';
import 'socket_close.dart';
import 'socket_interface.dart';
import 'socket_notifier.dart';
import '../../enums/socket_status.dart';

/// A concrete WebSocket implementation for browser environments using `package:web`.
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
  /// Underlying WebSocket instance from the `web` package.
  html.WebSocket? socket;

  /// Socket event notifier for managing subscribers and dispatch.
  SocketNotifier? socketNotifier = SocketNotifier();

  /// Whether this socket has been disposed.
  bool isDisposed = false;

  /// The current connection status.
  SocketStatus? connectionStatus;

  /// Timer used for sending periodic ping messages.
  Timer? _t;

  /// Creates a new [BaseWebSocket] instance.
  ///
  /// The [url] is automatically converted from HTTP(S) to WS(S).
  /// For example, `https://example.com` becomes `wss://example.com`.
  BaseWebSocket(
    super.url, {
    super.ping = const Duration(seconds: 5),
    super.allowSelfSigned = true,
  }) {
    url = url.startsWith('https')
        ? url.replaceAll('https:', 'wss:')
        : url.replaceAll('http:', 'ws:');
  }

  /// Closes the WebSocket connection.
  ///
  /// Optionally provides a [status] code and [reason] message.
  /// Handles quirks in the `web` package regarding optional parameters.
  @override
  void close([int? status, String? reason]) {
    if (status != null && reason != null) {
      socket?.close(status, reason);
    } else if (status != null) {
      socket?.close(status);
    } else {
      socket?.close();
    }
  }

  // ignore: use_setters_to_change_properties
  @override
  Future<void> connect() async {
    try {
      connectionStatus = SocketStatus.connecting;
      socket = html.WebSocket(url);
      socket!.onOpen.listen((e) {
        socketNotifier?.open();
        _t = Timer?.periodic(ping, (t) {
          socket!.send(''.toJSBox);
        });
        connectionStatus = SocketStatus.connected;
      });

      socket!.onMessage.listen((event) {
        socketNotifier!.notifyData(event.data);
      });

      socket!.onClose.listen((e) {
        _t?.cancel();

        connectionStatus = SocketStatus.closed;
        socketNotifier!.notifyClose(SocketClose(e.reason, e.code));
      });
      socket!.onError.listen((event) {
        _t?.cancel();
        socketNotifier!.notifyError(SocketClose(event.toString(), 0));
        connectionStatus = SocketStatus.closed;
      });
    } on Exception catch (e) {
      _t?.cancel();
      socketNotifier!.notifyError(SocketClose(e.toString(), 500));
      connectionStatus = SocketStatus.closed;
      //  close(500, e.toString());
    }
  }

  @override
  void dispose() {
    socketNotifier?.dispose();
    socketNotifier = null;
    isDisposed = true;
  }

  @override
  void emit(SocketType command, dynamic data) {
    send(SocketMessenger.simple(command: command, data: data).encode());
  }

  @override
  void on(SocketType command, MessageSocket message) {
    socketNotifier?.addEvents(command, message);
  }

  @override
  void onClose(CloseSocket fn) {
    socketNotifier?.addCloses(fn);
  }

  @override
  void onError(CloseSocket fn) {
    socketNotifier?.addErrors(fn);
  }

  @override
  void onMessage(MessageSocket fn) {
    socketNotifier?.addMessages(fn);
  }

  @override
  void onOpen(OpenSocket fn) {
    socketNotifier?.open = fn;
  }
  
  @override
  void send(Object data) {
    if (connectionStatus == SocketStatus.closed) {
      connect();
    }

    if (socket != null && socket!.readyState == html.WebSocket.OPEN) {
      socket!.send(data.toJSBox);
    } else {
      console.log('WebSocket not connected, message $data not sent');
    }
  }
}