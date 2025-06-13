import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tracing/tracing.dart' show console;

import '../../definitions.dart';
import '../../enums/socket_type.dart';
import '../../models/socket_messenger.dart';
import 'socket_close.dart';
import 'socket_interface.dart';
import 'socket_notifier.dart';
import '../../enums/socket_status.dart';

class BaseWebSocket extends SocketInterface {
  /// Underlying WebSocket instance from the `dart:io` package.
  WebSocket? socket;

  /// Socket event notifier for managing subscribers and dispatch.
  SocketNotifier? socketNotifier = SocketNotifier();

  /// Whether this socket has been disposed.
  bool isDisposed = false;

  /// The current connection status.
  SocketStatus? connectionStatus;

  BaseWebSocket(
    super.url, {
    super.ping = const Duration(seconds: 5),
    super.allowSelfSigned = true,
  });

  @override
  void close([int? status, String? reason]) {
    socket?.close(status, reason);
  }

  // ignore: use_setters_to_change_properties
  @override
  Future<void> connect() async {
    if (isDisposed) {
      socketNotifier = SocketNotifier();
    }

    try {
      connectionStatus = SocketStatus.connecting;
      socket = allowSelfSigned ? await _connectForSelfSignedCert(url) : await WebSocket.connect(url);

      socket!.pingInterval = ping;
      socketNotifier?.open();
      connectionStatus = SocketStatus.connected;

      socket!.listen((data) {
        socketNotifier!.notifyData(data);
      }, onError: (err) {
        socketNotifier!.notifyError(SocketClose(err.toString(), 1005));
      }, onDone: () {
        connectionStatus = SocketStatus.closed;
        socketNotifier!.notifyClose(SocketClose('Connection Closed', socket!.closeCode));
      }, cancelOnError: true);

      return;
    } on SocketException catch (e) {
      connectionStatus = SocketStatus.closed;
      socketNotifier!.notifyError(SocketClose(e.osError!.message, e.osError!.errorCode));
      
      return;
    }
  }

  @override
  void dispose() {
    socketNotifier!.dispose();
    socketNotifier = null;
    isDisposed = true;
  }

  @override
  void emit(SocketType command, dynamic data) {
    send(SocketMessenger.simple(command: command, data: data).encode());
  }

  @override
  void on(SocketType command, MessageSocket message) {
    socketNotifier!.addEvents(command, message);
  }

  @override
  void onClose(CloseSocket fn) {
    socketNotifier!.addCloses(fn);
  }

  @override
  void onError(CloseSocket fn) {
    socketNotifier!.addErrors(fn);
  }

  @override
  void onMessage(MessageSocket fn) {
    socketNotifier!.addMessages(fn);
  }

  // ignore: use_setters_to_change_properties
  @override
  void onOpen(OpenSocket fn) {
    socketNotifier!.open = fn;
  }

  @override
  void send(dynamic data) async {
    if (connectionStatus == SocketStatus.closed) {
      await connect();
    }

    if (socket != null) {
      socket!.add(data);
    }
  }

  Future<WebSocket> _connectForSelfSignedCert(String url) async {
    try {
      var r = Random();
      var key = base64.encode(BodyBytes.generate(8, (_) => r.nextInt(255)));
      var client = HttpClient(context: SecurityContext());
      client.badCertificateCallback = (cert, host, port) {
        console.log('BaseWebSocket: Allow self-signed certificate => $host:$port. ');
        return true;
      };

      var request = await client.getUrl(Uri.parse(url))
        ..headers.add('Connection', 'Upgrade')
        ..headers.add('Upgrade', 'websocket')
        ..headers.add('Cache-Control', 'no-cache')
        ..headers.add('Sec-WebSocket-Version', '13')
        ..headers.add('Sec-WebSocket-Key', key.toLowerCase());

      var response = await request.close();
      // ignore: close_sinks
      var socket = await response.detachSocket();
      var webSocket = WebSocket.fromUpgradedSocket(
        socket,
        serverSide: false,
      );

      return webSocket;
    } on Exception catch (_) {
      rethrow;
    }
  }
}