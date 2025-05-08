import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// A customizable timeline widget that displays a title, optional description,
/// and a vertical line with an indicator. Commonly used to represent steps or
/// chronological events in a vertical or horizontal layout.
class Stepping extends StatefulWidget {
  /// The main title text displayed alongside the indicator.
  final String title;

  /// The optional width of the timeline widget.
  final double? width;

  /// An optional description displayed beneath or beside the title.
  final String description;

  /// Whether to show the line extending below the indicator.
  final bool showBottomLine;

  /// Whether to show the line extending above the indicator.
  final bool showTopLine;

  /// The height of the top line above the indicator.
  final double? topLineHeight;

  /// The thickness of the line connecting items.
  final double? lineWidth;

  /// Spacing between the line/indicator and the title/content.
  final double? lineSpacing;

  /// Spacing between each child widget in the main row.
  final double? spacing;

  /// Opacity of the entire timeline widget.
  final double? opacity;

  /// Padding applied to the title and/or content.
  final EdgeInsetsGeometry? titlePadding;

  /// Custom content to be displayed instead of the description.
  final Widget child;

  /// Color of the vertical/horizontal line and indicator.
  final Color? lineColor;

  /// Color of the title text.
  final Color? titleColor;

  /// Font size of the title text.
  final double? titleSize;

  /// Font weight of the title text.
  final FontWeight? titleWeight;

  /// Color of the description text.
  final Color? descriptionColor;

  /// Font size of the description text.
  final double? descriptionSize;

  /// Font weight of the description text.
  final FontWeight? descriptionWeight;

  /// Radius of the indicator shape (usually a circle or rounded rectangle).
  final BorderRadiusGeometry? indicatorRadius;

  /// Padding around the indicator shape.
  final EdgeInsetsGeometry? indicatorPadding;

  /// Whether the widget should start with the title before the line.
  final bool startWithTitle;

  /// The layout direction of the content, default is horizontal.
  final Axis? direction;

  /// Main axis alignment of the outermost row.
  final MainAxisAlignment? mainAxisAlignment;

  /// Main axis size of the outermost row.
  final MainAxisSize? mainAxisSize;

  /// Cross axis alignment of the outermost row.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Main axis alignment of the line/indicator column.
  final MainAxisAlignment? lineMainAxisAlignment;

  /// Main axis size of the line/indicator column.
  final MainAxisSize? lineMainAxisSize;

  /// Cross axis alignment of the line/indicator column.
  final CrossAxisAlignment? lineCrossAxisAlignment;

  /// Main axis alignment of the title/description content.
  final MainAxisAlignment? contentMainAxisAlignment;

  /// Main axis size of the title/description content.
  final MainAxisSize? contentMainAxisSize;

  /// Cross axis alignment of the title/description content.
  final CrossAxisAlignment? contentCrossAxisAlignment;

  /// Spacing between title and description widgets.
  final double? contentSpacing;

  /// Custom indicator widget to be displayed instead of the line.
  final Widget? indicator;

  /// Creates a customizable timeline widget for step-like or event-based layouts.
  const Stepping({
    super.key,
    this.showBottomLine = true,
    required this.title,
    this.child = const SizedBox(),
    this.lineColor,
    this.titleColor,
    this.titleSize,
    this.description = "",
    this.titleWeight,
    this.descriptionColor,
    this.descriptionSize,
    this.descriptionWeight,
    this.startWithTitle = false,
    this.showTopLine = true,
    this.topLineHeight,
    this.lineWidth,
    this.lineSpacing,
    this.spacing,
    this.opacity,
    this.titlePadding,
    this.indicatorRadius,
    this.indicatorPadding,
    this.direction,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.lineMainAxisAlignment,
    this.lineMainAxisSize,
    this.lineCrossAxisAlignment,
    this.contentMainAxisAlignment,
    this.contentMainAxisSize,
    this.contentCrossAxisAlignment,
    this.contentSpacing,
    this.width,
    this.indicator
  });

  @override
  State<Stepping> createState() => _SteppingState();
}

class _SteppingState extends State<Stepping> {
  final GlobalKey _key = GlobalKey();
  late double _height;

  @override
  void initState() {
    _height = 20;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_key.currentContext != null) {
        final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _height = renderBox.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = widget.titleColor ?? Theme.of(context).primaryColor;
    Color lineColor = widget.lineColor ?? Theme.of(context).primaryColor;
    Color descriptionColor = widget.descriptionColor ?? Theme.of(context).primaryColor;
    double lineWidth = widget.lineWidth ?? Sizing.space(1.5);
    Axis direction = widget.direction ?? Axis.horizontal;

    Widget text = TextBuilder(
      text: widget.title,
      color: titleColor,
      size: widget.titleSize ?? Sizing.font(12),
      flow: TextOverflow.clip,
      weight: widget.titleWeight ?? FontWeight.normal,
    );

    Widget description = TextBuilder(
      text: widget.description,
      color: descriptionColor,
      size: widget.descriptionSize ?? Sizing.font(14),
      flow: TextOverflow.clip,
      weight: widget.descriptionWeight ?? FontWeight.normal,
    );

    Widget indicator = widget.indicator ?? Container(
      padding: widget.indicatorPadding ?? EdgeInsets.all(Sizing.space(4)),
      decoration: BoxDecoration(
        color: lineColor,
        borderRadius: widget.indicatorRadius ?? BorderRadius.circular(1)
      ),
    );

    return SizedBox(
      key: _key,
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Opacity(
        opacity: widget.opacity ?? 1.0,
        child: Row(
          spacing: widget.spacing ?? 10,
          crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
          children: [
            if(widget.startWithTitle) ...[
              Padding(padding: widget.titlePadding ?? EdgeInsets.only(top: 11), child: text)
            ],
            Column(
              spacing: widget.lineSpacing ?? 0,
              crossAxisAlignment: widget.lineCrossAxisAlignment ?? CrossAxisAlignment.center,
              mainAxisAlignment: widget.lineMainAxisAlignment ?? MainAxisAlignment.center,
              mainAxisSize: widget.lineMainAxisSize ?? MainAxisSize.min,
              children: [
                if(widget.showTopLine) ...[
                  Container(height: widget.topLineHeight ?? 15, width: lineWidth, color: lineColor)
                ],
                indicator,
                if(widget.showBottomLine) ...[
                  Container(height: _height, width: lineWidth, color: lineColor)
                ],
              ],
            ),
            if(widget.startWithTitle) ...[
              if(widget.description.isNotEmpty) ...[
                Expanded(child: description)
              ] else ...[
                Expanded(child: widget.child)
              ]
            ] else ...[
              if(widget.description.isNotEmpty) ...[
                Expanded(
                  child: Padding(
                    padding: widget.titlePadding ?? EdgeInsets.all(Sizing.space(10)),
                    child: direction == Axis.vertical ? Column(
                      spacing: widget.contentSpacing ?? 0,
                      crossAxisAlignment: widget.contentCrossAxisAlignment ?? CrossAxisAlignment.start,
                      mainAxisAlignment: widget.contentMainAxisAlignment ?? MainAxisAlignment.start,
                      mainAxisSize: widget.contentMainAxisSize ?? MainAxisSize.min,
                      children: [text, description],
                    ) : Row(
                      spacing: widget.contentSpacing ?? 0,
                      crossAxisAlignment: widget.contentCrossAxisAlignment ?? CrossAxisAlignment.start,
                      mainAxisAlignment: widget.contentMainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                      mainAxisSize: widget.contentMainAxisSize ?? MainAxisSize.max,
                      children: [Expanded(child: text), description]
                    ),
                  ),
                )
              ] else ...[
                Expanded(
                  child: Padding(
                    padding: widget.titlePadding ?? EdgeInsets.all(Sizing.space(10)),
                    child: text,
                  ),
                )
              ]
            ]
          ],
        ),
      ),
    );
  }
}