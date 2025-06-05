// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:zap/zap.dart';

// void main() {
//   late ZapSocket zapSocket;

//   setUp(() {
//     zapSocket = ZapSocket(wsUrl);
//   });

//   tearDown(() {
//     if (zapSocket.isConnected) {
//       zapSocket.close();
//     }
//   });

//   group('ZapSocket Real WebSocket Tests', () {
//     // Using echo.websocket.events as a public WebSocket echo server
//     const wsUrl = 'wss://echo.websocket.events';

//     test('connects to WebSocket server successfully', () async {
//       // Arrange
//       final connectCompleter = Completer<void>();
      
//       zapSocket.onOpen(() {
//         connectCompleter.complete();
//       });

//       zapSocket.onError((error) {
//         connectCompleter.completeError(error);
//       });

//       // Act
//       await zapSocket.connect();

//       // Assert
//       await connectCompleter.future;
//       expect(zapSocket.isConnected, true);
//     });

//     test('sends and receives text messages', () async {
//       // Arrange
//       final messageCompleter = Completer<String>();
//       const testMessage = 'Hello from ZapSocket!';
      
//       await zapSocket.connect();
      
//       zapSocket.onMessage((message) {
//         if (message == testMessage) {
//           messageCompleter.complete(message);
//         }
//       });

//       // Act
//       zapSocket.send(testMessage);

//       // Assert
//       final receivedMessage = await messageCompleter.future;
//       expect(receivedMessage, testMessage);
//     });

//     test('sends and receives JSON data', () async {
//       // Arrange
//       final messageCompleter = Completer<Map<String, dynamic>>();
//       final testData = {
//         'type': 'test_message',
//         'content': 'JSON test from ZapSocket',
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'data': {
//           'nested': 'value',
//           'number': 42,
//           'boolean': true
//         }
//       };
      
//       await zapSocket.connect();
      
//       zapSocket.onMessage((message) {
//         try {
//           final jsonData = jsonDecode(message);
//           if (jsonData['type'] == 'test_message') {
//             messageCompleter.complete(jsonData);
//           }
//         } catch (e) {
//           // Not our JSON message
//         }
//       });

//       // Act
//       zapSocket.send(testData);

//       // Assert
//       final receivedData = await messageCompleter.future;
//       expect(receivedData['type'], testData['type']);
//       expect(receivedData['content'], testData['content']);
//       expect(receivedData['timestamp'], testData['timestamp']);
//       expect(receivedData['data']['nested'], testData['data']['nested']);
//       expect(receivedData['data']['number'], testData['data']['number']);
//       expect(receivedData['data']['boolean'], testData['data']['boolean']);
//     });

//     test('handles multiple message callbacks', () async {
//       // Arrange
//       final messageCompleter1 = Completer<String>();
//       final messageCompleter2 = Completer<String>();
//       const testMessage = 'Multiple callbacks test';
      
//       await zapSocket.connect();
      
//       zapSocket.onMessage((message) {
//         if (message == testMessage && !messageCompleter1.isCompleted) {
//           messageCompleter1.complete(message);
//         }
//       });
      
//       zapSocket.onMessage((message) {
//         if (message == testMessage && !messageCompleter2.isCompleted) {
//           messageCompleter2.complete(message);
//         }
//       });

//       // Act
//       zapSocket.send(testMessage);

//       // Assert
//       final results = await Future.wait([
//         messageCompleter1.future,
//         messageCompleter2.future,
//       ]);
      
//       expect(results[0], testMessage);
//       expect(results[1], testMessage);
//     });

//     test('closes connection properly', () async {
//       // Arrange
//       final closeCompleter = Completer<Map<String, dynamic>>();
      
//       await zapSocket.connect();
      
//       zapSocket.onClose((closeEvent) {
//         closeCompleter.complete(closeEvent);
//       });

//       // Act
//       zapSocket.close(1000, 'Test closure');

//       // Assert
//       final closeEvent = await closeCompleter.future;
//       expect(zapSocket.isConnected, false);
//       expect(closeEvent['code'], 1000);
//       expect(closeEvent['reason'], 'Test closure');
//     });

//     test('handles connection errors', () async {
//       // Arrange
//       final errorCompleter = Completer<dynamic>();
      
//       zapSocket.onError((error) {
//         errorCompleter.complete(error);
//       });

//       // Act - Try to connect to invalid WebSocket URL
//       try {
//         await zapSocket.connect('wss://invalid-websocket-url-12345.com');
//       } catch (e) {
//         // Connection might fail immediately
//       }

//       // Assert
//       final error = await errorCompleter.future;
//       expect(error, isNotNull);
//       expect(zapSocket.isConnected, false);
//     });

//     test('sends multiple rapid messages', () async {
//       // Arrange
//       final receivedMessages = <String>[];
//       final messageCompleter = Completer<void>();
//       const messageCount = 10;
      
//       await zapSocket.connect();
      
//       zapSocket.onMessage((message) {
//         if (message.startsWith('rapid_test_')) {
//           receivedMessages.add(message);
//           if (receivedMessages.length == messageCount) {
//             messageCompleter.complete();
//           }
//         }
//       });

//       // Act
//       for (int i = 0; i < messageCount; i++) {
//         zapSocket.send('rapid_test_$i');
//       }

//       // Assert
//       await messageCompleter.future;
//       expect(receivedMessages.length, messageCount);
      
//       // Verify all messages were received
//       for (int i = 0; i < messageCount; i++) {
//         expect(receivedMessages.contains('rapid_test_$i'), true);
//       }
//     });

//     test('handles large message payload', () async {
//       // Arrange
//       final messageCompleter = Completer<Map<String, dynamic>>();
      
//       // Create a large JSON payload
//       final largeData = {
//         'type': 'large_payload_test',
//         'data': List.generate(1000, (index) => {
//           'id': index,
//           'name': 'Item $index',
//           'description': 'This is a description for item $index with some additional text to make it larger',
//           'metadata': {
//             'created': DateTime.now().millisecondsSinceEpoch,
//             'tags': ['tag1', 'tag2', 'tag3'],
//             'properties': {
//               'color': 'blue',
//               'size': 'large',
//               'weight': index * 1.5,
//             }
//           }
//         })
//       };
      
//       await zapSocket.connect(wsUrl);
      
//       zapSocket.onMessage((message) {
//         try {
//           final jsonData = jsonDecode(message);
//           if (jsonData['type'] == 'large_payload_test') {
//             messageCompleter.complete(jsonData);
//           }
//         } catch (e) {
//           // Not our message
//         }
//       });

//       // Act
//       zapSocket.send(largeData);

//       // Assert
//       final receivedData = await messageCompleter.future;
//       expect(receivedData['type'], 'large_payload_test');
//       expect(receivedData['data'], isA<List>());
//       expect(receivedData['data'].length, 1000);
//       expect(receivedData['data'][0]['id'], 0);
//       expect(receivedData['data'][999]['id'], 999);
//     });

//     test('reconnection after connection loss', () async {
//       // Arrange
//       await zapSocket.connect(wsUrl);
//       expect(zapSocket.isConnected, true);

//       final reconnectCompleter = Completer<void>();
      
//       zapSocket.onOpen(() {
//         if (!reconnectCompleter.isCompleted) {
//           reconnectCompleter.complete();
//         }
//       });

//       // Act - Force close and reconnect
//       zapSocket.close();
//       expect(zapSocket.isConnected, false);
      
//       await zapSocket.connect(wsUrl);

//       // Assert
//       await reconnectCompleter.future;
//       expect(zapSocket.isConnected, true);
//     });

//     test('multiple open callbacks are triggered', () async {
//       // Arrange
//       int openCallbackCount = 0;
//       final allCallbacksCompleter = Completer<void>();
      
//       zapSocket.onOpen(() {
//         openCallbackCount++;
//         if (openCallbackCount == 3) {
//           allCallbacksCompleter.complete();
//         }
//       });
      
//       zapSocket.onOpen(() {
//         openCallbackCount++;
//         if (openCallbackCount == 3) {
//           allCallbacksCompleter.complete();
//         }
//       });
      
//       zapSocket.onOpen(() {
//         openCallbackCount++;
//         if (openCallbackCount == 3) {
//           allCallbacksCompleter.complete();
//         }
//       });

//       // Act
//       await zapSocket.connect(wsUrl);

//       // Assert
//       await allCallbacksCompleter.future;
//       expect(openCallbackCount, 3);
//     });
//   });
// }