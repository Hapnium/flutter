import 'package:flutter/material.dart';

/// {@template dashed_divider}
/// A widget that draws a horizontal dashed line divider.
/// 
/// This widget is useful for creating separation lines between sections of your UI
/// with a dashed line style. It provides options to customize the height and color
/// of the dashed line.
/// 
/// {@endtemplate}
class DashedDivider extends StatelessWidget {
  /// The height of the dashed line. Defaults to 1.
  final double dashHeight;

  /// The color of the dashed line. Defaults to Colors.black.
  final Color color;

  /// The dash line width size
  final double dashWidth;

  /// A widget that draws a horizontal dashed line divider.

  /// This widget is useful for creating separation lines between sections of your UI
  /// with a dashed line style. It provides options to customize the height and color
  /// of the dashed line.
  /// 
  /// {@macro dashed_divider}
  const DashedDivider({super.key, this.dashHeight = 1, this.color = Colors.black, this.dashWidth = 10});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}