part of 'inactivity_layout.dart';

class _InactivityLayoutState extends State<InactivityLayout> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    _startInactivityTimer();

    super.initState();
  }

  /// Starts or resets the inactivity timer.
  void _startInactivityTimer({
    PointerDownEvent? down,
    PointerMoveEvent? move,
    PointerUpEvent? up,
    PointerHoverEvent? hover,
  }) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration ?? const Duration(minutes: 3), () {
      _showInactivityPopup(down: down, move: move, up: up, hover: hover);
    });
  }

  /// Resets the inactivity timer upon user interaction.
  void _resetTimer({
    PointerDownEvent? down,
    PointerMoveEvent? move,
    PointerUpEvent? up,
    PointerHoverEvent? hover,
  }) {
    if (mounted) {
      _startInactivityTimer(down: down, move: move, up: up, hover: hover);
    }
  }

  /// Triggers the inactivity callback when the timer expires.
  void _showInactivityPopup({
    PointerDownEvent? down,
    PointerMoveEvent? move,
    PointerUpEvent? up,
    PointerHoverEvent? hover,
  }) {
    if(mounted) {
      if (widget.onInactivity.isNotNull) {
        widget.onInactivity!(down, move, up, hover);
      }
    }
  }

  /// Handles user interactions, resetting the inactivity timer and triggering the [widget.onActivity] callback if provided.
  void _onUserInteraction({
    PointerDownEvent? down,
    PointerMoveEvent? move,
    PointerUpEvent? up,
    PointerHoverEvent? hover,
  }) {
    _resetTimer();

    if(mounted) {
      if (widget.onActivity.isNotNull) {
        widget.onActivity!(down, move, up, hover);
      }
    }
  }

  @override
  void didUpdateWidget(covariant InactivityLayout oldWidget) {
    if(oldWidget.inactivityDuration != widget.inactivityDuration) {
      _startInactivityTimer();
    }

    if(oldWidget.onInactivity != widget.onInactivity) {
      _startInactivityTimer();
    }

    if(oldWidget.onActivity != widget.onActivity) {
      _startInactivityTimer();
    }

    if(oldWidget.child != widget.child) {
      _startInactivityTimer();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) => _onUserInteraction(down: event),
      onPointerMove: (PointerMoveEvent event) => _onUserInteraction(move: event),
      onPointerUp: (PointerUpEvent event) => _onUserInteraction(up: event),
      onPointerHover: (PointerHoverEvent event) => _onUserInteraction(hover: event),
      child: widget.child,
    );
  }
}