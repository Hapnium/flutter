/// Configuration class for responsive breakpoints in your application.
///
/// This class provides properties for defining breakpoints for different screen sizes,
/// allowing for adaptive layouts that adjust based on the user's device.
class ResponsiveConfig {
  /// The breakpoint for mobile devices (optional).
  final double mobile;

  /// The breakpoint for tablet devices (optional).
  final double tablet;

  /// The breakpoint for desktop devices (optional).
  final double desktop;

  /// Creates a new instance of [ResponsiveConfig].
  ///
  /// You can specify breakpoints for different screen sizes using the
  /// corresponding properties.
  const ResponsiveConfig({this.mobile = 600, this.tablet = 1024, this.desktop = 2046});
}