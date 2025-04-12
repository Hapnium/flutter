import 'dart:convert';

import 'package:connectify/connectify.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:dio/dio.dart' as d;
import 'package:tracing/tracing.dart';

import '../../utilities/base_url.dart';
import '../error_handler_service.dart';
import '../token_manager_service.dart';
import 'connectify_error_handler.dart';

class Connectify<T> extends Interceptor implements ConnectifyService<T> {
  ConnectifyConfig config;

  Connectify({required this.config});

  TokenManagerService _tokenService = ConnectifyTokenManager();
  ErrorHandlerService<T> _errorHandler = ConnectifyErrorHandler<T>();

  String get _baseUrl {
    if(config.baseUrl != null) {
      return config.baseUrl!;
    } else if(config.mode == Server.SANDBOX) {
      return BaseUrl.SANDBOX;
    } else if(config.mode == Server.PORTAL) {
      return BaseUrl.PORTAL_PRODUCTION;
    } else if(config.mode == Server.PRODUCTION) {
      return BaseUrl.PRODUCTION;
    } else {
      throw ConnectifyException("You need to provide the base url for this request");
    }
  }

  Dio get _client {
    return Dio(
      BaseOptions(
        connectTimeout: config.connectTimeout,
        baseUrl: _baseUrl,
        contentType: d.Headers.jsonContentType,
      ),
    )..interceptors.add(this);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(this.config.useToken && this.config.session == null) {
      throw ConnectifyException("Session is required to continue with authenticated requests");
    }

    Headers headers = {
      'Accept': 'application/json'
    };

    if (this.config.useToken && this.config.session != null) {
      String token = 'Bearer ${this.config.session!.accessToken}';
      headers.update("Authorization", (v) => token, ifAbsent: () => token);
    }

    if (this.config.headers != null) {
      headers.addAll(this.config.headers!);
    }

    if (!this.config.isWebPlatform) {
      String value = 'application/json';
      headers.update('Content-Type', (v) => value, ifAbsent: () => value);
    }

    // Add authorization headers if needed
    options.headers.addAll(headers);

    if (this.config.showRequestLogs) {
      console.debug('Request Endpoint: Method=[${options.method}] -> ${options.path}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if(this.config.showErrorLogs) {
      console.error(err.message, from: "Error Message");
      console.error(err.error, from: "Error Object Information");
      console.error(err.type, from: "Error Type");

      if(err.response != null) {
        console.fatal(err.response?.data, from: "Error Data");
        console.fatal(err.response?.statusCode, from: "Error Status Code");
        console.fatal(err.response?.statusMessage, from: "Error Status Message");
        console.fatal(err.response?.headers, from: "Error Headers");
        console.fatal(err.response?.realUri, from: "Error URI");
        console.fatal(err.response?.extra, from: "Error Extra Information");
      }
    }

    if (err.type == DioExceptionType.connectionTimeout) {
      throw ConnectifyException("Connection timed out. Check your network and try again");
    } else if (err.response?.statusCode == 401) {
      refreshToken().then((newToken) {
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          handler.resolve(err.response!);
          handler.next(err);
        } else {
          throw ConnectifyException("Cannot continue with request. You will be redirected to login", isSessionExpired: true);
        }
      }).catchError((error) {
        handler.reject(err);
      });
    } else {
      handler.next(err);
    }
  }

  Future<String?> refreshToken() async {
    Dio dio = Dio();

    String? token;
    try {
      var response = await dio.get(
        "$_baseUrl/auth/session/refresh?token=${this.config.session?.accessToken}",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if(response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 299)) {
        ApiResponse<SessionResponse> apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.isOk && apiResponse.data != null) {
          this.config.onSessionUpdate?.call(apiResponse.data!);
          this.config.copyWith(session: apiResponse.data!);

          token = apiResponse.data!.accessToken;
        }
      }
    } catch (error) {
      if (error is String) {
        throw ConnectifyException(error);
      } else if (error is List<String>) {
        for (var value in error) {
          throw ConnectifyException(value);
        }
      } else if (error is Map<String, dynamic> && error.containsKey('message')) {
        throw ConnectifyException(error['message']);
      } else {
        throw ConnectifyException("An error occurred while performing request. Try again shortly.");
      }
    }
    return token;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(this.config.showResponseLogs) {
      console.log(response.data, from: "Response Data");
      console.log(response.statusCode, from: "Response Status Code");
      console.log(response.statusMessage, from: "Response Status Message");
      console.log(response.headers, from: "Response Headers");
      console.log(response.realUri, from: "Response URI");
      console.log(response.extra, from: "Response Extra Information");
    }

    super.onResponse(response, handler);
  }

  Future<ApiResponse<T>> send({
    required String method,
    required String endpoint,
    RequestBody? body,
    RequestParam? query,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<dynamic> response = await _client.request(
        endpoint,
        data: body,
        queryParameters: query,
        options: Options(method: method),
        cancelToken: _tokenService.getToken(),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if(response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 299)) {
        ApiResponse<T> api = ApiResponse<T>.error("");

        if(response.data is String) {
          try {
            api = ApiResponse<T>.fromJson(jsonDecode(response.data));
          } catch (_) { }
        } else if(response.data is Map<String, dynamic>) {
          api = ApiResponse<T>.fromJson(response.data);
        }

        return api;
      } else {
        throw ConnectifyException(response.statusMessage ?? "Couldn't complete request. An error occurred");
      }
    } on DioException catch (exception) {
      ApiResponse<T> response = _errorHandler.handleDioException(exception);
      _cancelAllRequests(response);
      return response;
    } on ConnectifyException catch (e) {
      ApiResponse<T> response = _errorHandler.handleConnectifyException(e);
      _cancelAllRequests(response);
      return response;
    } on Exception catch (e) {
      if(this.config.showErrorLogs) {
        console.fatal(e, from: "Error trace in Connectify");
        console.trace(_client.options.baseUrl);
      }

      ApiResponse<T> response = _errorHandler.handleException(e);
      _cancelAllRequests(response);
      return response;
    } on StackTrace catch (e) {
      if(this.config.showErrorLogs) {
        console.fatal(e, from: "Error trace in Connectify");
        console.trace(_client.options.baseUrl);
      }

      ApiResponse<T> response = _errorHandler.handleStackTrace(e);
      _cancelAllRequests(response);
      return response;
    } catch (e) {
      if(this.config.showErrorLogs) {
        console.fatal(e, from: "Error trace in Connectify");
        console.trace(_client.options.baseUrl);
      }

      ApiResponse<T> response = _errorHandler.handleError(e);
      _cancelAllRequests(response);
      return response;
    }
  }

  void _cancelAllRequests(ApiResponse<T> response) {
    if((response.status == "FORBIDDEN" && response.code == 403)) {
      _tokenService.cancelAll();
      this.config.onRemoveRoutes?.call();
    }
  }

  @override
  Future<ApiResponse<T>> delete({required String endpoint, RequestParam? query, RequestBody body}) async {
    return send(method: 'DELETE', endpoint: endpoint, query: query, body: body);
  }

  @override
  Future<ApiResponse<T>> get({required String endpoint, RequestParam? query, OnProgressCallback? onReceiveProgress}) async {
    return send(method: 'GET', endpoint: endpoint, query: query, onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<ApiResponse<T>> patch({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  }) async {
    return send(
      method: 'PATCH',
      endpoint: endpoint,
      query: query,
      body: body,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }

  @override
  Future<ApiResponse<T>> put({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  }) async {
    return send(
      method: 'PUT',
      endpoint: endpoint,
      query: query,
      body: body,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }

  @override
  Future<ApiResponse<T>> post({
    required String endpoint,
    RequestBody body,
    RequestParam? query,
    OnProgressCallback? onSendProgress,
    OnProgressCallback? onReceiveProgress
  }) async {
    return send(
      method: 'POST',
      endpoint: endpoint,
      query: query,
      body: body,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }
}