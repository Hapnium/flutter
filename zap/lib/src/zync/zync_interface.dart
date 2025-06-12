import 'dart:async';

import '../definitions.dart';
import '../enums/zync_state.dart';
import '../models/zync_error_response.dart';
import '../models/zync_response.dart';

/// Abstract interface defining the contract for Zync WebSocket operations.
/// 
/// This interface ensures consistent method signatures for real-time communication
/// including connection management, message sending, and event handling.
abstract class ZyncInterface {
  /// Whether the WebSocket connection is currently active and ready.
  bool get isConnected;

  /// Current connection state.
  ZyncState get connectionState;

  /// Stream controller for connection state changes.
  StreamController<ZyncState> get connectionStateController;

  /// Stream controller for error events.
  StreamController<ZyncErrorResponse> get errorController;

  /// Stream controller for incoming data/messages.
  StreamController<ZyncResponse> get dataController;

  /// Stream for monitoring connection state changes.
  Stream<ZyncState> get connectionStateStream;

  /// Stream for processing incoming WebSocket data.
  Stream<ZyncResponse> get dataStream;

  /// Stream for processing WebSocket errors.
  Stream<ZyncErrorResponse> get errorStream;

  /// Connects to the WebSocket server.
  /// 
  /// Returns a Future that completes when the connection is established
  /// or fails with an error.
  Future<void> connect();

  /// Disconnects from the WebSocket server and cleans up resources.
  void disconnect();

  /// Sends a message to a specified endpoint/topic.
  /// 
  /// - [endpoint]: The destination topic or endpoint
  /// - [data]: The message data to send
  /// - [headers]: Optional additional headers
  void send({required String endpoint, required dynamic data, Headers? headers});

  /// Subscribes to a specific topic/channel for receiving messages.
  /// 
  /// - [topic]: The topic or channel to subscribe to
  /// - [onMessage]: Callback for when messages are received on this topic
  void subscribe({required String topic, required void Function(ZyncResponse) onMessage});

  /// Unsubscribes from a specific topic/channel.
  /// 
  /// - [topic]: The topic or channel to unsubscribe from
  void unsubscribe(String topic);

  /// Registers a listener for a specific event type.
  /// 
  /// - [event]: The event type to listen for
  /// - [callback]: The callback to invoke when the event is received
  void on(String event, void Function(dynamic data) callback);

  /// Removes a listener for a specific event type.
  /// 
  /// - [event]: The event type to stop listening for
  void off(String event);

  /// Emits an event with data to the server.
  /// 
  /// - [event]: The event type to emit
  /// - [data]: The data to send with the event
  void emit(String event, dynamic data);
}