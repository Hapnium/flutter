import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart' show AlbumItemBuilder, MultimediaGalleryAlbumConfiguration;

class GalleryViewConfiguration {
  /// Optional limit on how many media items can be selected.
  final int? maxSelection;

  /// How many albums should be displayed in a row.
  final int? displayCount;

  /// The aspect ratio of the grid items.
  final double? ratio;

  /// The width of the grid items.
  final double? width;

  /// The padding of the grid items.
  final EdgeInsetsGeometry? padding;

  /// The thickness of the scrollbar.
  final double? scrollThickness;

  /// The spacing between grid items.
  final double? mainAxisSpacing;

  /// The spacing between grid items.
  final double? crossAxisSpacing;

  /// The border radius of the grid items.
  final BorderRadiusGeometry? borderRadius;

  /// How the image should be inscribed into the space.
  final BoxFit? imageFit;

  /// The background color of the image.
  final Color? imageBackgroundColor;

  /// The padding of the content.
  final EdgeInsetsGeometry? contentPadding;

  /// The spacing between the content.
  final double? contentSpacing;

  /// The main axis alignment of the content.
  final MainAxisAlignment? contentMainAxisAlignment;

  /// The cross axis alignment of the content.
  final CrossAxisAlignment? contentCrossAxisAlignment;

  /// The size of the album name.
  final double? nameSize;

  /// The weight of the album name.
  final FontWeight? nameWeight;

  /// The color of the album name.
  final Color? nameColor;

  /// The overflow of the album name.
  final TextOverflow? nameOverflow;

  /// The size of the album count.
  final double? countSize;

  /// The color of the album count.
  final Color? countColor;

  /// The overflow of the album count.
  final TextOverflow? countOverflow;

  /// The color of the newest album.
  final Color? newestColor;

  /// The color of the oldest album.
  final Color? oldestColor;

  /// The color of the album info.
  final Color? infoColor;

  /// The size of the album info.
  final double? infoSize;

  /// The padding of the album info.
  final EdgeInsetsGeometry? infoPadding;

  /// The border radius of the album info.
  final BorderRadiusGeometry? infoRadius;

  /// A custom widget builder for each album.
  final AlbumItemBuilder? albumItemBuilder;

  /// The route to navigate to when a album is tapped.
  final String? route;

  /// Widget shown between list items.
  final Widget? separator;

  /// Controls the size of the album thumbnail.
  final double? imageHeight;

  /// Controls the size of the album thumbnail.
  final double? imageWidth;

  /// The album configuration
  final MultimediaGalleryAlbumConfiguration albumConfiguration;

  const GalleryViewConfiguration({
    this.maxSelection,
    this.scrollThickness,
    this.padding,
    this.separator,
    this.imageHeight,
    this.imageWidth,
    this.imageFit,
    this.borderRadius,
    this.albumItemBuilder,
    this.route,
    this.contentSpacing,
    this.contentMainAxisAlignment,
    this.contentCrossAxisAlignment,
    this.nameSize,
    this.nameWeight,
    this.nameColor,
    this.nameOverflow,
    this.countSize,
    this.countColor,
    this.countOverflow,
    this.newestColor,
    this.oldestColor,
    this.infoColor,
    this.infoSize,
    this.infoPadding,
    this.infoRadius,
    this.displayCount,
    this.ratio,
    this.width,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.contentPadding,
    this.imageBackgroundColor,
    this.albumConfiguration = const MultimediaGalleryAlbumConfiguration(),
  });
}