import 'package:flutter/widgets.dart';
import 'sx.dart';

class SxObserver<T> extends StatefulWidget {
  final Sx<T> sx;
  final Widget Function(T value) builder;

  const SxObserver({super.key, required this.sx, required this.builder});

  @override
  _SxObserverState<T> createState() => _SxObserverState<T>();
}

class _SxObserverState<T> extends State<SxObserver<T>> {
  @override
  void initState() {
    super.initState();
    widget.sx.listen(_listener);
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.sx.unListen(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.sx.value);
  }
}