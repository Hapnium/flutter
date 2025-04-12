import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// A widget that displays a header with an optional footer and an underline.
///
/// This widget displays a header text followed by an optional footer text and
/// an underline. It provides options for customizing the appearance of the
/// header, footer, and underline.
class LineHeader extends StatelessWidget {
  /// The main header text to be displayed.
  final String header;

  /// The optional footer text to be displayed below the header.
  final String? footer;

  /// The font size of the header text. Defaults to `Sizing.font(20)`.
  final double? headerSize;

  /// The font size of the footer text. Defaults to `Sizing.font(14)`.
  final double? footerSize;

  /// The color of the text and the underline. Defaults to `Theme.of(context).primaryColor`.
  final Color? color;

  /// The border radius of the underline.
  /// Defaults to a rounded top right and bottom right corner.
  final BorderRadiusGeometry? borderRadius;

  /// A custom widget to be used as the underline instead of the default `Container`.
  final Widget? lineWidget;

  /// A widget that displays a header with an optional footer and an underline.
  ///
  /// This widget displays a header text followed by an optional footer text and
  /// an underline. It provides options for customizing the appearance of the
  /// header, footer, and underline.
  const LineHeader({
    super.key,
    required this.header,
    this.footer,
    this.headerSize,
    this.footerSize,
    this.color,
    this.borderRadius,
    this.lineWidget
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(header.isNotEmpty) ...[
          TextBuilder(
            text: header,
            size: headerSize ?? Sizing.font(20),
            weight: FontWeight.w700,
            color: color ?? Theme.of(context).primaryColor
          )
        ],
        if(footer.isNotNull && footer!.isNotEmpty) ...[
          TextBuilder(
            text: footer!,
            size: footerSize ?? Sizing.font(14),
            color: color ?? Theme.of(context).primaryColor
          )
        ],
        lineWidget ?? Container(
          width: MediaQuery.sizeOf(context).width,
          height: 3,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).primaryColor,
            borderRadius: borderRadius ?? const BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3)
            )
          ),
        )
      ],
    );
  }
}