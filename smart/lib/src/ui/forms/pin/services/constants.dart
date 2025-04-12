part of '../pin.dart';

/// The constant values for Pin
class PinConstants {
  const PinConstants._();

  /// The default value [Pin.smsCodeMatcher]
  static const defaultSmsCodeMatcher = '\\d{4,7}';

  /// The default value [Pin.animationDuration]
  static const _animationDuration = Duration(milliseconds: 180);

  /// The default value [Pin.length]
  static const _defaultLength = 4;

  static const _defaultSeparator = SizedBox(width: 8);

  /// The hidden text under the Pin
  static const _hiddenTextStyle = TextStyle(fontSize: 1, height: 1, color: Colors.transparent);

  ///
  static const _defaultPinFillColor = Color.fromRGBO(222, 231, 240, .57);
  static const _defaultPinDecoration = BoxDecoration(
    color: _defaultPinFillColor,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  /// The default value [Pin.defaultPinItemConfig]
  static const _defaultPinConfig = PinItemConfig(
    width: 56,
    height: 60,
    textStyle: TextStyle(),
    decoration: _defaultPinDecoration,
  );
}

/// Error widget builder of Pinput
typedef PinErrorBuilder = Widget Function(String? errorText, String pin);

/// A widget builder that represents a single pin field.
typedef PinItemWidgetBuilder = Widget Function(BuildContext context, PinItem item);

class _PinItemBuilder {
  const _PinItemBuilder({
    required this.itemBuilder,
  });

  final PinItemWidgetBuilder itemBuilder;
}