import 'package:socket_client/socket_client.dart';
import 'package:tracing/tracing.dart';

void main() {
  SocketClient socket = SocketClient.create(config: SocketConfig(
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
  ));

  if(socket.isConnected) {
    Map<String, dynamic> message = {
      "room": "typing.room",
      "state": "state.value",
    };

    socket.send(endpoint: "/chat/typing/notify", message: message);
  }
}