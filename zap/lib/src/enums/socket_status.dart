/// Represents the current state of a WebSocket connection.
///
/// This enum is used to track and respond to changes in the socket's lifecycle,
/// allowing the app to update its behavior or UI accordingly.
///
/// ### Usage Example:
/// ```dart
/// if (socket.connectionStatus == SocketStatus.connected) {
///   print('Socket is ready to send and receive data.');
/// }
/// ```
enum SocketStatus {
  /// Indicates the socket is in the process of establishing a connection.
  ///
  /// This status is typically set immediately after the `connect()` method
  /// is called but before the connection has been successfully opened.
  connecting,

  /// Indicates the socket connection is successfully established.
  ///
  /// Once in this state, data can be sent and received over the WebSocket.
  connected,

  /// Indicates the socket has been closed or encountered an error that
  /// resulted in disconnection.
  ///
  /// After reaching this state, the socket is no longer active. You may need to
  /// attempt reconnection or handle cleanup.
  closed,
}
