import 'dart:async';
import 'dart:convert';
import 'package:tracing/tracing.dart' show console;
import 'package:zap/src/definitions.dart';
import '../enums/zap_realtime_state.dart';
import '../exceptions/exceptions.dart';
import '../models/session_response.dart';
import '../models/zap_realtime_config.dart';
import '../models/zap_realtime_error_response.dart';
import '../models/zap_realtime_response.dart';
import '../zap_socket.dart';
import 'zap_realtime_interface.dart';

/// ZapRealtime is a high-level WebSocket client wrapper that provides real-time
/// communication capabilities with authentication, session management, and
/// standardized message handling.
/// 
/// This class implements a singleton pattern to ensure only one instance exists
/// throughout the application lifecycle. It wraps the underlying ZapSocket client
/// and provides additional features like automatic reconnection, subscription
/// management, event-based messaging, and flexible authentication headers.
/// 
/// Key features:
/// - Singleton pattern implementation
/// - Configurable authentication headers (header name, token prefix, or custom builder)
/// - Automatic connection management and reconnection
/// - Topic-based subscription system
/// - Event-driven messaging
/// - Dynamic session management
/// - Connection state monitoring
/// - Error handling and logging
/// 
/// Example usage:
/// ```dart
/// // Standard Bearer token
/// final config = ZapRealtimeConfig(
///   url: 'wss://api.example.com/ws',
///   session: currentSession,
///   authHeaderName: 'Authorization',
///   tokenPrefix: 'Bearer',
/// );
/// 
/// // Google API style
/// final googleConfig = ZapRealtimeConfig(
///   url: 'wss://api.google.com/ws',
///   session: currentSession,
///   authHeaderName: 'Authorization',
///   tokenPrefix: 'Goog',
/// );
/// 
/// // Custom authentication headers
/// final customConfig = ZapRealtimeConfig(
///   url: 'wss://api.custom.com/ws',
///   session: currentSession,
///   customAuthHeaderBuilder: (session) => {
///     'X-API-Key': session.accessToken,
///     'X-User-ID': session.userId.toString(),
///     'X-Session-Token': session.refreshToken,
///   },
/// );
/// 
/// final realtime = ZapRealtime(config: config);
/// await realtime.connect();
/// ```
class ZapRealtime implements ZapRealtimeInterface {
  /// Configuration object containing all settings for the ZapRealtime client.
  final ZapRealtimeConfig config;

  /// Private constructor to enforce singleton pattern
  ZapRealtime._internal({required this.config});

  /// Static instance holder for singleton pattern
  static ZapRealtime? _instance;

  /// Factory constructor that implements singleton pattern.
  /// 
  /// Throws [ZapException] if an instance already exists with different configuration.
  factory ZapRealtime({required ZapRealtimeConfig config}) {
    if (_instance != null) {
      throw ZapException(
        "Multiple instances of ZapRealtime detected. Only one instance is allowed. "
        "Use ZapRealtime.instance to access the existing instance or call ZapRealtime.dispose() "
        "before creating a new instance."
      );
    }
    _instance = ZapRealtime._internal(config: config);
    return _instance!;
  }

  /// Gets the current singleton instance.
  /// 
  /// Throws [ZapException] if no instance has been created yet.
  static ZapRealtime get instance {
    if (_instance == null) {
      throw ZapException(
        "No ZapRealtime instance found. Create an instance first using ZapRealtime(config: config)."
      );
    }
    return _instance!;
  }

  /// Disposes the current singleton instance, allowing a new one to be created.
  static void dispose() {
    _instance?.disconnect();
    _instance = null;
  }

  /// Underlying ZapSocket instance
  ZapSocket? _socket;

  /// Current connection state
  ZapRealtimeState _connectionState = ZapRealtimeState.dormant;

  /// Map of active subscriptions
  final Map<String, void Function(ZapRealtimeResponse)> _subscriptions = {};

  /// Map of event listeners
  final Map<String, void Function(dynamic)> _eventListeners = {};

  /// Reconnection attempt counter
  int _reconnectAttempts = 0;

  /// Timer for reconnection attempts
  Timer? _reconnectTimer;

  /// Timer for ping messages
  Timer? _pingTimer;

  /// Send retry counter
  int _sendTrials = 0;
  static const int _maxSendTrials = 5;

  // Stream controllers
  final StreamController<ZapRealtimeState> _connectionStateController = StreamController<ZapRealtimeState>.broadcast();
  final StreamController<ZapRealtimeResponse> _dataStreamController = StreamController<ZapRealtimeResponse>.broadcast();
  final StreamController<ZapRealtimeErrorResponse> _errorStreamController = StreamController<ZapRealtimeErrorResponse>.broadcast();

  @override
  bool get isConnected => _socket != null && _connectionState == ZapRealtimeState.connected;

  @override
  ZapRealtimeState get connectionState => _connectionState;

  @override
  StreamController<ZapRealtimeState> get connectionStateController => _connectionStateController;

  @override
  StreamController<ZapRealtimeErrorResponse> get errorController => _errorStreamController;

  @override
  StreamController<ZapRealtimeResponse> get dataController => _dataStreamController;

  @override
  Stream<ZapRealtimeState> get connectionStateStream => _connectionStateController.stream;

  @override
  Stream<ZapRealtimeResponse> get dataStream => _dataStreamController.stream;

  @override
  Stream<ZapRealtimeErrorResponse> get errorStream => _errorStreamController.stream;

  /// Gets the current session, always fetching the latest from the session factory.
  /// 
  /// This ensures that the session is always up-to-date by calling the session
  /// callback function if provided, otherwise returns the static session from config.
  SessionResponse? get _currentSession {
    if (config.sessionFactory != null) {
      return config.sessionFactory!();
    }
    return config.session;
  }

  /// Updates the connection state and notifies listeners.
  void _updateConnectionState(ZapRealtimeState state) {
    _connectionState = state;
    
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
    
    config.onStateChanged?.call(state);
    
    if (config.showConnectionLogs) {
      console.log('ZapRealtime: Connection state changed to $state');
    }
  }

  /// Builds authentication headers based on the configuration.
  /// 
  /// This method supports three modes:
  /// 1. Custom header builder function (highest priority)
  /// 2. Configurable header name and token prefix
  /// 3. Default Authorization: Bearer format
  /// 
  /// Examples of generated headers:
  /// - `Authorization: Bearer abc123` (default)
  /// - `Authorization: Goog abc123` (Google style)
  /// - `X-API-Key: abc123` (API key style with empty prefix)
  /// - Multiple custom headers via customAuthHeaderBuilder
  Map<String, String> _buildAuthHeaders(SessionResponse session) {
    // Use custom auth header builder if provided
    if (config.customAuthHeaderBuilder != null) {
      return config.customAuthHeaderBuilder!(session);
    }
    
    // Use configurable header name and token prefix
    final token = session.accessToken;
    if (token.isEmpty) {
      return {};
    }
    
    final headerValue = config.tokenPrefix.isEmpty ? token : '${config.tokenPrefix} $token';
    
    return {config.authHeaderName: headerValue};
  }

  /// Builds headers for WebSocket connection including authentication.
  /// 
  /// This method fetches the current session and builds the appropriate auth headers
  /// based on the configuration. It also includes any additional headers from config.
  Map<String, String> _buildHeaders([Map<String, String>? additionalHeaders]) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    // Add base headers from config
    if (config.headers != null) {
      headers.addAll(config.headers!);
    }

    // Add authentication headers if needed
    if (config.useToken) {
      final session = _currentSession;
      if (session != null) {
        final authHeaders = _buildAuthHeaders(session);
        headers.addAll(authHeaders);
        
        if (config.showConnectionLogs && authHeaders.isNotEmpty) {
          console.log('ZapRealtime: Added auth headers: ${authHeaders.keys.join(', ')}');
        }
      }
    }

    // Add content type for non-web platforms
    if (!config.isWebPlatform) {
      headers['Content-Type'] = 'application/json';
    }

    // Add any additional headers passed to the method
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handles incoming WebSocket messages.
  void _handleMessage(dynamic message) {
    try {
      ZapRealtimeResponse response;
      
      if (message is String) {
        // Try to parse as JSON
        try {
          final data = jsonDecode(message);
          response = ZapRealtimeResponse(
            type: data['type'],
            body: message,
            data: data,
            hasBody: true,
            hasData: true,
          );
        } catch (_) {
          // Not JSON, treat as plain text
          response = ZapRealtimeResponse(
            body: message,
            data: message,
            hasBody: true,
            hasData: true,
          );
        }
      } else {
        // Handle non-string messages
        response = ZapRealtimeResponse(
          data: message,
          hasData: true,
        );
      }

      // Notify data stream
      if (!_dataStreamController.isClosed) {
        _dataStreamController.add(response);
      }

      // Call config callback
      config.onReceived?.call(response);

      // Handle subscriptions
      if (response.type != null && _subscriptions.containsKey(response.type)) {
        _subscriptions[response.type]?.call(response);
      }

      // Handle event listeners
      if (response.type != null && _eventListeners.containsKey(response.type)) {
        _eventListeners[response.type]?.call(response.data);
      }

      if (config.showDebugLogs) {
        console.log('ZapRealtime: Message received - ${response.type ?? 'unknown'}');
      }
    } catch (e) {
      _handleError('Message Processing Error', e);
    }
  }

  /// Handles WebSocket errors.
  void _handleError(String where, dynamic error) {
    final errorResponse = ZapRealtimeErrorResponse(where: where, error: error);
    
    if (!_errorStreamController.isClosed) {
      _errorStreamController.add(errorResponse);
    }
    
    config.onError?.call(where, error);
    
    if (config.showErrorLogs) {
      console.error('ZapRealtime Error [$where]: $error');
    }
  }

  /// Starts the ping timer to keep the connection alive.
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(config.pingInterval, (timer) {
      if (isConnected) {
        final pingMessage = {
          'type': 'ping',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'headers': _buildHeaders(),
        };
        _socket?.send(jsonEncode(pingMessage));
      }
    });
  }

  /// Stops the ping timer.
  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  /// Attempts to reconnect to the WebSocket server.
  void _attemptReconnect() {
    if (_reconnectAttempts >= config.maxReconnectAttempts) {
      _handleError('Reconnection Failed', 'Maximum reconnection attempts reached');
      _updateConnectionState(ZapRealtimeState.disconnected);
      return;
    }

    _reconnectAttempts++;
    
    if (config.showConnectionLogs) {
      console.log('ZapRealtime: Attempting reconnection $_reconnectAttempts/${config.maxReconnectAttempts}');
    }

    _reconnectTimer = Timer(config.reconnectDelay, () {
      connect();
    });
  }

  @override
  Future<void> connect() async {
    try {
      _updateConnectionState(ZapRealtimeState.connecting);
      
      if (config.showConnectionLogs) {
        console.log('ZapRealtime: Connecting to ${config.url}');
      }

      // Create new socket instance
      _socket = ZapSocket(config.url, ping: config.pingInterval);

      // Set up event handlers
      _socket!.onOpen(() {
        _reconnectAttempts = 0; // Reset reconnection counter
        _updateConnectionState(ZapRealtimeState.connected);
        _startPingTimer();
        
        if (config.showConnectionLogs) {
          console.log('ZapRealtime: Connected to ${config.url}');
        }

        // Send connection headers with authentication
        final connectionMessage = {
          'type': 'connect',
          'headers': _buildHeaders(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        _socket!.send(jsonEncode(connectionMessage));

        // Auto-subscribe to configured subscription
        if (config.subscription != null) {
          subscribe(
            topic: config.subscription!,
            onMessage: (response) {
              // Default subscription handler - already handled in _handleMessage
            },
          );
        }
      });

      _socket!.onMessage(_handleMessage);

      _socket!.onError((error) {
        _handleError('WebSocket Error', error.message);
        _updateConnectionState(ZapRealtimeState.disconnected);
        _stopPingTimer();
        
        // Attempt reconnection
        _attemptReconnect();
      });

      _socket!.onClose((close) {
        _updateConnectionState(ZapRealtimeState.disconnected);
        _stopPingTimer();
        
        if (config.showConnectionLogs) {
          console.log('ZapRealtime: Connection closed - ${close.message}');
        }

        // Attempt reconnection if not manually disconnected
        if (_connectionState != ZapRealtimeState.disconnected) {
          _attemptReconnect();
        }
      });

      // Connect to the WebSocket
      await _socket!.connect();
      
    } catch (e) {
      _handleError('Connection Error', e);
      _updateConnectionState(ZapRealtimeState.disconnected);
      _attemptReconnect();
    }
  }

  @override
  void disconnect() {
    _reconnectTimer?.cancel();
    _stopPingTimer();
    
    if (_socket != null) {
      _socket!.close();
      _socket = null;
    }
    
    _subscriptions.clear();
    _eventListeners.clear();
    _updateConnectionState(ZapRealtimeState.disconnected);
    
    // Close stream controllers
    _connectionStateController.close();
    _dataStreamController.close();
    _errorStreamController.close();
    
    if (config.showConnectionLogs) {
      console.log('ZapRealtime: Disconnected');
    }
  }

  @override
  void send({
    required String endpoint,
    required dynamic data,
    Headers? headers,
  }) {
    if (!isConnected) {
      if (_sendTrials >= _maxSendTrials) {
        _handleError('Send Error', 'WebSocket not connected after $_maxSendTrials attempts');
        _resetSendTrial();
        return;
      }
      
      _sendTrials++;
      // Retry after a short delay
      Timer(const Duration(milliseconds: 500), () {
        send(endpoint: endpoint, data: data, headers: headers);
      });
      return;
    }

    try {
      _updateConnectionState(ZapRealtimeState.sending);
      
      final message = {
        'type': 'send',
        'endpoint': endpoint,
        'data': data,
        'headers': _buildHeaders(headers),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _socket!.send(jsonEncode(message));
      
      _updateConnectionState(ZapRealtimeState.sent);
      _resetSendTrial();
      
      if (config.showSendLogs) {
        console.info('ZapRealtime: Message sent to $endpoint');
      }
      
    } catch (e) {
      _updateConnectionState(ZapRealtimeState.notSent);
      _handleError('Send Error', e);
      _resetSendTrial();
    }
  }

  @override
  void subscribe({
    required String topic,
    required void Function(ZapRealtimeResponse) onMessage,
  }) {
    _subscriptions[topic] = onMessage;
    
    if (isConnected) {
      _updateConnectionState(ZapRealtimeState.subscribing);
      
      final message = {
        'type': 'subscribe',
        'topic': topic,
        'headers': _buildHeaders(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _socket!.send(jsonEncode(message));
      
      _updateConnectionState(ZapRealtimeState.subscribed);
      
      if (config.showConnectionLogs) {
        console.log('ZapRealtime: Subscribed to $topic');
      }
    }
  }

  @override
  void unsubscribe(String topic) {
    _subscriptions.remove(topic);
    
    if (isConnected) {
      final message = {
        'type': 'unsubscribe',
        'topic': topic,
        'headers': _buildHeaders(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _socket!.send(jsonEncode(message));
      
      if (config.showConnectionLogs) {
        console.log('ZapRealtime: Unsubscribed from $topic');
      }
    }
  }

  @override
  void on(String event, void Function(dynamic data) callback) {
    _eventListeners[event] = callback;
  }

  @override
  void off(String event) {
    _eventListeners.remove(event);
  }

  @override
  void emit(String event, dynamic data) {
    if (isConnected) {
      final message = {
        'type': event,
        'data': data,
        'headers': _buildHeaders(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      _socket!.send(jsonEncode(message));
      
      if (config.showSendLogs) {
        console.info('ZapRealtime: Event emitted - $event');
      }
    } else {
      _handleError('Emit Error', 'WebSocket not connected');
    }
  }

  /// Resets the send trial counter and updates connection state after delay.
  void _resetSendTrial() {
    _sendTrials = 0;
    
    Timer(const Duration(seconds: 2), () {
      if (isConnected) {
        _updateConnectionState(ZapRealtimeState.connected);
      }
    });
  }
}