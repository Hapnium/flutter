/// Represents the available font families used within the application.
///
/// This enum defines the different font families that can be used for
/// displaying text throughout the application. Each enum value corresponds
/// to a specific font family name.
///
/// **Note:**
/// - This enum can be extended with additional font families as needed.
/// - Consider using a more robust font management solution
///   (e.g., a dedicated font provider) for larger projects.
enum FontFamily {
  /// The "League Spartan" font family.
  leagueSpartan("League Spartan"),

  /// The "Nunito" font family.
  nunito("Nunito"),

  /// The "Glow" font family.
  glow("Glow");

  /// The human-readable name of the font family.
  final String type;

  const FontFamily(this.type);
}