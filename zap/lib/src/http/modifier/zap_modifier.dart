import 'dart:async';

import '../request/request.dart';
import '../response/response.dart';

/// A request modifier is a function that will be called before the request is sent
typedef RequestModifier<T> = FutureOr<Request<T>> Function(Request<T?> request);

/// A response modifier is a function that will be called after the response is received
typedef ResponseModifier<T> = FutureOr Function(Request<T?> request, Response<T?> response);

/// {@template zap_modifier}
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
/// 
/// {@endtemplate}
class ZapModifier<S> {
  final _requestModifiers = <RequestModifier>[];
  final _responseModifiers = <ResponseModifier>[];

  /// The authenticator is a request modifier that will be called to authenticate the request
  RequestModifier? authenticator;

  /// {@macro zap_modifier}
  ZapModifier();

  /// Add a request modifier to the modifier
  /// 
  /// Args:
  ///   interceptor: The request modifier to add
  void addRequestModifier<T>(RequestModifier<T> interceptor) {
    _requestModifiers.add(interceptor as RequestModifier);
  }

  /// Remove a request modifier from the modifier
  /// 
  /// Args:
  ///   interceptor: The request modifier to remove
  void removeRequestModifier<T>(RequestModifier<T> interceptor) {
    _requestModifiers.remove(interceptor);
  }

  /// Add a response modifier to the modifier
  /// 
  /// Args:
  ///   interceptor: The response modifier to add
  void addResponseModifier<T>(ResponseModifier<T> interceptor) {
    _responseModifiers.add(interceptor as ResponseModifier);
  }

  /// Remove a response modifier from the modifier
  /// 
  /// Args:
  ///   interceptor: The response modifier to remove
  void removeResponseModifier<T>(ResponseModifier<T> interceptor) {
    _responseModifiers.remove(interceptor);
  }

  /// Modify the request
  /// 
  /// Args:
  ///   request: The request to modify
  /// 
  /// Returns:
  ///   The modified request
  Future<Request<T>> modifyRequest<T>(Request<T> request) async {
    var newRequest = request;
    if (_requestModifiers.isNotEmpty) {
      for (var interceptor in _requestModifiers) {
        newRequest = await interceptor(newRequest) as Request<T>;
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
  Future<Response<T>> modifyResponse<T>(Request<T> request, Response<T> response) async {
    var newResponse = response;
    if (_responseModifiers.isNotEmpty) {
      for (var interceptor in _responseModifiers) {
        newResponse = await interceptor(request, newResponse) as Response<T>;
      }
    }

    return newResponse;
  }
}