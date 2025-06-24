import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart' show AlbumItemBuilder, MultimediaGalleryAlbumConfiguration;

/// {@template gallery_view_configuration}
/// Configuration class for customizing the layout, appearance, and behavior of a media gallery view.
///
/// This class is intended for defining how album collections (e.g., folders or groupings of media)
/// are presented in a grid-style interface. It supports customization of image dimensions,
/// padding, typography, spacing, scroll behavior, and routing when an album is selected.
///
/// ### Example:
/// ```dart
/// final config = GalleryViewConfiguration(
///   displayCount: 3,
///   ratio: 1.0,
///   imageFit: BoxFit.cover,
///   nameSize: 16,
///   nameWeight: FontWeight.bold,
///   countSize: 12,
///   contentSpacing: 6,
///   route: '/albumDetails',
/// );
/// ```
/// {@endtemplate}
class GalleryViewConfiguration {
  /// Optional limit on the total number of media items that can be selected across albums.
  ///
  /// Defaults to null (unlimited).
  final int? maxSelection;

  /// Number of album items shown per row in the grid.
  ///
  /// Defaults to null.
  final int? displayCount;

  /// Aspect ratio for each album item (width / height).
  ///
  /// Defaults to null.
  final double? ratio;

  /// Fixed width of each album item.
  ///
  /// Defaults to null.
  final double? width;

  /// Padding applied around each grid item.
  ///
  /// Defaults to null.
  final EdgeInsetsGeometry? padding;

  /// Thickness of the scrollbar, if shown.
  ///
  /// Defaults to null (uses system default).
  final double? scrollThickness;

  /// Vertical spacing between rows of albums in the grid.
  ///
  /// Defaults to null.
  final double? mainAxisSpacing;

  /// Horizontal spacing between albums in the same row.
  ///
  /// Defaults to null.
  final double? crossAxisSpacing;

  /// Radius for rounding the corners of the album thumbnail.
  ///
  /// Defaults to null.
  final BorderRadiusGeometry? borderRadius;

  /// Defines how the album image fits inside its container.
  ///
  /// Defaults to null.
  final BoxFit? imageFit;

  /// Background color rendered behind the album image.
  ///
  /// Defaults to null.
  final Color? imageBackgroundColor;

  /// Padding applied around the internal content of each album item.
  ///
  /// Defaults to null.
  final EdgeInsetsGeometry? contentPadding;

  /// Spacing between the album image and its textual content (e.g., name, count).
  ///
  /// Defaults to null.
  final double? contentSpacing;

  /// Main axis alignment for the column layout of album content.
  ///
  /// Defaults to null.
  final MainAxisAlignment? contentMainAxisAlignment;

  /// Cross axis alignment for the column layout of album content.
  ///
  /// Defaults to null.
  final CrossAxisAlignment? contentCrossAxisAlignment;

  /// Font size used for the album name.
  ///
  /// Defaults to null.
  final double? nameSize;

  /// Font weight for the album name text.
  ///
  /// Defaults to null.
  final FontWeight? nameWeight;

  /// Color of the album name text.
  ///
  /// Defaults to null.
  final Color? nameColor;

  /// Overflow behavior for the album name text (e.g., ellipsis).
  ///
  /// Defaults to null.
  final TextOverflow? nameOverflow;

  /// Font size used for displaying the number of media items in the album.
  ///
  /// Defaults to null.
  final double? countSize;

  /// Color used for the media count text.
  ///
  /// Defaults to null.
  final Color? countColor;

  /// Overflow behavior for the album count text.
  ///
  /// Defaults to null.
  final TextOverflow? countOverflow;

  /// Highlight color applied to the newest album, if such logic is implemented.
  ///
  /// Defaults to null.
  final Color? newestColor;

  /// Highlight color applied to the oldest album.
  ///
  /// Defaults to null.
  final Color? oldestColor;

  /// Color used for extra metadata or info text in the album card.
  ///
  /// Defaults to null.
  final Color? infoColor;

  /// Font size for album metadata/info text.
  ///
  /// Defaults to null.
  final double? infoSize;

  /// Padding around the album info section.
  ///
  /// Defaults to null.
  final EdgeInsetsGeometry? infoPadding;

  /// Border radius applied to the album info section container.
  ///
  /// Defaults to null.
  final BorderRadiusGeometry? infoRadius;

  /// Custom widget builder for rendering an album item.
  ///
  /// Use this to override the default layout and visuals.
  /// Defaults to null.
  final AlbumItemBuilder? albumItemBuilder;

  /// Named route to navigate to when an album is tapped.
  ///
  /// Defaults to null (no navigation).
  final String? route;

  /// Widget displayed between album items (e.g., a `Divider`, `SizedBox`).
  ///
  /// Only used in list or custom layouts.
  final Widget? separator;

  /// Height of the album image/thumbnail.
  ///
  /// Defaults to null.
  final double? imageHeight;

  /// Width of the album image/thumbnail.
  ///
  /// Defaults to null.
  final double? imageWidth;

  /// Album-level configuration used inside the gallery view.
  ///
  /// Defaults to a const [MultimediaGalleryAlbumConfiguration] instance.
  final MultimediaGalleryAlbumConfiguration albumConfiguration;

  /// {@macro gallery_view_configuration}
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