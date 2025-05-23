part of '../pin.dart';

/// Signature for a function that creates a widget for a given index, e.g., in a
/// list.
typedef JustIndexedWidgetBuilder = Widget Function(int index);

class _PinFormField extends FormField<String> {
  const _PinFormField({
    required final FormFieldValidator<String>? validator,
    required final bool enabled,
    required final String? initialValue,
    required final Widget Function(FormFieldState<String> field) builder,
    Key? key,
  }) : super(
    key: key,
    enabled: enabled,
    validator: validator,
    autovalidateMode: AutovalidateMode.disabled,
    initialValue: initialValue,
    builder: builder,
  );
}

class _SeparatedRaw extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final JustIndexedWidgetBuilder? separatorBuilder;

  const _SeparatedRaw({
    required this.children,
    required this.mainAxisAlignment,
    this.separatorBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemCount = max(0, children.length * 2 - 1);
    final indexedList = [for (int i = 0; i < itemCount; i += 1) i];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisAlignment == MainAxisAlignment.center ? MainAxisSize.min : MainAxisSize.max,
      children: indexedList.map((index) {
        final itemIndex = index ~/ 2;
        return index.isEven ? children[itemIndex] : _separator(itemIndex);
      }).toList(growable: false),
    );
  }

  Widget _separator(int index) => separatorBuilder?.call(index) ?? PinConstants._defaultSeparator;
}

class _PinCursor extends StatelessWidget {
  final Widget? cursor;
  final TextStyle? textStyle;

  const _PinCursor({required this.textStyle, required this.cursor});

  @override
  Widget build(BuildContext context) => cursor ?? Text('|', style: textStyle);
}

class _PinAnimatedCursor extends StatefulWidget {
  final Widget? cursor;
  final TextStyle? textStyle;

  const _PinAnimatedCursor({
    required this.textStyle,
    required this.cursor,
  });

  @override
  State<_PinAnimatedCursor> createState() => _PinAnimatedCursorState();
}

class _PinAnimatedCursorState extends State<_PinAnimatedCursor> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startCursorAnimation();
  }

  void _startCursorAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat(reverse: true);
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: _PinCursor(textStyle: widget.textStyle, cursor: widget.cursor),
    );
  }
}