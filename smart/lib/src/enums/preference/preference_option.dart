/// Defines user notification preferences in the platform.
///
/// The [PreferenceOption] enum allows the system to determine how users prefer to receive notifications.
/// Each option represents a distinct notification delivery method.
///
/// Example Usage:
/// ```dart
/// PreferenceOption preference = PreferenceOption.inApp;
/// print(preference.type); // Output: "In-App"
/// ```
enum PreferenceOption {
  /// Represents the user's preference to receive notifications via phone (e.g., SMS or calls).
  phone("Phone"),

  /// Represents the user's preference to receive notifications within the application (in-app notifications).
  inApp("In-App"),

  /// Represents the user's preference to not receive any notifications.
  none("None"),

  /// Represents the user's preference to receive notifications through all available channels.
  all("All");

  /// Constructs a [PreferenceOption] with a descriptive [type] string.
  const PreferenceOption(this.type);

  /// The human-readable string representation of the preference option.
  final String type;
}