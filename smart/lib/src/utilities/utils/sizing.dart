/// {@template sizing}
/// A utility class for calculating margins, paddings, and font sizes based on the screen width.
/// 
/// {@endtemplate}
class Sizing {
  Sizing._();
  
  /// Calculate margins and paddings  * width / 360.0
  static double _space(double base) => base;

  /// For Margin and Padding calculation (Responsiveness)
  static double space(double size) => _space(size);

  /// Calculate font sizes
  // static double _calculateFont(double baseFontSize) => baseFontSize * (360.0 / width);
  static double _font(double base) => base;

  /// For Font Size calculations (Responsiveness)
  static double font(double size) => _font(size);
}