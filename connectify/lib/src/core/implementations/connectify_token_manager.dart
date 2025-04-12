import 'package:dio/dio.dart' show CancelToken;

import '../token_manager_service.dart';

class ConnectifyTokenManager implements TokenManagerService {
  bool showLogs = true;

  CancelToken _token = CancelToken();

  @override
  void cancelAll() {
    _token.cancel("Operation cancelled");
    _token = CancelToken();
  }

  @override
  CancelToken getToken() {
    return CancelToken();
  }
}