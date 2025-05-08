part of '../progress_slider.dart';

/// Data to pass back on drag callback events
class ThumbDragDetails {
  const ThumbDragDetails({
    this.timeStamp = Duration.zero,
    this.globalPosition = Offset.zero,
    this.localPosition = Offset.zero,
  });

  /// The duration position of the thumb on the progress bar
  final Duration timeStamp;

  /// The global position of the drag event moving the thumb on the progress bar.
  final Offset globalPosition;

  /// The local position of the drag event moving the thumb on the progress bar.
  final Offset localPosition;

  @override
  String toString() => '${objectRuntimeType(this, 'ThumbDragDetails')}('
      'time: $timeStamp, '
      'global: $globalPosition, '
      'local: $localPosition)';
}