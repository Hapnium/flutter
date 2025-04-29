import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animations/transitions.dart';
import '../enums/smart_transition.dart';
import 'smart_route.dart';
import 'smart_route_decoder.dart';

class SmartRouter {
  static final Map<String, SmartRoute> _routes = {};
  static final Map<String, String> _params = {};
  static Map<String, dynamic>? _arguments;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void define(SmartRoute route) {
    _routes[route.path] = route;
  }

  static Widget _defaultNotFoundScreen() => Scaffold(body: Center(child: Text('404 - Route not found')));

  static Widget? _notFoundScreen;
  static Widget? _loadingScreen;

  static void setNotFoundScreen(Widget Function() notFoundScreen) {
    _notFoundScreen = notFoundScreen();
  }
  
  static void setLoadingScreen(Widget Function() loadingScreen) {
    _loadingScreen = loadingScreen();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final SmartRoute? matchedRoute = _matchRoute(uri.path);

    if (matchedRoute != null) {
      _extractParams(uri.path, matchedRoute.path);
      _arguments = settings.arguments as Map<String, dynamic>?;

      final SmartRouteDecoder decoder = SmartRouteDecoder(
        location: uri.path,
        parameters: _params,
        arguments: _arguments,
        settings: settings,
      );

      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FutureBuilder<SmartRouteDecoder?>(
            future: _runMiddlewares(matchedRoute, decoder),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  return matchedRoute.builder(context);
                } else {
                  return _notFoundScreen ?? _defaultNotFoundScreen();
                }
              }
              return _loadingScreen ?? const Center(child: CircularProgressIndicator());
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          switch (matchedRoute.transition) {
            case SmartTransition.fade:
              return FadeTransition(opacity: animation, child: child);
            case SmartTransition.leftToRightWithFade:
              return LeftToRightFadeTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.rightToLeftWithFade:
              return RightToLeftFadeTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.fadeIn:
              return FadeInTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.circularReveal:
              return CircularRevealTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.rightToLeft:
              return SlideLeftTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.leftToRight:
              return SlideRightTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.upToDown:
              return SlideTopTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.downToUp:
              return SlideDownTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.zoom:
              return ZoomInTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.noTransition:
              return NoTransition().buildTransitions(context, animation, secondaryAnimation, child);
            case SmartTransition.size:
              return SizeTransitions().buildTransitions(context, Curves.linear, animation, secondaryAnimation, child);
            case SmartTransition.cupertino:
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: true,
                child: child,
              );
            default:
              return child;
          }
        },
        transitionDuration: matchedRoute.transitionDuration,
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => _notFoundScreen ?? _defaultNotFoundScreen(),
      );
    }
  }

  static Future<SmartRouteDecoder?> _runMiddlewares(SmartRoute route, SmartRouteDecoder decoder) async {
    SmartRouteDecoder currentDecoder = decoder;

    for (var middleware in route.middlewares) {
      final result = await middleware.redirect(currentDecoder);

      if (result == null) {
        return null; // Blocked by middleware
      }

      if (result.location != currentDecoder.location) {
        // If location is different, a redirection is happening
        return result;
      }

      // No change? Continue with possibly modified decoder (ex: updated params or args)
      currentDecoder = result;
    }

    return currentDecoder;
  }

  static SmartRoute? _matchRoute(String path) {
    for (final route in _routes.entries) {
      if (_comparePaths(path, route.key)) {
        return route.value;
      }
    }
    return null;
  }

  static bool _comparePaths(String path, String template) {
    final pathSegments = path.split('/');
    final templateSegments = template.split('/');
    if (pathSegments.length != templateSegments.length) return false;

    for (int i = 0; i < pathSegments.length; i++) {
      if (templateSegments[i].startsWith(':')) continue;
      if (pathSegments[i] != templateSegments[i]) return false;
    }
    return true;
  }

  static void _extractParams(String path, String template) {
    _params.clear();
    final pathSegments = path.split('/');
    final templateSegments = template.split('/');
    for (int i = 0; i < templateSegments.length; i++) {
      if (templateSegments[i].startsWith(':')) {
        _params[templateSegments[i].substring(1)] = pathSegments[i];
      }
    }
  }

  // --- Smart Shortcuts ---

  static Future<dynamic> to(String routeName, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> off(String routeName, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void back() {
    navigatorKey.currentState!.pop();
  }

  static Map<String, String> get params => _params;
  static Map<String, dynamic>? get arguments => _arguments;
}