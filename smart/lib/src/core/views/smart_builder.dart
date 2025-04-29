import 'package:flutter/widgets.dart';
import 'package:smart/responsive.dart';

import '../di/smart_di.dart';
import '../state/smart_controller.dart';

typedef SmartBuilderFunction<T extends SmartController> = Widget Function(BuildContext context, T controller, ResponsiveUtil responsive);

class SmartBuilder<T extends SmartController> extends StatelessWidget {
  final SmartBuilderFunction<T> builder;
  final T controller;

  const SmartBuilder({required this.controller, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return builder(context, controller, ResponsiveUtil(context, config: SmartDI.responsive));
  }
}