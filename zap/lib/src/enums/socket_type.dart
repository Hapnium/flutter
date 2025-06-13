/// Defines all supported socket operation types that can occur in a real-time connection.
/// 
/// This enum is used to represent the various lifecycle events, commands,
/// and message types involved in working with a socket connection.
/// These types can be used to control socket behavior, handle incoming events,
/// or classify outgoing messages.
enum SocketType {
  /// Initiates a new socket connection to the server.
  /// 
  /// This should be the first step in setting up a socket-based communication.
  /// Typically results in a `connect` event on the server.
  connect,

  /// Gracefully closes the existing socket connection.
  /// 
  /// Use this to shut down the socket when the user logs out or the app is terminated.
  disconnect,

  /// Attempts to re-establish a lost or closed socket connection.
  /// 
  /// Useful in retry strategies or when handling temporary network issues.
  reconnect,

  /// Indicates an error occurred during socket communication.
  /// 
  /// This may be emitted by the socket framework or caught during custom message handling.
  error,

  /// Sends a message or payload to the server over the socket.
  /// 
  /// Usually includes event name and data payload.
  /// This corresponds to emitting messages to the server.
  send,

  /// Represents data received from the socket server.
  /// 
  /// This type is commonly used in listeners or stream handlers
  /// when reacting to server-side events.
  receive,

  /// Sends a heartbeat ping to the server to keep the connection alive.
  /// 
  /// Many servers expect regular pings to detect dropped connections.
  ping,

  /// Acknowledges receipt of a ping, usually sent by the server in response.
  /// 
  /// Used in conjunction with `ping` to ensure connection health.
  pong,

  /// Fired when the socket connection is successfully established.
  /// 
  /// Can be used to trigger UI updates or send initial data.
  open,

  /// Fired when the socket connection is closed.
  /// 
  /// Can be used to trigger reconnection attempts or inform the user.
  close,

  /// Indicates the connection or request took too long and timed out.
  /// 
  /// Often results in a reconnect attempt or error display.
  timeout,

  /// Retries a previously failed message or connection attempt.
  /// 
  /// This type supports resiliency mechanisms such as exponential backoff.
  retry,

  /// Subscribes to a channel, room, or topic for scoped messages.
  /// 
  /// Common in systems like Socket.IO or pub-sub models.
  subscribe,

  /// Unsubscribes from a channel, room, or topic.
  /// 
  /// Use when the user leaves a context or to clean up listeners.
  unsubscribe,

  /// Handles socket-level authentication, often via tokens.
  /// 
  /// This event is used to verify and authorize a user on connection.
  auth,

  /// Acknowledgment received for a previously sent message.
  /// 
  /// This confirms that the server received and processed the message.
  ack,

  /// Negative acknowledgment indicating an error or failure.
  /// 
  /// Indicates the message was rejected or could not be processed.
  nack,
}