import 'dart:async';

import '../request/request.dart';
import '../response/response.dart';

/// A request modifier is a function that will be called before the request is sent
typedef ZapRequestModifier<T> = FutureOr<ZapRequest<T>> Function(ZapRequest<T?> request);

/// A response modifier is a function that will be called after the response is received
typedef ZapResponseModifier<T> = FutureOr Function(ZapRequest<T?> request, ZapResponse<T?> response);

/// A request executor is a function that will be called to execute the request
typedef ZapRequestExecutor<T> = Future<ZapRequest<T>> Function();

/// A class to modify the request and response
/// 
/// Args:
///   S: The type of the request and response
/// 
/// Example:
/// ```dart
/// final modifier = ZapModifier<String>();
/// modifier.addRequestModifier((request) {
///   return request.copyWith(headers: {'Authorization': 'Bearer token'});
/// });
/// ```
class ZapModifier<S> {
  final _requestModifiers = <ZapRequestModifier>[];
  final _responseModifiers = <ZapResponseModifier>[];

  /// The authenticator is a request modifier that will be called to authenticate the request
  ZapRequestModifier? authenticator;

  /// Add a request modifier to the modifier
  /// 
  /// Args:
  ///   interceptor: The request modifier to add
  void addRequestModifier<T>(ZapRequestModifier<T> interceptor) {
    _requestModifiers.add(interceptor as ZapRequestModifier);
  }

  /// Remove a request modifier from the modifier
  /// 
  /// Args:
  ///   interceptor: The request modifier to remove
  void removeRequestModifier<T>(ZapRequestModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  /// Add a response modifier to the modifier
  /// 
  /// Args:
  ///   interceptor: The response modifier to add
  void addResponseModifier<T>(ZapResponseModifier<T> interceptor) {
    _responseModifiers.add(interceptor as ZapResponseModifier);
  }

  /// Remove a response modifier from the modifier
  /// 
  /// Args:
  ///   interceptor: The response modifier to remove
  void removeResponseModifier<T>(ZapResponseModifier<T> interceptor) {
    _responseModifiers.remove(interceptor);
  }

  /// Modify the request
  /// 
  /// Args:
  ///   request: The request to modify
  /// 
  /// Returns:
  ///   The modified request
  Future<ZapRequest<T>> modifyRequest<T>(ZapRequest<T> request) async {
    var newRequest = request;
    if (_requestModifiers.isNotEmpty) {
      for (var interceptor in _requestModifiers) {
        newRequest = await interceptor(newRequest) as ZapRequest<T>;
      }
    }

    return newRequest;
  }

  /// Modify the response
  /// 
  /// Args:
  ///   request: The request that was sent
  ///   response: The response to modify
  /// 
  /// Returns:
  ///   The modified response
  Future<ZapResponse<T>> modifyResponse<T>(ZapRequest<T> request, ZapResponse<T> response) async {
    var newResponse = response;
    if (_responseModifiers.isNotEmpty) {
      for (var interceptor in _responseModifiers) {
        newResponse = await interceptor(request, newResponse) as ZapResponse<T>;
      }
    }

    return newResponse;
  }
}