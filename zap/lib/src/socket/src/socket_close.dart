/// {@template socket_close}
/// Wrapper class to encapsulate information about a socket close event.
///
/// This class is used by [SocketNotifier] to provide structured information
/// when a WebSocket connection is closed or encounters an error.
///
/// It includes both a human-readable message and a numeric reason code
/// (typically aligned with the WebSocket close status codes).
///
/// ### Example:
/// ```dart
/// socketNotifier.addCloses((SocketClose close) {
///   print(close); // e.g., Closed by server [1000 => Normal Closure]!
/// });
/// ```
/// 
/// {@endtemplate}
class SocketClose {
  /// A textual explanation of the reason for the socket closure.
  ///
  /// This can be provided by the server or constructed internally to
  /// describe why the socket was closed or failed.
  final String? message;

  /// A numeric reason code for the closure, typically matching
  /// WebSocket close codes (e.g., 1000 for normal closure).
  ///
  /// This helps with debugging and protocol-specific handling.
  final int? reason;

  /// Constructs a [SocketClose] object with a [message] and [reason].
  /// 
  /// {@macro socket_close}
  SocketClose(this.message, this.reason);

  @override
  String toString() {
    return 'Closed by server [$reason => $message]!';
  }
}