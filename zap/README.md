### Zap Networking Library

Zap is a powerful, flexible networking library for Flutter applications that simplifies HTTP requests and WebSocket connections. It provides a comprehensive suite of tools for handling API interactions, real-time communication, and common networking tasks.

## Table of Contents

- [Installation](#installation)
- [Core Components](#core-components)
- [Zap HTTP Client](#zap-http-client)
- [ZapPulse](#zappulse)
- [ZapSocket](#zapsocket)
- [ZapRealtime](#zaprealtime)
- [ZapUtils](#zaputils)
- [Advanced Usage](#advanced-usage)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)


## Installation

Add Zap to your `pubspec.yaml`:

```yaml
dependencies:
  zap: ^1.0.0 /// Preferred when deployed
```

```yaml
dependencies:
  zap: /// Preferred when not deployed - Current installation
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: zap
```

Then run:

```shellscript
flutter pub get
```

## Core Components

Zap consists of five main components:

1. **Zap** - Core HTTP client for basic REST operations
2. **ZapPulse** - Enhanced HTTP client with authentication and session management
3. **ZapSocket** - WebSocket client for real-time communication
4. **ZapRealtime** - Advanced WebSocket client with subscription and event management
5. **ZapUtils** - Utility functions for common networking tasks


## Zap HTTP Client

The core `Zap` class provides a clean, simple interface for making HTTP requests.

### Features

- All standard HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Request cancellation
- Query parameter support
- Custom headers
- Automatic JSON parsing
- Error handling


### Basic Usage

```dart
import 'package:zap/zap.dart';

void main() async {
  final zap = Zap();
  
  try {
    // GET request
    final response = await zap.get<Map<String, dynamic>>(
      'https://api.example.com/users',
      headers: {'Accept': 'application/json'},
      query: {'page': 1, 'limit': 10},
    );
    
    if (response.statusCode == 200) {
      print('Users: ${response.body}');
    }
    
    // POST request
    final createResponse = await zap.post<Map<String, dynamic>>(
      'https://api.example.com/users',
      {'name': 'John Doe', 'email': 'john@example.com'},
      headers: {'Content-Type': 'application/json'},
    );
    
    print('Created user: ${createResponse.body}');
  } catch (e) {
    print('Error: $e');
  } finally {
    zap.dispose(); // Clean up resources
  }
}
```

### Request Cancellation

```dart
final cancelToken = ZapCancelToken();

// Start a request that can be cancelled
final futureResponse = zap.get<Map<String, dynamic>>(
  'https://api.example.com/large-data',
  cancelToken: cancelToken,
);

// Cancel the request if needed
cancelToken.cancel('User cancelled operation');

// Or cancel all active requests
zap.cancelAllRequests('Navigating away');
```

## ZapPulse

`ZapPulse` extends the core functionality with authentication, session management, and a singleton pattern for app-wide use.

### Features

- Singleton pattern for global access
- Built-in authentication header management
- Session refresh handling
- Customizable auth header formats
- Response transformation


### Basic Usage

```dart
import 'package:zap/zap_pulse.dart';
import 'package:zap/models/session_response.dart';

void main() async {
  // Initialize with session
  final session = SessionResponse(
    accessToken: 'your_access_token',
    refreshToken: 'your_refresh_token',
    userId: 'user_123',
  );
  
  final zapPulse = ZapPulse(
    config: ZapPulseConfig(
      session: session,
      showRequestLogs: true,
      showResponseLogs: true,
    ),
  );
  
  // Make authenticated request
  final response = await zapPulse.get<Map<String, dynamic>>(
    endpoint: 'https://api.example.com/user/profile',
    useAuth: true, // Will add authentication headers
  );
  
  if (response.isOk) {
    print('User profile: ${response.data}');
  } else {
    print('Error: ${response.message}');
  }
  
  // Clean up when done
  ZapPulse.dispose();
}
```

### Dynamic Session Management

```dart
SessionResponse? currentSession = getSessionFromStorage();

final zapPulse = ZapPulse(
  config: ZapPulseConfig(
    // Dynamic session retrieval
    sessionFactory: () => currentSession,
    
    // Session refresh handling
    onSessionRefreshed: () async {
      // Refresh token logic
      currentSession = await refreshSession(currentSession!.refreshToken);
      saveSessionToStorage(currentSession);
      return currentSession;
    },
  ),
);
```

### Custom Authentication Headers

```dart
final zapPulse = ZapPulse(
  config: ZapPulseConfig(
    session: session,
    
    // Option 1: Configure header name and prefix
    authHeaderName: 'X-API-Key',
    tokenPrefix: 'Token',
    
    // Option 2: Custom header builder
    customAuthHeaderBuilder: (session) => {
      'X-User-ID': session.userId,
      'X-Access-Token': session.accessToken,
      'X-Custom-Auth': 'User:${session.userId},Token:${session.accessToken}',
    },
  ),
);
```

## ZapSocket

`ZapSocket` provides a simple interface for WebSocket connections with event-based callbacks.

### Features

- Easy WebSocket connection management
- Event-based callbacks (open, message, error, close)
- Automatic JSON serialization/deserialization
- Connection state tracking


### Basic Usage

```dart
import 'package:zap/zap_socket.dart';

void main() async {
  final socket = ZapSocket();
  
  // Set up event handlers
  socket.onOpen(() {
    print('Connection established');
    socket.send('Hello from client!');
  });
  
  socket.onMessage((message) {
    print('Received: $message');
  });
  
  socket.onError((error) {
    print('Error: $error');
  });
  
  socket.onClose((closeEvent) {
    print('Connection closed: ${closeEvent['reason']}');
  });
  
  // Connect to WebSocket server
  await socket.connect('wss://echo.websocket.org');
  
  // Send string message
  socket.send('Simple text message');
  
  // Send JSON data
  socket.send({
    'type': 'chat_message',
    'content': 'Hello everyone!',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  });
  
  // Close connection when done
  socket.close(1000, 'Normal closure');
}
```

## ZapRealtime

`ZapRealtime` builds on `ZapSocket` to provide advanced real-time communication features.

### Features

- Singleton pattern for app-wide WebSocket management
- Topic-based subscriptions
- Event emission and handling
- Authentication header support
- Automatic reconnection
- Connection state management
- Ping/pong for connection keepalive


### Basic Usage

```dart
import 'package:zap/zap_realtime.dart';
import 'package:zap/models/session_response.dart';

void main() async {
  final session = SessionResponse(
    accessToken: 'your_access_token',
    userId: 'user_123',
  );
  
  final zapRealtime = ZapRealtime(
    config: ZapRealtimeConfig(
      url: 'wss://realtime.example.com/socket',
      session: session,
      
      // Optional configuration
      pingInterval: Duration(seconds: 30),
      maxReconnectAttempts: 5,
      reconnectDelay: Duration(seconds: 3),
      
      // Event handlers
      onStateChanged: (state) {
        print('Connection state: $state');
      },
      onReceived: (response) {
        print('Received: ${response.data}');
      },
      onError: (where, error) {
        print('Error in $where: $error');
      },
    ),
  );
  
  // Connect to WebSocket server
  await zapRealtime.connect();
  
  // Subscribe to topics
  zapRealtime.subscribe(
    topic: '/user/notifications',
    onMessage: (response) {
      print('Notification: ${response.data}');
    },
  );
  
  // Send data to specific endpoint
  zapRealtime.send(
    endpoint: '/chat/messages',
    data: {
      'content': 'Hello everyone!',
      'roomId': 'general',
    },
  );
  
  // Register event listeners
  zapRealtime.on('user_joined', (data) {
    print('User joined: ${data['username']}');
  });
  
  // Emit events
  zapRealtime.emit('user_typing', {
    'roomId': 'general',
    'userId': 'user_123',
  });
  
  // Unsubscribe when needed
  zapRealtime.unsubscribe('/user/notifications');
  
  // Remove event listener
  zapRealtime.off('user_joined');
  
  // Disconnect when done
  zapRealtime.disconnect();
}
```

### Stream-based API

```dart
// Listen to connection state changes
zapRealtime.connectionStateStream.listen((state) {
  print('Connection state changed: $state');
});

// Listen to all incoming data
zapRealtime.dataStream.listen((response) {
  print('Received data: ${response.data}');
});

// Listen to errors
zapRealtime.errorStream.listen((error) {
  print('Error: ${error.where} - ${error.error}');
});
```

## ZapUtils

`ZapUtils` provides utility functions for common networking tasks.

### Features

- IP address fetching
- Image downloading
- Location information retrieval
- Distance and travel time calculation


### Basic Usage

```dart
import 'package:zap/zap_utils.dart';
import 'dart:typed_data';

void main() async {
  final zapUtils = ZapUtils.instance;
  
  // Get public IP address
  final ipAddress = await zapUtils.fetchIpAddress();
  print('Your IP: $ipAddress');
  
  // Download image with callbacks
  await zapUtils.fetchImageData(
    url: 'https://example.com/image.jpg',
    onSuccess: (Uint8List data) {
      print('Image downloaded: ${data.length} bytes');
    },
    onError: (String error) {
      print('Error: $error');
    },
  );
  
  // Download image with Future
  final imageData = await zapUtils.fetchImageDataAsync('https://example.com/image.jpg');
  if (imageData != null) {
    print('Image downloaded: ${imageData.length} bytes');
  }
  
  // Get location information
  final location = await zapUtils.getLocationInformation(40.7128, -74.0060);
  print('Location: ${location.displayName}');
  print('City: ${location.city}');
  print('Country: ${location.country}');
  
  // Calculate distance and travel time
  final distanceData = await zapUtils.getTotalDistanceAndTime(
    originLatitude: 40.7128,
    originLongitude: -74.0060,
    destinationLatitude: 34.0522,
    destinationLongitude: -118.2437,
    googleMapApiKey: 'YOUR_GOOGLE_MAPS_API_KEY',
  );
  
  print('Distance: ${distanceData[0]['distance']['text']}');
  print('Duration: ${distanceData[0]['duration']['text']}');
}
```

## Advanced Usage

### Combining Components

```dart
import 'package:zap/zap_pulse.dart';
import 'package:zap/zap_realtime.dart';
import 'package:zap/models/session_response.dart';

void main() async {
  // Set up shared session
  final session = SessionResponse(
    accessToken: 'your_access_token',
    refreshToken: 'your_refresh_token',
    userId: 'user_123',
  );
  
  // Initialize HTTP client
  final zapPulse = ZapPulse(
    config: ZapPulseConfig(
      session: session,
    ),
  );
  
  // Initialize WebSocket client with same session
  final zapRealtime = ZapRealtime(
    config: ZapRealtimeConfig(
      url: 'wss://realtime.example.com/socket',
      session: session,
    ),
  );
  
  // Fetch initial data via HTTP
  final userProfile = await zapPulse.get<Map<String, dynamic>>(
    endpoint: 'https://api.example.com/user/profile',
    useAuth: true,
  );
  
  // Connect to WebSocket for real-time updates
  await zapRealtime.connect();
  
  // Subscribe to updates for this user
  zapRealtime.subscribe(
    topic: '/user/${session.userId}/updates',
    onMessage: (response) {
      print('Profile update: ${response.data}');
    },
  );
  
  // Clean up when done
  ZapPulse.dispose();
  ZapRealtime.dispose();
}
```

### Custom Response Parsing

```dart
class User {
  final int id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// Using with ZapPulse
final response = await zapPulse.get<User>(
  endpoint: 'https://api.example.com/users/1',
  useAuth: true,
  parser: (data) => User.fromJson(data),
);

if (response.isOk) {
  final user = response.data;
  print('User: ${user.name} (${user.email})');
}
```

## Error Handling

### HTTP Error Handling

```dart
try {
  final response = await zap.get<Map<String, dynamic>>(
    'https://api.example.com/data',
  );
  
  if (response.statusCode >= 200 && response.statusCode < 300) {
    // Success
    print('Data: ${response.body}');
  } else {
    // HTTP error
    print('HTTP Error ${response.statusCode}: ${response.error}');
  }
} catch (e) {
  // Network or other error
  print('Error: $e');
}
```

### ZapPulse Error Handling

```dart
final response = await zapPulse.get<Map<String, dynamic>>(
  endpoint: 'https://api.example.com/data',
  useAuth: true,
);

if (response.isOk) {
  // Success
  print('Data: ${response.data}');
} else {
  // Error
  print('Error ${response.code}: ${response.message}');
}
```

### WebSocket Error Handling

```dart
zapSocket.onError((error) {
  print('WebSocket error: $error');
});

zapSocket.onClose((closeEvent) {
  print('WebSocket closed: ${closeEvent['code']} - ${closeEvent['reason']}');
});
```

### ZapRealtime Error Handling

```dart
// Option 1: Callback
zapRealtime = ZapRealtime(
  config: ZapRealtimeConfig(
    url: 'wss://realtime.example.com/socket',
    onError: (where, error) {
      print('Error in $where: $error');
    },
  ),
);

// Option 2: Stream
zapRealtime.errorStream.listen((errorResponse) {
  print('Error in ${errorResponse.where}: ${errorResponse.error}');
  print('Timestamp: ${errorResponse.timestamp}');
});
```

## Best Practices

### Singleton Management

```dart
// Application startup
void initNetworking() {
  // Initialize ZapPulse
  ZapPulse(
    config: ZapPulseConfig(
      sessionFactory: () => getSessionFromStorage(),
      onSessionRefreshed: refreshSession,
    ),
  );
  
  // Initialize ZapRealtime
  ZapRealtime(
    config: ZapRealtimeConfig(
      url: 'wss://realtime.example.com/socket',
      sessionFactory: () => getSessionFromStorage(),
    ),
  );
}

// Use anywhere in the app
void someFunction() {
  // Get the singleton instances
  final zapPulse = ZapPulse.instance;
  final zapRealtime = ZapRealtime.instance;
  
  // Use them...
}

// Application shutdown
void disposeNetworking() {
  ZapPulse.dispose();
  ZapRealtime.dispose();
}
```

### Authentication Management

```dart
// Session storage
SessionResponse? _currentSession;

// Login function
Future<void> login(String username, String password) async {
  final zap = Zap();
  
  try {
    final response = await zap.post<Map<String, dynamic>>(
      'https://api.example.com/login',
      {'username': username, 'password': password},
    );
    
    if (response.statusCode == 200) {
      // Create session from response
      _currentSession = SessionResponse(
        accessToken: response.body!['access_token'],
        refreshToken: response.body!['refresh_token'],
        userId: response.body!['user_id'],
      );
      
      // Initialize ZapPulse with the new session
      ZapPulse(
        config: ZapPulseConfig(
          session: _currentSession,
          sessionFactory: () => _currentSession,
          onSessionRefreshed: _refreshSession,
        ),
      );
      
      // Initialize ZapRealtime with the same session
      ZapRealtime(
        config: ZapRealtimeConfig(
          url: 'wss://realtime.example.com/socket',
          session: _currentSession,
          sessionFactory: () => _currentSession,
        ),
      );
    }
  } finally {
    zap.dispose();
  }
}

// Session refresh function
Future<SessionResponse?> _refreshSession() async {
  final zap = Zap();
  
  try {
    final response = await zap.post<Map<String, dynamic>>(
      'https://api.example.com/refresh',
      {'refresh_token': _currentSession?.refreshToken},
    );
    
    if (response.statusCode == 200) {
      _currentSession = SessionResponse(
        accessToken: response.body!['access_token'],
        refreshToken: response.body!['refresh_token'] ?? _currentSession?.refreshToken,
        userId: _currentSession!.userId,
      );
      
      return _currentSession;
    }
  } finally {
    zap.dispose();
  }
  
  return null;
}

// Logout function
void logout() {
  _currentSession = null;
  ZapPulse.dispose();
  ZapRealtime.dispose();
}
```

## API Reference

### Zap

```dart
Zap({
  String userAgent = 'zap-client',
  Duration timeout = const Duration(seconds: 8),
  bool followRedirects = true,
  int maxRedirects = 5,
  bool sendUserAgent = false,
  bool sendContentLength = true,
  int maxAuthRetries = 1,
  String? baseUrl,
  String defaultContentType = 'application/json; charset=utf-8',
  bool errorSafety = true,
})

// Methods
Future<ZapResponse<T>> get<T>(String url, {...})
Future<ZapResponse<T>> post<T>(String url, dynamic body, {...})
Future<ZapResponse<T>> put<T>(String url, dynamic body, {...})
Future<ZapResponse<T>> patch<T>(String url, dynamic body, {...})
Future<ZapResponse<T>> delete<T>(String url, {...})
void cancelAllRequests([String reason = 'All requests cancelled'])
void dispose()
```

### ZapPulse

```dart
ZapPulse({required ZapPulseConfig config})
static ZapPulse get instance
static void dispose()

// Methods
Future<ApiResponse<T>> get<T>({required String endpoint, ...})
Future<ApiResponse<T>> post<T>({required String endpoint, dynamic body, ...})
Future<ApiResponse<T>> put<T>({required String endpoint, dynamic body, ...})
Future<ApiResponse<T>> patch<T>({required String endpoint, dynamic body, ...})
Future<ApiResponse<T>> delete<T>({required String endpoint, ...})
```

### ZapSocket

```dart
ZapSocket()

// Properties
bool get isConnected

// Methods
Future<void> connect(String url)
void onOpen(Function() callback)
void onMessage(Function(dynamic) callback)
void onError(Function(dynamic) callback)
void onClose(Function(dynamic) callback)
void send(dynamic data)
void close([int? code, String? reason])
```

### ZapRealtime

```dart
ZapRealtime({required ZapRealtimeConfig config})
static ZapRealtime get instance
static void dispose()

// Properties
bool get isConnected
ZapRealtimeState get connectionState
Stream<ZapRealtimeState> get connectionStateStream
Stream<ZapRealtimeResponse> get dataStream
Stream<ZapRealtimeErrorResponse> get errorStream

// Methods
Future<void> connect()
void disconnect()
void send({required String endpoint, required dynamic data, ...})
void subscribe({required String topic, required void Function(ZapRealtimeResponse) onMessage})
void unsubscribe(String topic)
void on(String event, void Function(dynamic data) callback)
void off(String event)
void emit(String event, dynamic data)
```

### ZapUtils

```dart
static ZapUtils get instance

// Methods
Future<String> fetchIpAddress([bool log = true])
Future<void> fetchImageData({required String url, required Function(Uint8List) onSuccess, required Function(String) onError, bool log = true})
Future<Uint8List?> fetchImageDataAsync(String url, [bool log = true])
Future<List<dynamic>> getTotalDistanceAndTime({required double originLatitude, required double originLongitude, required double destinationLatitude, required double destinationLongitude, required String googleMapApiKey, bool log = true})
Future<LocationInformation> getLocationInformation(double latitude, double longitude, [bool log = true])
void dispose()
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Example Projects

Check out these example projects that demonstrate how to use Zap in real-world applications:

- [Simple REST Client](https://github.com/example/zap-rest-example)
- [Chat Application with ZapRealtime](https://github.com/example/zap-chat-example)
- [Location-based Service with ZapUtils](https://github.com/example/zap-location-example)


## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/yourusername/zap/issues).