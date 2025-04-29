import 'package:flutter/widgets.dart';

class SmartRouteDecoder {
  final String location;
  final Map<String, String> parameters;
  final Map<String, dynamic>? arguments;
  final RouteSettings settings;

  SmartRouteDecoder({
    required this.location,
    required this.parameters,
    this.arguments,
    required this.settings,
  });

  SmartRouteDecoder copyWith({
    String? location,
    Map<String, String>? parameters,
    Map<String, dynamic>? arguments,
    RouteSettings? settings,
  }) {
    return SmartRouteDecoder(
      location: location ?? this.location,
      parameters: parameters ?? this.parameters,
      arguments: arguments ?? this.arguments,
      settings: settings ?? this.settings,
    );
  }
}