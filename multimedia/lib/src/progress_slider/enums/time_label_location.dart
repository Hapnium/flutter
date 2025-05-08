part of '../progress_slider.dart';

/// This is where the current time and total time labels should appear in
/// relation to the progress bar.
enum TimeLabelLocation {
  ///  The time is displayed above the progress bar.
  ///
  ///  | 01:23              05:00 |
  ///  | -------O---------------- |
  above,

  ///  The time is displayed below the progress bar.
  ///
  ///  | -------O---------------- |
  ///  | 01:23              05:00 |
  below,

  ///  The time is displayed on the sides of the progress bar.
  ///
  ///  | 01:23 -------O---------------- 05:00 |
  sides,

  ///  The time is not displayed.
  ///
  ///  | -------O---------------- |
  none,
}