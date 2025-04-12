part of 'pin.dart';

/// The mode which determines the Pin validation method
enum PinAutovalidateMode {
  /// No auto validation will occur.
  disabled,

  /// Used to auto-validate [Pin] only after [Pin.onCompleted] or [Pin.onSubmitted] is called
  onSubmit,
}

/// The method that is used to get the sms code on Android
enum PinAndroidSmsAutofillMethod {
  /// Disabled SMS autofill on Android
  none,

  /// Automatically reads sms without user interaction
  /// Requires SMS to contain The App signature, see readme for more details
  /// More about Sms Retriever API https://developers.google.com/identity/sms-retriever/overview?hl=en
  smsRetrieverApi,

  /// Requires user interaction to confirm reading a SMS, see readme for more details
  /// [AndroidSmsAutofillMethod.smsUserConsentApi]
  /// More about SMS User Consent API https://developers.google.com/identity/sms-retriever/user-consent/overview
  smsUserConsentApi,
}

/// The animation type if Pin item
enum PinAnimationType {
  /// No animation
  none,

  /// Scale animation
  scale,

  /// Fade animation
  fade,

  /// Slide animation
  slide,

  /// Rotation animation
  rotation,
}

/// The vibration type when user types
enum PinHapticFeedbackType {
  /// No vibration
  disabled,

  /// Provides a haptic feedback corresponding a collision impact with a light mass.
  ///
  /// On iOS versions 10 and above, this uses a `UIImpactFeedbackGenerator` with
  /// `UIImpactFeedbackStyleLight`. This call has no effects on iOS versions
  /// below 10.
  ///
  /// On Android, this uses `HapticFeedbackConstants.VIRTUAL_KEY`.
  lightImpact,

  /// Provides a haptic feedback corresponding a collision impact with a medium mass.
  ///
  /// On iOS versions 10 and above, this uses a `UIImpactFeedbackGenerator` with
  /// `UIImpactFeedbackStyleMedium`. This call has no effects on iOS versions
  /// below 10.
  ///
  /// On Android, this uses `HapticFeedbackConstants.KEYBOARD_TAP`.
  mediumImpact,

  /// Provides a haptic feedback corresponding a collision impact with a heavy mass.
  ///
  /// On iOS versions 10 and above, this uses a `UIImpactFeedbackGenerator` with
  /// `UIImpactFeedbackStyleHeavy`. This call has no effects on iOS versions
  /// below 10.
  ///
  /// On Android, this uses `HapticFeedbackConstants.CONTEXT_CLICK` on API levels
  /// 23 and above. This call has no effects on Android API levels below 23.
  heavyImpact,

  /// Provides a haptic feedback indication selection changing through discrete values.
  ///
  /// On iOS versions 10 and above, this uses a `UISelectionFeedbackGenerator`.
  /// This call has no effects on iOS versions below 10.
  ///
  /// On Android, this uses `HapticFeedbackConstants.CLOCK_TICK`.
  selectionClick,

  /// Provides vibration haptic feedback to the user for a short duration.
  ///
  /// On iOS devices that support haptic feedback, this uses the default system
  /// vibration value (`kSystemSoundID_Vibrate`).
  ///
  /// On Android, this uses the platform haptic feedback API to simulate a
  /// response to a long press (`HapticFeedbackConstants.LONG_PRESS`).
  vibrate,
}

/// An enum that represents the state of a pin item.
enum PinItemState {
  /// The default state of the pin item.
  initial,

  /// The state of the pin item when it is focused.
  focused,

  /// The state of the pin item when it is filled
  submitted,

  /// The state of the pin item when it is following.
  following,

  /// The state of the pin item when it is disabled.
  disabled,

  /// The state of the pin item when it has an error.
  error,
}