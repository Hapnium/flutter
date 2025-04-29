import 'package:flutter/material.dart';

import '../enums/smart_transition.dart';
import '../middlewares/smart_middleware.dart';

typedef SmartRouteBuilder = Widget Function(BuildContext context);

class SmartRoute {
  final String path;
  final SmartRouteBuilder builder;
  final List<SmartMiddleware> middlewares;
  // final List<SmartController> controllers;
  final SmartTransition transition;
  final Duration transitionDuration;

  SmartRoute({
    required this.path,
    required this.builder,
    this.middlewares = const [],
    this.transition = SmartTransition.native,
    this.transitionDuration = const Duration(milliseconds: 300),
  });
}