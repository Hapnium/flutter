part of '../pin.dart';

class _PinItem extends StatelessWidget {
  final _PinState state;
  final int index;

  const _PinItem({
    required this.state,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final itemConfig = _pinItemConfig(index);

    return Flexible(
      child: AnimatedContainer(
        height: itemConfig.height,
        width: itemConfig.width,
        constraints: itemConfig.constraints,
        padding: itemConfig.padding,
        margin: itemConfig.margin,
        decoration: itemConfig.decoration,
        alignment: state.widget.pinContentAlignment,
        duration: state.widget.animationDuration,
        curve: state.widget.animationCurve,
        child: AnimatedSwitcher(
          switchInCurve: state.widget.animationCurve,
          switchOutCurve: state.widget.animationCurve,
          duration: state.widget.animationDuration,
          transitionBuilder: _getTransition,
          child: _buildFieldContent(index, itemConfig),
        ),
      ),
    );
  }

  PinItemConfig _pinItemConfig(int index) {
    final pintState = state._getState(index);
    switch (pintState) {
      case PinItemState.initial:
        return _getDefaultPinConfig();
      case PinItemState.focused:
        return _pinConfigOrDefault(state.widget.focusedPinConfig);
      case PinItemState.submitted:
        return _pinConfigOrDefault(state.widget.submittedPinConfig);
      case PinItemState.following:
        return _pinConfigOrDefault(state.widget.followingPinConfig);
      case PinItemState.disabled:
        return _pinConfigOrDefault(state.widget.disabledPinConfig);
      case PinItemState.error:
        return _pinConfigOrDefault(state.widget.errorPinConfig);
    }
  }

  PinItemConfig _getDefaultPinConfig() => state.widget.defaultPinConfig ?? PinConstants._defaultPinConfig;

  PinItemConfig _pinConfigOrDefault(PinItemConfig? Config) => Config ?? _getDefaultPinConfig();

  Widget _buildFieldContent(int index, PinItemConfig itemConfig) {
    final pin = state.pin;
    final key = ValueKey<String>(index.isLt(pin.length) ? pin[index] : '');
    final isSubmittedPin = index.isLt(pin.length);

    if (isSubmittedPin) {
      if (state.widget.obscureText && state.widget.obscuringWidget.isNotNull) {
        return SizedBox(key: key, child: state.widget.obscuringWidget);
      }

      return Text(
        state.widget.obscureText ? state.widget.obscuringCharacter : pin[index],
        key: key,
        style: itemConfig.textStyle,
      );
    }

    final isActiveField = index.equals(pin.length);
    final focused = state.effectiveFocusNode.hasFocus || !state.widget.useNativeKeyboard;
    final shouldShowCursor = state.widget.showCursor && state.isEnabled && isActiveField && focused;

    if (shouldShowCursor) {
      return _buildCursor(itemConfig);
    }

    if (state.widget.preFilledWidget.isNotNull) {
      return SizedBox(key: key, child: state.widget.preFilledWidget);
    }

    return Text('', key: key, style: itemConfig.textStyle);
  }

  Widget _buildCursor(PinItemConfig itemConfig) {
    if (state.widget.isCursorAnimationEnabled) {
      return _PinAnimatedCursor(
        textStyle: itemConfig.textStyle,
        cursor: state.widget.cursor,
      );
    }

    return _PinCursor(
      textStyle: itemConfig.textStyle,
      cursor: state.widget.cursor,
    );
  }

  Widget _getTransition(Widget child, Animation<double> animation) {
    if (child is _PinAnimatedCursor) {
      return child;
    }

    switch (state.widget.pinAnimationType) {
      case PinAnimationType.none:
        return child;
      case PinAnimationType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case PinAnimationType.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case PinAnimationType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: state.widget.slideTransitionBeginOffset ?? const Offset(0.8, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case PinAnimationType.rotation:
        return RotationTransition(
          turns: animation,
          child: child,
        );
    }
  }
}