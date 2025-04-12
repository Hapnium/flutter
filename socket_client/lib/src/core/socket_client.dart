import 'package:socket_client/socket_client.dart';

import '../services/web_socket_service.dart';
import '../services/implementations/web_socket_implementation.dart';

abstract class SocketClient implements WebSocketService {
  SocketClient();

  factory SocketClient.create({required SocketConfig config}) {
    return WebSocketImplementation(config);
  }
}