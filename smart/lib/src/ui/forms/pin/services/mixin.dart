part of '../pin.dart';

mixin PinMixin {
  void _maybeUseHaptic(PinHapticFeedbackType hapticFeedbackType) {
    switch (hapticFeedbackType) {
      case PinHapticFeedbackType.disabled:
        break;
      case PinHapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case PinHapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case PinHapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case PinHapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
      case PinHapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  Future<String> _getClipboardOrEmpty() async {
    final ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    return clipboardData?.text ?? '';
  }
}