import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:zap/zap.dart';

void main() {
  late Zync zapRealtime;
  late SessionResponse testSession;

  setUp(() {
    testSession = SessionResponse(
      accessToken: 'realtime_test_token_12345',
      refreshToken: 'realtime_refresh_token_12345',
    );
  });

  tearDown(() {
    Zync.dispose();
  });

  group('Zync Real WebSocket Tests', () {
    // Using echo.websocket.events as a public WebSocket echo server
    const wsUrl = 'wss://echo.websocket.events';

    test('connects to WebSocket server with authentication', () async {
      // Arrange
      final connectCompleter = Completer<ZyncState>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          useToken: true,
          onStateChanged: (state) {
            if (state == ZyncState.connected) {
              connectCompleter.complete(state);
            }
          },
        ),
      );

      // Act
      await zapRealtime.connect();

      // Assert
      final state = await connectCompleter.future;
      expect(state, ZyncState.connected);
      expect(zapRealtime.isConnected, true);
      expect(zapRealtime.connectionState, ZyncState.connected);
    });

    test('sends messages with endpoint and data', () async {
      // Arrange
      final messageCompleter = Completer<ZyncResponse>();
      final testEndpoint = '/api/test';
      final testData = {
        'message': 'Hello from Zync',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          onReceived: (response) {
            try {
              if (response.data['endpoint'] == testEndpoint) {
                messageCompleter.complete(response);
              }
            } catch (e) {
              // Not our message
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Act
      zapRealtime.send(endpoint: testEndpoint, data: testData);

      // Assert
      final response = await messageCompleter.future;
      expect(response.data['type'], 'send');
      expect(response.data['endpoint'], testEndpoint);
      expect(response.data['data']['message'], testData['message']);
      expect(response.data['headers']['Authorization'], 'Bearer realtime_test_token_12345');
    });

    test('subscribes to topics and receives messages', () async {
      // Arrange
      final subscriptionCompleter = Completer<ZyncResponse>();
      const testTopic = '/notifications/user';
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
        ),
      );
      
      await zapRealtime.connect();
      
      zapRealtime.subscribe(
        topic: testTopic,
        onMessage: (response) {
          subscriptionCompleter.complete(response);
        },
      );

      // Act - Simulate a message for this topic
      // Since we're using an echo server, we'll send the message ourselves
      final testMessage = {
        'type': testTopic,
        'data': {
          'notification': 'You have a new message',
          'priority': 'high',
        }
      };
      
      zapRealtime.send(endpoint: testTopic, data: testMessage);

      // Assert
      final response = await subscriptionCompleter.future;
      expect(response.type, testTopic);
      expect(response.data['data']['notification'], 'You have a new message');
      expect(response.data['data']['priority'], 'high');
    });

    test('unsubscribes from topics', () async {
      // Arrange
      const testTopic = '/test/unsubscribe';
      bool messageReceived = false;
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
        ),
      );
      
      await zapRealtime.connect();
      
      zapRealtime.subscribe(
        topic: testTopic,
        onMessage: (response) {
          messageReceived = true;
        },
      );

      // Act
      zapRealtime.unsubscribe(testTopic);
      
      // Send a message to the unsubscribed topic
      final testMessage = {
        'type': testTopic,
        'data': {'message': 'This should not be received'}
      };
      
      zapRealtime.send(endpoint: testTopic, data: testMessage);
      
      // Wait a bit to see if message is received
      await Future.delayed(Duration(milliseconds: 500));

      // Assert
      expect(messageReceived, false);
    });

    test('handles event listeners with on/off', () async {
      // Arrange
      final eventCompleter = Completer<dynamic>();
      const eventType = 'custom_event';
      final eventData = {
        'action': 'user_login',
        'userId': 'user123',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
        ),
      );
      
      await zapRealtime.connect();
      
      zapRealtime.on(eventType, (data) {
        eventCompleter.complete(data);
      });

      // Act
      final testMessage = {
        'type': eventType,
        'data': eventData
      };
      
      zapRealtime.send(endpoint: eventType, data: testMessage);

      // Assert
      final receivedData = await eventCompleter.future;
      expect(receivedData['action'], eventData['action']);
      expect(receivedData['userId'], eventData['userId']);
      expect(receivedData['timestamp'], eventData['timestamp']);
    });

    test('emits events to server', () async {
      // Arrange
      final emitCompleter = Completer<ZyncResponse>();
      const eventType = 'user_action';
      final eventData = {
        'action': 'button_click',
        'buttonId': 'submit_btn',
        'page': '/dashboard',
      };
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          onReceived: (response) {
            try {
              if (response.data['type'] == eventType) {
                emitCompleter.complete(response);
              }
            } catch (e) {
              // Not our event
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Act
      zapRealtime.emit(eventType, eventData);

      // Assert
      final response = await emitCompleter.future;
      expect(response.data['type'], eventType);
      expect(response.data['data']['action'], eventData['action']);
      expect(response.data['data']['buttonId'], eventData['buttonId']);
      expect(response.data['data']['page'], eventData['page']);
    });

    test('handles connection state changes', () async {
      // Arrange
      final stateChanges = <ZyncState>[];
      final allStatesCompleter = Completer<void>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          onStateChanged: (state) {
            stateChanges.add(state);
            if (state == ZyncState.connected) {
              allStatesCompleter.complete();
            }
          },
        ),
      );

      // Act
      await zapRealtime.connect();

      // Assert
      await allStatesCompleter.future;
      expect(stateChanges, contains(ZyncState.connecting));
      expect(stateChanges, contains(ZyncState.connected));
    });

    test('uses custom auth header configuration', () async {
      // Arrange
      final messageCompleter = Completer<ZyncResponse>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          authHeaderName: 'X-Auth-Token',
          tokenPrefix: 'Token',
          onReceived: (response) {
            try {
              if (response.data['type'] == 'send') {
                messageCompleter.complete(response);
              }
            } catch (e) {
              // Not our message
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Act
      zapRealtime.send(endpoint: '/test', data: {'test': 'custom_auth'});

      // Assert
      final response = await messageCompleter.future;
      expect(response.data['headers']['X-Auth-Token'], 'Token realtime_test_token_12345');
    });

    test('uses custom auth header builder', () async {
      // Arrange
      final messageCompleter = Completer<ZyncResponse>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          customAuthHeaderBuilder: (session) => {
            'X-Access-Token': session.accessToken,
            'X-Custom-Header': 'custom_value_${session.refreshToken}',
          },
          onReceived: (response) {
            try {
              if (response.data['type'] == 'send') {
                messageCompleter.complete(response);
              }
            } catch (e) {
              // Not our message
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Act
      zapRealtime.send(endpoint: '/test', data: {'test': 'custom_builder'});

      // Assert
      final response = await messageCompleter.future;
      final headers = response.data['headers'];
      expect(headers['X-Access-Token'], 'realtime_test_token_12345');
      expect(headers['X-Custom-Header'], 'custom_value_realtime_refresh_token_12345');
    });

    test('handles dynamic session updates', () async {
      // Arrange
      SessionResponse? currentSession = testSession;
      final messageCompleter = Completer<ZyncResponse>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          sessionFactory: () => currentSession!,
          onReceived: (response) {
            try {
              if (response.data['type'] == 'send') {
                messageCompleter.complete(response);
              }
            } catch (e) {
              // Not our message
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Update session
      currentSession = SessionResponse(
        accessToken: 'updated_realtime_token_67890',
        refreshToken: 'updated_realtime_refresh_token_67890',
      );

      // Act
      zapRealtime.send(endpoint: '/test', data: {'test': 'updated_session'});

      // Assert
      final response = await messageCompleter.future;
      expect(response.data['headers']['Authorization'], 'Bearer updated_realtime_token_67890');
    });

    test('handles ping/pong for connection keepalive', () async {
      // Arrange
      final pingCompleter = Completer<ZyncResponse>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          pingInterval: Duration(seconds: 1), // Short interval for testing
          onReceived: (response) {
            try {
              if (response.data['type'] == 'ping') {
                pingCompleter.complete(response);
              }
            } catch (e) {
              // Not our message
            }
          },
        ),
      );
      
      await zapRealtime.connect();

      // Act - Wait for ping to be sent
      final response = await pingCompleter.future;

      // Assert
      expect(response.data['type'], 'ping');
      expect(response.data['timestamp'], isA<int>());
      expect(response.data['headers'], isA<Map>());
    });

    test('enforces singleton pattern', () async {
      // Arrange
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
        ),
      );

      // Act & Assert
      expect(
        () => Zync(config: ZyncConfig(url: wsUrl)),
        throwsA(isA<Exception>()),
      );
    });

    test('handles disconnection and cleanup', () async {
      // Arrange
      final disconnectCompleter = Completer<ZyncState>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: wsUrl,
          session: testSession,
          onStateChanged: (state) {
            if (state == ZyncState.disconnected) {
              disconnectCompleter.complete(state);
            }
          },
        ),
      );
      
      await zapRealtime.connect();
      expect(zapRealtime.isConnected, true);

      // Act
      zapRealtime.disconnect();

      // Assert
      final state = await disconnectCompleter.future;
      expect(state, ZyncState.disconnected);
      expect(zapRealtime.isConnected, false);
    });

    test('handles error scenarios', () async {
      // Arrange
      final errorCompleter = Completer<ZyncErrorResponse>();
      
      zapRealtime = Zync(
        config: ZyncConfig(
          url: 'wss://invalid-websocket-url-12345.com', // Invalid URL
          session: testSession,
          maxReconnectAttempts: 1, // Limit reconnection attempts
          reconnectDelay: Duration(milliseconds: 100),
        ),
      );
      
      zapRealtime.errorStream.listen((error) {
        errorCompleter.complete(error);
      });

      // Act
      try {
        await zapRealtime.connect();
      } catch (e) {
        // Connection will fail
      }

      // Assert
      final error = await errorCompleter.future;
      expect(error.where, isNotEmpty);
      expect(error.error, isNotNull);
    });
  });
}
