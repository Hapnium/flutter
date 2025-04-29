// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
//
// import '../di/smart_di.dart';
// import '../main/smart.dart';
// import '../main/smart_management.dart';
// import '../state/list_notifier.dart';
//
//
// typedef SmartXControllerBuilder<T extends SmartLifeCycleMixin> = Widget Function(T controller);
//
// class SmartX<T extends SmartLifeCycleMixin> extends StatefulWidget {
//   final SmartXControllerBuilder<T> builder;
//   final bool global;
//   final bool autoRemove;
//   final bool assignId;
//   final void Function(SmartXState<T> state)? initState, dispose, didChangeDependencies;
//   final void Function(SmartX oldWidget, SmartXState<T> state)? didUpdateWidget;
//   final T? init;
//   final String? tag;
//
//   const SmartX({
//     super.key,
//     this.tag,
//     required this.builder,
//     this.global = true,
//     this.autoRemove = true,
//     this.initState,
//     this.assignId = false,
//     //  this.stream,
//     this.dispose,
//     this.didChangeDependencies,
//     this.didUpdateWidget,
//     this.init,
//     // this.streamController
//   });
//
//   @override
//   StatefulElement createElement() => StatefulElement(this);
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(DiagnosticsProperty<T>('controller', init),)
//       ..add(DiagnosticsProperty<String>('tag', tag))
//       ..add(ObjectFlagProperty<SmartXControllerBuilder<T>>.has('builder', builder));
//   }
//
//   @override
//   SmartXState<T> createState() => SmartXState<T>();
// }
//
// class SmartXState<T extends SmartLifeCycleMixin> extends State<SmartX<T>> {
//   T? controller;
//   bool? _isCreator = false;
//
//   @override
//   void initState() {
//     // var isPrepared = Smart.isPrepared<T>(tag: widget.tag);
//     final isRegistered = SmartDI.isRegistered<T>(tag: widget.tag);
//
//     if (widget.global) {
//       if (isRegistered) {
//         _isCreator = SmartDI.isPrepared<T>(tag: widget.tag);
//         controller = SmartDI.find<T>(tag: widget.tag);
//       } else {
//         controller = widget.init;
//         _isCreator = true;
//         Smart.put<T>(controller!, tag: widget.tag);
//       }
//     } else {
//       controller = widget.init;
//       _isCreator = true;
//       controller?.onStart();
//     }
//     widget.initState?.call(this);
//     if (widget.global && Smart.smartManagement == SmartManagement.onlyBuilder) {
//       controller?.onStart();
//     }
//
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (widget.didChangeDependencies != null) {
//       widget.didChangeDependencies!(this);
//     }
//   }
//
//   @override
//   void didUpdateWidget(SmartX oldWidget) {
//     super.didUpdateWidget(oldWidget as SmartX<T>);
//     widget.didUpdateWidget?.call(oldWidget, this);
//   }
//
//   @override
//   void dispose() {
//     if (widget.dispose != null) widget.dispose!(this);
//     if (_isCreator! || widget.assignId) {
//       if (widget.autoRemove && Smart.isRegistered<T>(tag: widget.tag)) {
//         Smart.delete<T>(tag: widget.tag);
//       }
//     }
//
//     for (final disposer in disposers) {
//       disposer();
//     }
//
//     disposers.clear();
//
//     controller = null;
//     _isCreator = null;
//     super.dispose();
//   }
//
//   void _update() {
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   final disposers = <Disposer>[];
//
//   @override
//   Widget build(BuildContext context) => Notifier.instance.append(NotifierData(disposers: disposers, updater: _update), () => widget.builder(controller!));
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<T>('controller', controller));
//   }
// }