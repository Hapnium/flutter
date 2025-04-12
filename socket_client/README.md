# **Socket Client**

`socket_client` is a lightweight and highly configurable package for managing WebSocket connections in Flutter applications. It supports message sending, event handling, and real-time communication with server-side WebSocket endpoints.

---

## **Authentication**

For local development, use the `.netrc` file for secure credential storage. This ensures credentials are not embedded directly in URLs.

### Steps:

1. **Create a `.netrc` File:**
    ```bash
    machine github.com
    login your_username
    password your_personal_access_token
    ```

2. **Set Permissions:**
    ```bash
    chmod 600 ~/.netrc
    ```

---

## **Installation**

Install `socket_client` using Flutter:

```yaml
dependencies:
  socket_client:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: socket_client
```

Run `flutter pub get` to install the package.

---

## **Usage**

### **Example Implementation**

```dart
import 'package:socket_client/socket_client.dart';
import 'package:tracing/tracing.dart';

void main() {
  SocketClient socket = SocketClient.create(
    config: SocketConfig(
      useToken: false,
      mode: Server.PRODUCTION,
      onReceived: (response) {
        console.log(response.body, from: "Socket Response");
      },
      showConnectionLogs: true,
      showErrorLogs: true,
      showSendLogs: true,
      showDebugLogs: true,
      isWebPlatform: true,
      subscription: "/platform",
    ),
  );

  if (socket.isConnected) {
    Map<String, dynamic> message = {
      "room": "typing.room",
      "state": "state.value",
    };

    socket.send(endpoint: "/chat/typing/notify", message: message);
  }
}
```

### **Configuration Parameters**

| Parameter               | Type       | Description                                                                                   |
|-------------------------|------------|-----------------------------------------------------------------------------------------------|
| `useToken`              | `bool`     | Indicates whether the connection uses authentication tokens.                                  |
| `mode`                  | `Server`   | Specifies the server environment (`Server.PRODUCTION`, `Server.SANDBOX`, etc.).               |
| `onReceived`            | `Function` | Callback triggered when a message is received from the WebSocket.                             |
| `showConnectionLogs`    | `bool`     | Enables logging of connection events.                                                        |
| `showErrorLogs`         | `bool`     | Enables logging of error messages.                                                           |
| `showSendLogs`          | `bool`     | Enables logging of outgoing messages.                                                        |
| `showDebugLogs`         | `bool`     | Enables detailed debug logs.                                                                 |
| `isWebPlatform`         | `bool`     | Indicates whether the platform is a web-based environment.                                    |
| `subscription`          | `String`   | Specifies the WebSocket subscription endpoint for server events.                              |

---

### **Features**

1. **Real-time Communication:**
    - Effortlessly send and receive WebSocket messages.

2. **Event Subscriptions:**
    - Manage subscriptions to specific server endpoints for real-time updates.

3. **Platform Agnostic:**
    - Works seamlessly across mobile and web platforms.

4. **Logging and Debugging:**
    - Extensive logging options to aid in debugging and monitoring WebSocket traffic.

---

## **License**

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.