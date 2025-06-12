import '../../exceptions/exceptions.dart';
import 'socket_notifier.dart';

/// An abstract interface for WebSocket connections.
///
/// This class defines the structure for socket implementations that work with
/// `dart:io` or `dart:html`. All methods and the constructor throw an exception
/// unless overridden in a platform-specific implementation.
///
/// Use this class as a common base for platform-dependent WebSocket clients.
/// 
/// Example implementations could use `WebSocket` from `dart:io` (server/native)
/// or `WebSocket` from `dart:html` (browser).
abstract class SocketInterface {
  /// The WebSocket URL to connect to.
  String url;

  /// The interval at which ping messages may be sent.
  ///
  /// Defaults to 5 seconds.
  Duration ping;

  /// Whether to allow connections to self-signed SSL certificates.
  ///
  /// Useful for testing with local or development servers.
  bool allowSelfSigned;

  /// Constructor for initializing the socket connection parameters.
  ///
  /// This constructor throws by default to prevent use without a platform-specific implementation.
  ///
  /// Parameters:
  /// - [url]: The WebSocket server URL.
  /// - [ping]: Optional ping interval.
  /// - [allowSelfSigned]: Whether to allow insecure certificates (default is true).
  SocketInterface(
    this.url, {
    this.ping = const Duration(seconds: 5),
    this.allowSelfSigned = true,
  }) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Connects to the WebSocket server.
  ///
  /// Override this method in concrete implementations.
  Future connect() async {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Registers a callback for when the socket connection is successfully opened.
  ///
  /// [fn] is called when the socket is opened.
  void onOpen(OpenSocket fn) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Registers a callback for when the socket is closed.
  ///
  /// [fn] receives a [SocketClose] object with close information.
  void onClose(CloseSocket fn) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Registers a callback for socket error events.
  ///
  /// [fn] is called when an error occurs, with details provided via [SocketClose].
  void onError(CloseSocket fn) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Registers a callback for incoming messages.
  ///
  /// [fn] will be triggered for every message received on the socket.
  void onMessage(MessageSocket fn) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Registers a named event listener.
  ///
  /// If a message contains a `"type"` field that matches [event],
  /// [message] will be invoked with the corresponding `"data"` value.
  void on(String event, MessageSocket message) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Closes the WebSocket connection.
  ///
  /// Optionally provide a [status] code and [reason] message.
  void close([int? status, String? reason]) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Sends data over the WebSocket connection.
  ///
  /// The [data] can be a String or any serializable object.
  void send(Object data) async {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Disposes of the socket, removing all listeners and closing the connection.
  void dispose() {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }

  /// Emits a named event to the server with optional payload data.
  ///
  /// This sends a JSON message with fields `"type"` and `"data"`.
  void emit(String event, dynamic data) {
    throw ZapException('To use sockets you need dart:io or dart:html');
  }
}