/// Represents gender options a user can select.
///
/// Includes male, female, and gender-neutral options.
enum Gender {
  /// Male gender selection.
  male("MALE", "Male"),

  /// Female gender selection.
  female("FEMALE", "Female"),

  /// Neutral gender option, meaning the user prefers not to specify.
  any("ANY", "Prefer not to say"),

  /// No gender restrictions apply.
  none("NONE", "All");

  /// A backend identifier for the gender.
  final String key;

  /// A human-readable label for the gender.
  final String value;

  /// Creates a [Gender] with both a backend key and display value.
  const Gender(this.key, this.value);
}