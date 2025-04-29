import 'dart:async';

import 'package:flutter/widgets.dart';

import '../mixins/stateless_observer_component.dart';

typedef ValueBuilderUpdateCallback<T> = void Function(T snapshot);
typedef WidgetCallback = Widget Function();
typedef ValueBuilderBuilder<T> = Widget Function(T snapshot, ValueBuilderUpdateCallback<T> updater);

/// Manages a local state like StxValue, but uses a callback instead of
/// a Rx value.
///
/// Example:
/// ```
///  ValueBuilder<bool>(
///    initialValue: false,
///    builder: (value, update) => Switch(
///    value: value,
///    onChanged: (flag) {
///       update( flag );
///    },),
///    onUpdate: (value) => print("Value updated: $value"),
///  ),
///  ```
class ValueBuilder<T> extends StatefulWidget {
  final T initialValue;
  final ValueBuilderBuilder<T> builder;
  final void Function()? onDispose;
  final void Function(T)? onUpdate;

  const ValueBuilder({
    super.key,
    required this.initialValue,
    this.onDispose,
    this.onUpdate,
    required this.builder,
  });

  @override
  ValueBuilderState<T> createState() => ValueBuilderState<T>();
}

class ValueBuilderState<T> extends State<ValueBuilder<T>> {
  late T value;
  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(value, updater);

  void updater(T newValue) {
    if (widget.onUpdate != null) {
      widget.onUpdate!(newValue);
    }
    setState(() {
      value = newValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call();
    if (value is ChangeNotifier) {
      (value as ChangeNotifier?)?.dispose();
    } else if (value is StreamController) {
      (value as StreamController?)?.close();
    }
  }
}

class StxElement = StatelessElement with StatelessObserverComponent;

// It's a experimental feature
class StxObserver extends StxStatelessWidget {
  final WidgetBuilder builder;

  const StxObserver({super.key, required this.builder});

  @override
  Widget build(BuildContext context) => builder(context);
}

/// A StatelessWidget than can listen reactive changes.
abstract class StxStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const StxStatelessWidget({super.key});
  @override
  StatelessElement createElement() => StxElement(this);
}

/// The [StxWidget] is the base for all Smart reactive widgets
///
/// See also:
/// - [Stx]
/// - [StxValue]
abstract class StxWidget extends StxStatelessWidget {
  const StxWidget({super.key});
}

/// The simplest reactive widget in Smart.
///
/// Just pass your Rx variable in the root scope of the callback to have it
/// automatically registered for changes.
///
/// final _name = "Smart".obs;
/// Stx(() => Text( _name.value )),... ;
class Stx extends StxWidget {
  final WidgetCallback builder;

  const Stx(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}