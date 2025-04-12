import 'dart:async';
import 'dart:convert';
import 'package:socket_client/socket_client.dart';
import 'package:tracing/tracing.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../utilities/base_url.dart';
import '../web_socket_service.dart';

final class WebSocketImplementation extends SocketClient implements WebSocketService {
  late StompClient _client;

  late SocketConfig _config;
  SocketConfig get config {
    try {
      return _config;
    } catch (e) {
      throw WebSocketException("Call `socket.init()` method to initialize the WebSocket instance");
    }
  }

  StompUnsubscribe? _unsubscribe;
  bool _isActive = false;

  final int SEND_TRIAL_COUNT = 5;
  int send_trials = 0;

  ConnectionState _currentState = ConnectionState.dormant;

  // StreamControllers
  final StreamController<ConnectionState> _connectionStateController = StreamController<ConnectionState>.broadcast();
  final StreamController<SocketResponse> _dataStreamController = StreamController<SocketResponse>.broadcast();
  final StreamController<SocketErrorResponse> _errorStreamController = StreamController<SocketErrorResponse>.broadcast();

  void _updateConnectionState(ConnectionState state) {
    _currentState = state;

    if(!_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
  }

  /// Initializes the WebSocket connection with the provided configuration.
  ///
  /// This method must be called before using the WebSocket service.
  ///
  /// @param config The [SocketConfig] object containing configuration details such as
  /// the WebSocket endpoint, headers, and connection mode.
  WebSocketImplementation(SocketConfig config) {
    _config = config;

    Future.microtask(() => _updateConnectionState(ConnectionState.connecting));

    if (this.config.showConnectionLogs) {
      console.log('Connecting to ${url(_url)}', from: "WebSocket Initialization");
    }

    _client = StompClient(
      config: StompConfig.sockJS(
        url: url(_url),
        webSocketConnectHeaders: _buildHeader(),
        stompConnectHeaders: _buildHeader(),
        onConnect: _onConnect,
        onWebSocketError: _onWebSocketError,
        onStompError: _onStompError,
        onWebSocketDone: _onWebSocketDone,
        onDisconnect: _onDisconnect,
        onDebugMessage: _onDebugMessage,
      ),
    );

    _client.activate();

    if (_client.isActive) {
      _isActive = true;

      _updateConnectionState(ConnectionState.connected);

      if (this.config.showConnectionLogs) {
        console.log('Socket connected for ${url(_url)}', from: "WebSocket Initialization");
      }
    }
  }

  @override
  void init({required SocketConfig config}) {
    throw WebSocketException("This is deprecated and will be removed in the new versions of WebSocket, use the WebSocket.create instance");
  }

  String url(String url) {
    if(config.isWebPlatform) {
      final headers = _buildHeader();
      final queryParams = headers.entries
          .map((entry) => '${Uri.encodeComponent(entry.key)}=${entry.value}')
          .join('&');

      return '$url?$queryParams';
    } else {
      return url;
    }
  }

  String get _url => '$_baseUrl$endpoint';

  String get _baseUrl {
    if(config.baseUrl != null) {
      return config.baseUrl!;
    } else if(config.mode == Server.SANDBOX) {
      return BaseUrl.SANDBOX;
    } else if(config.mode == Server.PORTAL) {
      return BaseUrl.PORTAL_PRODUCTION;
    } else if(config.mode == Server.PRODUCTION) {
      return BaseUrl.PRODUCTION;
    } else {
      throw WebSocketException("You need to provide the base url for this request");
    }
  }

  Headers _buildHeader() {
    Headers headers = {
      'Accept': 'application/json'
    };

    if (config.useToken && config.session != null) {
      String token = 'Bearer ${config.session!.accessToken}';
      headers.update("Authorization", (v) => token, ifAbsent: () => token);
    }

    if (config.headers != null) {
      headers.addAll(config.headers!);
    }

    if (!config.isWebPlatform) {
      String value = 'application/json';
      headers.update('Content-Type', (v) => value, ifAbsent: () => value);
    }

    return headers;
  }

  String get endpoint => config.endpoint ?? "/ws:hapnium";

  void _onConnect(StompFrame frame) {
    _isActive = true;

    if (config.subscription.isNotEmpty) {
      if (config.showConnectionLogs) {
        console.log('Subscribing to WebSocket for ${config.subscription}', from: "WebSocket Subscription");
      }

      _updateConnectionState(ConnectionState.subscribing);

      try {
        _unsubscribe = _client.subscribe(
          destination: config.subscription,
          headers: _buildHeader(),
          callback: (frame) {
            if(isConnected) {
              if(!_dataStreamController.isClosed) {
                Future.microtask(() => _dataStreamController.add(frame.toResponse()));
              }

              config.onReceived(frame.toResponse());
            }
          },
        );

        _updateConnectionState(ConnectionState.subscribed);

        if (config.showConnectionLogs) {
          console.log('Subscribed to ${config.subscription}', from: "WebSocket Subscription");
        }
      } catch (e) {
        _updateConnectionState(ConnectionState.connected);

        if(!_errorStreamController.isClosed) {
          _errorStreamController.add(SocketErrorResponse(where: "Subscribe Error", error: e));
        }

        if (config.showErrorLogs) {
          console.error('Subscribe error: $e', from: "WebSocket");
        }

        this.config.onError?.call("Subscribe Error", e);
      }
    }
  }

  void _onWebSocketError(dynamic error) {
    if (config.showErrorLogs) {
      console.error('WebSocket Error: $error', from: "WebSocket");
    }

    if(!_errorStreamController.isClosed) {
      _errorStreamController.add(SocketErrorResponse(where: "Web Socket Error", error: error));
    }

    this.config.onError?.call("Web Socket Error", error);

    _isActive = false;
  }

  void _onStompError(StompFrame error) {
    if (config.showErrorLogs) {
      console.error('Stomp Error: $error', from: "StompClient");
    }

    if(!_errorStreamController.isClosed) {
      _errorStreamController.add(SocketErrorResponse(where: "Stomp Error", error: error.toResponse().toJson()));
    }

    this.config.onError?.call("Stomp Error", error.toResponse().toJson());

    _isActive = false;
  }

  void _onWebSocketDone() {
    if (config.showConnectionLogs) {
      console.log('WebSocket connection closed', from: "WebSocket");
    }

    _isActive = false;
  }

  void _onDisconnect(StompFrame frame) {
    if (config.showConnectionLogs) {
      console.log('WebSocket disconnected', from: "WebSocket");
    }

    _isActive = false;
  }

  void _onDebugMessage(dynamic message) {
    if (config.showDebugLogs) {
      console.log('_logger Message: $message', from: "WebSocket _logger");
    }
  }

  bool get isActive => _client.isActive && _isActive;

  @override
  bool get isConnected => isActive && _client.connected;

  @override
  StreamController<ConnectionState> get connectionStateController => _connectionStateController;

  @override
  StreamController<SocketErrorResponse> get errorController => _errorStreamController;

  @override
  StreamController<SocketResponse> get dataController => _dataStreamController;

  @override
  Stream<ConnectionState> get connectionStateStream => _connectionStateController.stream;

  @override
  Stream<SocketResponse> get dataStream => _dataStreamController.stream;

  @override
  Stream<SocketErrorResponse> get errorStream => _errorStreamController.stream;

  @override
  void send({required String endpoint, Message? message, String data = ""}) {
    if (isConnected) {
      if(!_connectionStateController.isClosed) {
        _connectionStateController.add(ConnectionState.sending);
      }

      try {
        final body = data.isNotEmpty ? data : jsonEncode(message);
        _client.send(
          destination: endpoint,
          body: body,
          headers: _buildHeader(),
        );

        if(!_connectionStateController.isClosed) {
          _connectionStateController.add(ConnectionState.sent);
        }

        if (config.showSendLogs) {
          console.info('Message sent to $endpoint: $body', from: "WebSocket Send");
        }

        _resetSendTrial();
        return;
      } catch (e) {
        if(!_connectionStateController.isClosed) {
          _connectionStateController.add(ConnectionState.notSent);
        }

        if(!_errorStreamController.isClosed) {
          _errorStreamController.add(SocketErrorResponse(where: "Send Error", error: e));
        }

        if (config.showErrorLogs) {
          console.error('Send error: $e', from: "WebSocket");
        }

        this.config.onError?.call("Send Error", e);

        _resetSendTrial();
        return;
      }
    } else {
      if(send_trials == SEND_TRIAL_COUNT) {
        if (config.showErrorLogs) {
          console.error('Cannot send, WebSocket not connected', from: "WebSocket");
        }

        _resetSendTrial();
        return;
      } else {
        send_trials++;
        return send(endpoint: endpoint, message: message, data: data);
      }
    }
  }

  void _resetSendTrial() {
    send_trials = 0;

    Future.delayed(Duration(seconds: 4), () {
      _updateConnectionState(_currentState);
    });
  }

  @override
  void disconnect() {
    if (isConnected) {
      try {
        _unsubscribe?.call(unsubscribeHeaders: _buildHeader());
        _client.deactivate();
        _isActive = false;

        if (config.showConnectionLogs) {
          console.log('WebSocket disconnected', from: "WebSocket Disconnect");
        }
      } catch (e) {
        if (config.showErrorLogs) {
          console.error('Disconnect error: $e', from: "WebSocket");
        }
      }
    }

    _connectionStateController.close();
    _dataStreamController.close();
  }
}

extension on StompFrame {
  SocketResponse toResponse() {
    dynamic data = null;

    if(body != null) {
      try {
        data = jsonDecode(body!);
      } catch (_) {
        data = body!;
      }
    }

    return SocketResponse(
      command: command,
      headers: headers,
      body: body,
      binaryBody: binaryBody,
      hasBody: body != null,
      data: data,
      hasData: data != null
    );
  }
}