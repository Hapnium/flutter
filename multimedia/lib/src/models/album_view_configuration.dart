import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';

/// {@template album_view_configuration}
/// Configuration for customizing the layout and appearance of a media album view,
/// supporting both grid and list-based layouts.
///
/// This class enables precise control over how media items are rendered, including
/// their dimensions, visual styling, icon usage, selection indicators, and layout 
/// alignment. It is intended for use within album or gallery UIs that display media files.
///
/// ### Example:
/// ```dart
/// final config = AlbumViewConfiguration(
///   width: 120,
///   ratio: 1.0,
///   imageFit: BoxFit.cover,
///   itemSpacing: 8.0,
///   mainAxisSpacing: 10.0,
///   crossAxisSpacing: 10.0,
///   showIcon: true,
///   titleSize: 14,
///   titleColor: Colors.black,
/// );
/// ```
/// {@endtemplate}
class AlbumViewConfiguration {
  /// Fixed width of a grid or list item.
  ///
  /// Defaults to null.
  final double? width;

  /// Aspect ratio of each media item (width / height).
  ///
  /// Defaults to null.
  final double? ratio;

  /// Optional custom widget builder for each media item.
  ///
  /// Useful for fully custom item layouts. Defaults to null.
  final MediumItemBuilder? mediumItemBuilder;

  /// Widget overlay for visually indicating selection (e.g., checkmark or highlight).
  ///
  /// Defaults to null.
  final SelectedIndicator? selectedIndicator;

  /// Thickness of the scrollbar.
  ///
  /// If null, default system thickness is used.
  final double? scrollThickness;

  /// Padding around the entire list or grid.
  ///
  /// Defaults to null.
  final EdgeInsetsGeometry? padding;

  /// Optional separator widget between list items (used in list layout).
  ///
  /// Defaults to null.
  final Widget? separator;

  /// Fixed height of a list item (applies to vertical list layout).
  ///
  /// Defaults to null.
  final double? itemHeight;

  /// Height of the image or media thumbnail inside the item.
  ///
  /// Defaults to null.
  final double? imageHeight;

  /// Width of the image or media thumbnail inside the item.
  ///
  /// Defaults to null.
  final double? imageWidth;

  /// BoxFit configuration for media thumbnail (e.g., cover, contain).
  ///
  /// Defaults to null.
  final BoxFit? imageFit;

  /// Icon to show for video files.
  ///
  /// Defaults to null.
  final IconData? videoIcon;

  /// Icon to show for image files.
  ///
  /// Defaults to null.
  final IconData? imageIcon;

  /// Icon to show for unknown or unsupported media types.
  ///
  /// Defaults to null.
  final IconData? defaultIcon;

  /// Border radius for rounding corners of media items.
  ///
  /// Defaults to null.
  final BorderRadiusGeometry? itemBorderRadius;

  /// Shape of an unselected item (e.g., rectangle, circle).
  ///
  /// Defaults to null.
  final ShapeBorder? unselectedShape;

  /// Shape of a selected item, allowing visual distinction.
  ///
  /// Defaults to null.
  final ShapeBorder? selectedShape;

  /// Spacing between adjacent media items.
  ///
  /// Defaults to null.
  final double? itemSpacing;

  /// Main axis size for the internal layout (column) of each item.
  ///
  /// Defaults to null.
  final MainAxisSize? itemMainAxisSize;

  /// Main axis alignment for the item’s internal layout.
  ///
  /// Defaults to null.
  final MainAxisAlignment? itemMainAxisAlignment;

  /// Cross axis alignment for the item’s internal layout.
  ///
  /// Defaults to null.
  final CrossAxisAlignment? itemCrossAxisAlignment;

  /// Fixed width for an individual item (especially for horizontal lists).
  ///
  /// Defaults to null.
  final double? itemWidth;

  /// Background color for each media item container.
  ///
  /// Defaults to null.
  final Color? itemBackgroundColor;

  /// Padding around the text section inside each media item.
  ///
  /// Defaults to null.
  final EdgeInsetsGeometry? textPadding;

  /// Spacing between title, file size, and other text elements.
  ///
  /// Defaults to null.
  final double? textSpacing;

  /// Main axis size for the text column.
  ///
  /// Defaults to null.
  final MainAxisSize? textMainAxisSize;

  /// Main axis alignment for the text column.
  ///
  /// Defaults to null.
  final MainAxisAlignment? textMainAxisAlignment;

  /// Cross axis alignment for the text column.
  ///
  /// Defaults to null.
  final CrossAxisAlignment? textCrossAxisAlignment;

  /// Font size for the title (usually the file name).
  ///
  /// Defaults to null.
  final double? titleSize;

  /// Font weight for the title text.
  ///
  /// Defaults to null.
  final FontWeight? titleWeight;

  /// Color of the title text.
  ///
  /// Defaults to null.
  final Color? titleColor;

  /// Overflow behavior for the title (e.g., ellipsis).
  ///
  /// Defaults to null.
  final TextOverflow? titleFlow;

  /// Font size for the file size text.
  ///
  /// Defaults to null.
  final double? fileSize;

  /// Color of the file size text.
  ///
  /// Defaults to null.
  final Color? fileSizeColor;

  /// Spacing between the file size and other elements.
  ///
  /// Defaults to null.
  final double? fileSizeSpacing;

  /// Main axis size for the file size row.
  ///
  /// Defaults to null.
  final MainAxisSize? fileSizeMainAxisSize;

  /// Main axis alignment for the file size row.
  ///
  /// Defaults to null.
  final MainAxisAlignment? fileSizeMainAxisAlignment;

  /// Cross axis alignment for the file size row.
  ///
  /// Defaults to null.
  final CrossAxisAlignment? fileSizeCrossAxisAlignment;

  /// Overflow behavior for the file size text.
  ///
  /// Defaults to null.
  final TextOverflow? fileSizeFlow;

  /// Size of the icon representing the media type (image/video).
  ///
  /// Defaults to null.
  final double? iconSize;

  /// Tint color for unselected items.
  ///
  /// Defaults to null.
  final Color? unselectedColor;

  /// Tint color for selected items.
  ///
  /// Defaults to null.
  final Color? selectedColor;

  /// Vertical spacing between rows in a grid layout.
  ///
  /// Defaults to null.
  final double? mainAxisSpacing;

  /// Horizontal spacing between items in a row.
  ///
  /// Defaults to null.
  final double? crossAxisSpacing;

  /// Whether to display the media type icon on each item.
  ///
  /// Defaults to true.
  final bool showIcon;

  /// {@macro album_view_configuration}
  const AlbumViewConfiguration({
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