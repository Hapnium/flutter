/// This enum represents the different types of themes available in the system.
///
///The ThemeType enum represents the two possible themes for an application: light and dark. It has two fields:
///
/// light: represents the light theme.
///
/// dark: represents the dark theme.
///
/// Each field has a string value associated with it that describes the type of the theme.
/// The type field is a constant string that cannot be changed and is set during initialization using the constructor.
enum ThemeType{
  /// Represents the light theme.
  light("Light"),

  /// Represents the dark theme.
  dark("Dark");

  /// The type of the theme as a string.
  final String type;

  /// Constructor for the ThemeType enum.
  const ThemeType(this.type);
}