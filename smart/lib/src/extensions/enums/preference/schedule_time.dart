import '../../../enums/preference/schedule_time.dart';

/// Provides convenience methods for [ScheduleTime].
///
/// Example:
/// ```dart
/// if (schedule.isTenMinutes) {
///   print("Reminder set for 10 minutes.");
/// }
/// ```
extension ScheduleTimeExtension on ScheduleTime {
  /// Returns `true` if the schedule time is set to [ScheduleTime.thirtyMinutes].
  ///
  /// This indicates that the user has opted to receive schedule notification thirty minutes before, within the application.
  bool get isThirtyMinutes => this == ScheduleTime.thirtyMinutes;

  /// Returns `true` if the schedule time is set to [ScheduleTime.twentyMinutes].
  ///
  /// This indicates that the user has opted to receive schedule notification twenty minutes before, within the application.
  bool get isTwentyMinutes => this == ScheduleTime.twentyMinutes;

  /// Returns `true` if the schedule time is set to [ScheduleTime.tenMinutes].
  ///
  /// This indicates that the user has opted to receive schedule notification ten minutes before, within the application.
  bool get isTenMinutes => this == ScheduleTime.tenMinutes;
}