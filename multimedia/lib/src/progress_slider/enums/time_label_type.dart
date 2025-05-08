part of '../progress_slider.dart';

/// The time label on the right hand side can be shown as the [totalTime] or as
/// the [remainingTime]. If the choice is [remainingTime] then this will be
/// shown as a negative number.
///
///
enum TimeLabelType {
  /// The time label on the right shows the total time.
  ///
  /// | -------O---------------- |
  /// | 01:23              05:00 |
  totalTime,

  /// The time label on the right shows the remaining time as a
  /// negative number.
  ///
  /// | -------O---------------- |
  /// | 01:23             -03:37 |
  remainingTime,
}