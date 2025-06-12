// ignore_for_file: constant_identifier_names

/// The [ZyncState] enum defines the different states in which the WebSocket
/// platform can operate. This enum is useful for managing and tracking the various
/// phases of the WebSocket lifecycle, including connection, subscription, message
/// sending, and disconnection.
///
/// It helps configure environment-specific behaviors, API endpoints, and
/// real-time features depending on the current state of the WebSocket connection.
enum ZyncState {
  /// Represents the state when the WebSocket has not attempted to establish a connection.
  /// The WebSocket is still not ready.
  dormant,

  /// Represents the state when the WebSocket is attempting to establish a connection.
  /// The WebSocket is in the process of connecting to the server.
  connecting,

  /// Represents the state when the WebSocket is successfully connected to the server.
  /// The connection is live and communication can happen.
  connected,

  /// Represents the state when the WebSocket is disconnected from the server.
  /// No data can be sent or received until the WebSocket reconnects.
  disconnected,

  /// Represents the state when the WebSocket is in the process of subscribing to a topic or endpoint.
  /// This state occurs when a subscription request is being made but has not yet completed.
  subscribing,

  /// Represents the state when the WebSocket has successfully subscribed to a topic or endpoint.
  /// The WebSocket is actively listening for incoming messages from the subscribed endpoint.
  subscribed,

  /// Represents the state when the WebSocket is in the process of sending a message to a destination.
  /// This state occurs while the message is being prepared or transmitted.
  sending,

  /// Represents the state when the WebSocket has successfully sent a message to a destination.
  /// The message has been transmitted and acknowledged by the WebSocket client.
  sent,

  /// Represents the state when the WebSocket failed to send a message to a destination.
  /// This state indicates that the message was not successfully delivered due to an error or disconnection.
  notSent,
}