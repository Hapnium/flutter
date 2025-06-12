import 'dart:convert';

import 'socket_close.dart';

/// Signature for a callback that handles socket close events.
/// Used by [SocketNotifier.addCloses].
typedef CloseSocket = void Function(SocketClose);

/// Signature for a callback that handles socket messages.
/// Used by [SocketNotifier.addMessages] and [SocketNotifier.addEvents].
typedef MessageSocket = void Function(dynamic val);

/// Signature for a callback that handles socket opening.
/// Assigned to [SocketNotifier.open].
typedef OpenSocket = void Function();

/// A class to manage WebSocket communications using GetConnect.
///
/// `SocketNotifier` allows registering multiple listeners for:
/// - Incoming messages
/// - Named events
/// - Close events
/// - Error events
///
/// The class acts as an event bus for WebSocket-based applications.
class SocketNotifier {
  /// List of listeners for general messages received over the socket.
  List<void Function(dynamic)>? _onMessages = <MessageSocket>[];

  /// Map of event-specific message listeners, keyed by event name.
  Map<String, void Function(dynamic)>? _onEvents = <String, MessageSocket>{};

  /// List of listeners for socket close events.
  List<void Function(SocketClose)>? _onCloses = <CloseSocket>[];

  /// List of listeners for socket error events.
  List<void Function(SocketClose)>? _onErrors = <CloseSocket>[];

  /// Callback to initiate the opening of the socket connection.
  ///
  /// This must be set externally to define how the socket is opened.
  late OpenSocket open;

  /// Adds a listener for socket close events.
  ///
  /// The provided [socket] callback is triggered when the connection closes.
  void addCloses(CloseSocket socket) {
    _onCloses!.add(socket);
  }

  /// Adds a listener for socket error events.
  ///
  /// The provided [socket] callback is triggered when an error occurs.
  void addErrors(CloseSocket socket) {
    _onErrors!.add((socket));
  }

  /// Adds a named event listener.
  ///
  /// The [event] is a string key to identify the type of message.
  /// The [socket] callback will be triggered if an incoming message
  /// contains the corresponding event type.
  void addEvents(String event, MessageSocket socket) {
    _onEvents![event] = socket;
  }

  /// Adds a general message listener.
  ///
  /// The [socket] callback is triggered on every incoming message,
  /// regardless of event type.
  void addMessages(MessageSocket socket) {
    _onMessages!.add((socket));
  }

  /// Clears all listeners for messages, events, closes, and errors.
  ///
  /// This is useful for cleanup during dispose or logout.
  void dispose() {
    _onMessages = null;
    _onEvents = null;
    _onCloses = null;
    _onErrors = null;
  }

  /// Notifies all registered close listeners with [err].
  ///
  /// Usually called when the WebSocket connection is closed.
  void notifyClose(SocketClose err) {
    for (var item in _onCloses!) {
      item(err);
    }
  }

  /// Notifies all registered message listeners with [data].
  ///
  /// If the message is a string, it is also parsed to check for
  /// named event dispatching via [_tryOn].
  void notifyData(dynamic data) {
    for (var item in _onMessages!) {
      item(data);
    }
    if (data is String) {
      _tryOn(data);
    }
  }

  /// Notifies all registered error listeners with [err].
  ///
  /// Should be called when a socket-related error occurs.
  void notifyError(SocketClose err) {
    for (var item in _onErrors!) {
      item(err);
    }
  }

  /// Attempts to decode a JSON [message] and dispatch to a named event.
  ///
  /// The message should be a JSON string with at least `type` and `data` fields.
  /// If the `type` matches a registered event listener, that listener is invoked.
  void _tryOn(String message) {
    try {
      var msg = jsonDecode(message);
      final event = msg['type'];
      final data = msg['data'];
      if (_onEvents!.containsKey(event)) {
        _onEvents![event]!(data);
      }
    } catch (_) {
      // Ignore malformed JSON or missing fields
      return;
    }
  }
}