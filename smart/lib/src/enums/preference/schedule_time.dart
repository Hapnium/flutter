/// This enum represents the different types of schedule time for a user's schedule in the system.
///
///This is an enum class called ScheduleTime which defines three different types of schedule times. The three types are thirtyMinutes, twentyMinutes, and tenMinutes.
///
/// Each type has a String value that represents the time in Minutes, and it is stored in the type field.
///
/// The const constructor is used to create a new instance of the enum class and it takes in a String parameter which is used to set the type field.
enum ScheduleTime{
  /// Represents a schedule time of 30 Minutes.
  thirtyMinutes("30 min"),

  /// Represents a schedule time of 20 Minutes.
  twentyMinutes("20 min"),

  /// Represents a schedule time of 10 Minutes.
  tenMinutes("10 min");

  /// The type of the schedule time as a string.
  final String type;

  /// Constructor for the ScheduleTime enum.
  const ScheduleTime(this.type);
}