/// Represents different screen size categories.
///
/// This enum is used to differentiate between various device types 
/// based on their screen sizes, helping in responsive UI design.
enum ScreenSize {
  /// Represents a mobile screen size.
  ///
  /// Typically used for devices with smaller screens, such as smartphones.
  mobile,

  /// Represents a tablet screen size.
  ///
  /// Used for medium-sized screens, such as tablets, that offer more 
  /// space than mobile devices but are smaller than desktops.
  tablet,

  /// Represents a desktop screen size.
  ///
  /// Used for larger screens, such as laptops and desktop monitors, 
  /// which provide more space for UI elements.
  desktop,
}