import 'package:flutter/widgets.dart';
import 'package:smart/smart.dart';

/// A utility class for managing responsive breakpoints and screen properties.
///
/// This class provides a convenient way to determine whether the current screen size
/// is categorized as mobile, tablet, or desktop based on predefined breakpoints.
/// Additionally, it provides access to other screen-related properties such as width,
/// height, padding, and text scaling factor.
class ResponsiveUtil {
  late Size _size;
  ResponsiveConfig _config = ResponsiveConfig();

  /// Private constructor to prevent direct instantiation.
  ResponsiveUtil._();

  /// Initializes the breakpoints with the given [BuildContext].
  ///
  /// This method must be called before accessing any properties of the class.
  /// Returns an instance of `ResponsiveUtil` for convenient usage.
  ///
  /// Example:
  /// ```dart
  /// final responsive = ResponsiveUtil(context);
  /// if (responsive.isMobile) {
  ///   print('This is a mobile screen.');
  /// }
  /// ```
  factory ResponsiveUtil(BuildContext context, {ResponsiveConfig? config}) {
    final instance = ResponsiveUtil._();
    instance._size = MediaQuery.sizeOf(context);

    if(config.isNotNull) {
      instance._config = config!;
    }

    return instance;
  }

  /// Returns `true` if the screen width is less than the mobile breakpoint.
  bool get isMobile => _size.width < _config.mobile;

  /// Returns `true` if the screen width is between the mobile breakpoint and tablet breakpoint.
  bool get isTablet => _size.width >= _config.mobile && _size.width < _config.tablet;

  /// Returns `true` if the screen width is greater than or equal to the tablet breakpoint.
  bool get isDesktop => _size.width >= _config.tablet;

  /// The current screen width.
  double get screenWidth => _size.width;

  /// The current screen height.
  double get screenHeight => _size.height;
}