import 'package:flutter/material.dart';

import '../../../../enums.dart';

/// A customizable loading widget that supports both circular and linear progress indicators.
class Loading extends StatelessWidget {
  /// The type of loading indicator. Defaults to `LoadingType.circular`.
  final LoadingType type;

  /// The color of the loading indicator.
  ///
  /// If null, defaults to the theme's primary color.
  final Color? color;

  /// The size of the circular loading indicator.
  ///
  /// Only applicable if `type` is `LoadingType.circular`. Defaults to `20.0`.
  final double size;

  /// The progress value for the indicator.
  ///
  /// If null, the progress indicator runs indefinitely.
  final double? value;

  /// The stroke cap for circular loading indicators.
  ///
  /// Determines the shape of the stroke ends.
  final StrokeCap? stroke;

  /// The width of the linear loading indicator.
  ///
  /// Defaults to the full screen width if null.
  final double? width;

  /// The height of the linear loading indicator.
  ///
  /// Defaults to `4.0` if null.
  final double? height;

  /// The background color of the loading indicator.
  ///
  /// Defaults to `Colors.transparent` for circular and `Theme.of(context).scaffoldBackgroundColor` for linear.
  final Color? backgroundColor;

  /// Creates a `Loading` widget.
  ///
  /// - [type]: Defines whether the loading indicator is circular or linear.
  /// - [color]: Sets the color of the loading indicator.
  /// - [size]: Defines the size of a circular loading indicator.
  /// - [value]: Specifies the current progress.
  /// - [stroke]: Defines the stroke cap of circular indicators.
  /// - [width]: Sets the width of a linear indicator.
  /// - [height]: Sets the height of a linear indicator.
  /// - [backgroundColor]: Sets the background color.
  const Loading({
    super.key,
    required this.type,
    this.color,
    this.size = 20,
    this.value,
    this.stroke,
    this.width,
    this.height,
    this.backgroundColor,
  });

  /// Creates a circular loading indicator.
  ///
  /// - `size`: Specifies the diameter of the circle.
  /// - `color`: The color of the loading indicator.
  /// - `value`: The progress value.
  /// - `stroke`: Defines the stroke cap.
  /// - `backgroundColor`: The background color of the indicator.
  const Loading.circular({
    super.key,
    this.color,
    this.size = 20,
    this.value,
    this.stroke,
    this.width,
    this.backgroundColor,
  }) : type = LoadingType.circular, height = null;

  /// Creates a vertical (linear) loading indicator.
  ///
  /// - `width`: The width of the progress bar.
  /// - `height`: The height of the progress bar.
  /// - `color`: The color of the progress bar.
  /// - `value`: The progress value.
  /// - `backgroundColor`: The background color of the progress bar.
  const Loading.vertical({
    super.key,
    this.width,
    this.height = 4.0,
    this.color,
    this.value,
    this.backgroundColor,
  }) : type = LoadingType.vertical, size = 0, stroke = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.circular:
        return SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            color: color ?? Theme.of(context).primaryColor,
            backgroundColor: backgroundColor ?? Colors.transparent,
            strokeWidth: width ?? 4.0,
            value: value,
            strokeCap: stroke,
          ),
        );
      case LoadingType.vertical:
        return SizedBox(
          width: width ?? MediaQuery.sizeOf(context).width,
          height: height ?? 4.0,
          child: LinearProgressIndicator(
            value: value,
            color: color ?? Theme.of(context).primaryColor,
            backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          ),
        );
    }
  }

  /// Displays a loading dialog with a customizable loading indicator.
  ///
  /// - [context]: The build context where the dialog should be displayed.
  /// - [type]: The type of loading indicator (`circular` or `vertical`).
  /// - [color]: The color of the loading indicator.
  /// - [size]: The size of the circular indicator.
  /// - [value]: The progress value of the loading indicator.
  /// - [stroke]: The stroke cap of the circular indicator.
  /// - [width]: The width of the linear indicator.
  /// - [height]: The height of the linear indicator.
  /// - [backgroundColor]: The background color of the loading indicator.
  static void show(BuildContext context, {
    LoadingType type = LoadingType.circular,
    Color? color,
    double size = 20,
    double? value,
    StrokeCap? stroke,
    double? width,
    double? height,
    Color? backgroundColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents user from dismissing dialog
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Center(
          child: Loading(
            type: type,
            color: color,
            size: size,
            value: value,
            stroke: stroke,
            width: width,
            height: height,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }
}