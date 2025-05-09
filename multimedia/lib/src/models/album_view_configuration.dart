import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';

class AlbumViewConfiguration {
  /// Fixed width of grid item.
  final double? width;

  /// Aspect ratio of each grid item.
  final double? ratio;

  /// Optional custom widget builder for a media item.
  final MediumItemBuilder? mediumItemBuilder;

  /// Optional overlay widget to indicate selected state.
  final SelectedIndicator? selectedIndicator;

  /// Scrollbar thickness.
  final double? scrollThickness;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Widget to show between list items.
  final Widget? separator;

  /// Height of each list item.
  final double? itemHeight;

  /// Height of media image.
  final double? imageHeight;

  /// Width of media image.
  final double? imageWidth;

  /// BoxFit for media image.
  final BoxFit? imageFit;

  /// Icon for video media type.
  final IconData? videoIcon;

  /// Icon for image media type.
  final IconData? imageIcon;

  /// Icon for unknown/default media type.
  final IconData? defaultIcon;

  /// Rounded corners for media item.
  final BorderRadiusGeometry? itemBorderRadius;

  /// Shape for unselected media item.
  final ShapeBorder? unselectedShape;

  /// Shape for selected media item.
  final ShapeBorder? selectedShape;

  /// Spacing between list items.
  final double? itemSpacing;

  /// MainAxisSize for the item column.
  final MainAxisSize? itemMainAxisSize;

  /// MainAxisAlignment for the item column.
  final MainAxisAlignment? itemMainAxisAlignment;

  /// CrossAxisAlignment for the item column.
  final CrossAxisAlignment? itemCrossAxisAlignment;

  /// Fixed width for each item.
  final double? itemWidth;

  /// Background color of the item container.
  final Color? itemBackgroundColor;

  /// Padding inside the text column.
  final EdgeInsetsGeometry? textPadding;

  /// Spacing between text elements.
  final double? textSpacing;

  /// MainAxisSize for the text column.
  final MainAxisSize? textMainAxisSize;

  /// MainAxisAlignment for the text column.
  final MainAxisAlignment? textMainAxisAlignment;

  /// CrossAxisAlignment for the text column.
  final CrossAxisAlignment? textCrossAxisAlignment;

  /// Font size of the title.
  final double? titleSize;

  /// Font weight of the title.
  final FontWeight? titleWeight;

  /// Color of the title text.
  final Color? titleColor;

  /// Text overflow behavior of the title.
  final TextOverflow? titleFlow;

  /// Font size of the file size text.
  final double? fileSize;

  /// Color of the file size text.
  final Color? fileSizeColor;

  /// Spacing around the file size row.
  final double? fileSizeSpacing;

  /// MainAxisSize for the file size row.
  final MainAxisSize? fileSizeMainAxisSize;

  /// MainAxisAlignment for the file size row.
  final MainAxisAlignment? fileSizeMainAxisAlignment;

  /// CrossAxisAlignment for the file size row.
  final CrossAxisAlignment? fileSizeCrossAxisAlignment;

  /// Text overflow behavior of the file size.
  final TextOverflow? fileSizeFlow;

  /// Size of the media type icon.
  final double? iconSize;

  /// Color for unselected items.
  final Color? unselectedColor;

  /// Color for selected items.
  final Color? selectedColor;

  /// Vertical spacing between grid rows.
  final double? mainAxisSpacing;

  /// Horizontal spacing between grid items.
  final double? crossAxisSpacing;

  /// Whether to show the media type icon.
  final bool showIcon;

  AlbumViewConfiguration({
    this.width,
    this.ratio,
    this.mediumItemBuilder,
    this.selectedIndicator,
    this.scrollThickness,
    this.padding,
    this.separator,
    this.itemHeight,
    this.imageHeight,
    this.imageWidth,
    this.imageFit,
    this.videoIcon,
    this.imageIcon,
    this.defaultIcon,
    this.itemBorderRadius,
    this.unselectedShape,
    this.selectedShape,
    this.itemSpacing,
    this.itemMainAxisSize,
    this.itemMainAxisAlignment,
    this.itemCrossAxisAlignment,
    this.itemWidth,
    this.itemBackgroundColor,
    this.textPadding,
    this.textSpacing,
    this.textMainAxisSize,
    this.textMainAxisAlignment,
    this.textCrossAxisAlignment,
    this.titleSize,
    this.titleWeight,
    this.titleColor,
    this.titleFlow,
    this.fileSize,
    this.fileSizeColor,
    this.fileSizeSpacing,
    this.fileSizeMainAxisSize,
    this.fileSizeMainAxisAlignment,
    this.fileSizeCrossAxisAlignment,
    this.fileSizeFlow,
    this.iconSize,
    this.unselectedColor,
    this.selectedColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.showIcon = true,
  });
}