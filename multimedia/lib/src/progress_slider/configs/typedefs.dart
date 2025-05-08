part of '../progress_slider.dart';

/// The callback signature for when the thumb begins a horizontal drag.
typedef ThumbDragStartCallback = void Function(ThumbDragDetails details);

/// The callback signature for when the thumb is moving on horizontally and has
/// new data.
typedef ThumbDragUpdateCallback = void Function(ThumbDragDetails details);