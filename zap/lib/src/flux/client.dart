import '../http/request/request.dart';
import '../core/zap_interface.dart';
import '../http/response/response.dart';
import '../http/utils/http_status.dart';
import '../models/flux_config.dart';
import '../core/zap.dart';
import 'extension.dart';

/// [fluxClient] is a factory function that returns a [ZapInterface] instance.
/// 
/// It is used to create a new instance of [Zap] or [_Connect] based on the configuration.
/// 
/// It is used internally by [Flux] to provide a more robust and flexible HTTP client.
ZapInterface fluxClient(FluxConfig config, [bool useAuth = false]) {
  if(config.useSingleInstance) {
    return Zap(zapConfig: config.zapConfig);
  } else {
    ZapInterface inst = _Connect(config, useAuth);
    inst.onStart();

    return inst;
  }
}

/// [_Connect] is a private class that extends [Zap] and implements the [ZapInterface].
/// 
/// It uses the design system of [Zap] to provide a more robust and flexible HTTP client.
/// 
/// It is used internally by [Flux] to provide a more robust and flexible HTTP client.
class _Connect extends Zap {
  final bool useAuth;
  final FluxConfig fx;

  _Connect(this.fx, this.useAuth) : super(zapConfig: fx.zapConfig);

  @override
  void onInit() {
    if(fx.headers != null) {
      client.addRequestModifier<void>((Request request) async {
        request.headers.addAll(fx.buildHeaders());
        
        return request;
      });
    }

    if(useAuth) {
      fx.checkAuth(useAuth);

      client.addRequestModifier<void>((Request request) async {
        if (fx.currentSession != null) {
          request.headers.addAll(fx.buildHeadersWithAuth());
        }
        
        return request;
      });

      client.addResponseModifier<void>((Request request, Response response) async {
        if (response.status == HttpStatus.UNAUTHORIZED) {
          final session = await fx.handleSessionRefresh();
          if (session != null) {
            request.headers.addAll(fx.buildHeadersWithAuth(session: session));
            return await client.request(request.method, request.url.toString());
          } else {
            // If unable to refresh token, redirect user to login or handle it accordingly
            // Example: Redirect to login page
            fx.whenUnauthorized?.call();
          }
        }

        return response;
      });
    }

    super.onInit();
  }
}