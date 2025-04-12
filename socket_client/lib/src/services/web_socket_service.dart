import 'dart:async';

import 'package:socket_client/socket_client.dart';

/// Abstract class defining the structure for a WebSocket service using the STOMP protocol.
///
/// This interface provides a standardized approach for managing WebSocket connections,
/// sending messages, and handling state and data streams, ensuring easy integration into applications.
abstract class WebSocketService {
  /// This method is now deprecated and will be removed in the new versions of WebSocket.
  /// It does not initialize the web socket instance. Please use
  /// `WebSocket.create(config: SocketConfig())` instead.
  ///
  /// Initializes the WebSocket connection with the provided configuration.
  ///
  /// This method must be called before using the WebSocket service.
  ///
  /// @param config The [SocketConfig] object containing configuration details such as
  /// the WebSocket endpoint, headers, and connection mode.
  @deprecated
  void init({required SocketConfig config});

  /// Indicates whether the WebSocket connection is currently active.
  ///
  /// @return `true` if the WebSocket connection is active and ready for communication;
  /// otherwise, `false`.
  bool get isConnected;

  /// A [StreamController] that provides updates on the WebSocket's connection state.
  ///
  /// Emits [ConnectionState] values, allowing subscribers to track lifecycle changes such as
  /// connecting, connected, or disconnected states.
  StreamController<ConnectionState> get connectionStateController;

  /// A [StreamController] for error data received through the WebSocket.
  ///
  /// Emits [SocketErrorResponse] objects containing where the error occurred and any extra data to show details.
  StreamController<SocketErrorResponse> get errorController;

  /// A [StreamController] for incoming data received through the WebSocket.
  ///
  /// Emits [SocketResponse] objects containing metadata, headers, and body of messages.
  /// Subscribers can process WebSocket messages using this stream.
  StreamController<SocketResponse> get dataController;

  /// A [Stream] providing real-time updates on the WebSocket's connection state.
  ///
  /// Subscribers receive [ConnectionState] values to monitor connection lifecycle changes.
  Stream<ConnectionState> get connectionStateStream;

  /// A [Stream] for processing incoming WebSocket data.
  ///
  /// Emits [SocketResponse] objects with metadata, headers, and body of received messages.
  Stream<SocketResponse> get dataStream;

  /// A [Stream] for processing incoming WebSocket error.
  ///
  /// Emits [SocketErrorResponse] objects with metadata, headers, and body of received messages.
  Stream<SocketErrorResponse> get errorStream;

  /// Sends a message to a specified destination via the WebSocket connection.
  ///
  /// @param endpoint The destination (e.g., topic or endpoint) for the message.
  /// @param message An optional map of message headers.
  /// @param data The message body to send; defaults to an empty string if not provided.
  ///
  /// Ensures the message is sent only when the WebSocket is connected. Logs and handles errors
  /// during the message-sending process.
  void send({required String endpoint, Message? message, String data = ""});

  /// Disconnects the WebSocket connection and releases resources.
  ///
  /// Call this method to cleanly terminate the connection when the WebSocket is no longer needed,
  /// avoiding unnecessary resource usage.
  void disconnect();
}