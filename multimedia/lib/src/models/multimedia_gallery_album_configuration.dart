import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart';

/// Configuration for customizing the [MultimediaGalleryAlbum] view.
class MultimediaGalleryAlbumConfiguration {
  /// If true, pops all previous routes when navigating back.
  final bool popAllWhileGoingBack;

  /// Custom album view configuration.
  final AlbumViewConfiguration? configuration;

  /// Custom icon configuration.
  final MultimediaIconConfiguration? iconConfiguration;

  /// Layout configuration for album screen.
  final MultimediaLayoutConfiguration? layoutConfiguration;

  /// Customization for the 'Done' button.
  final MultimediaDoneButtonConfiguration? doneButtonConfiguration;

  /// Configuration for filtering grid views.
  final MultimediaGridFilterConfiguration? gridFilterConfiguration;

  /// UI to show when no media is found.
  final MultimediaNoItemConfiguration? noItemConfiguration;

  /// Whether to display grid filters.
  final bool showFilters;

  /// Grid size labels (e.g., ['2x', '3x']).
  final List<String>? grids;

  /// Custom widget for the title.
  final Widget? titleWidget;

  /// Title text for the album.
  final String? title;

  /// Font size for the title.
  final double? titleSize;

  /// Font weight for the title.
  final FontWeight? titleWeight;

  /// Color for the title text.
  final Color? titleColor;

  /// Elevation of the app bar.
  final double? appBarElevation;

  /// Spacing between grid items.
  final double? gridViewSpacing;

  /// MainAxisAlignment of the grid view.
  final MainAxisAlignment? gridViewMainAlignment;

  /// MainAxisSize of the grid view.
  final MainAxisSize? gridViewMainAxisSize;

  /// CrossAxisAlignment of the grid view.
  final CrossAxisAlignment? gridViewCrossAlignment;

  /// Builder for loading state widget.
  final WidgetBuilder? loadingBuilder;

  /// Builder for empty state widget.
  final WidgetBuilder? emptyBuilder;

  /// Callback when the grid type is changed.
  final OnMultimediaGridChanged? onGridChanged;

  /// Callback when layout changes.
  final OnMultimediaLayoutChanged? onLayoutChanged;

  /// Color of the loading indicator.
  final Color? loadingColor;

  /// Creates a [MultimediaGalleryAlbumConfiguration] with optional customization.
  const MultimediaGalleryAlbumConfiguration({
    this.popAllWhileGoingBack = true,
    this.configuration,
    this.iconConfiguration,
    this.layoutConfiguration,
    this.doneButtonConfiguration,
    this.gridFilterConfiguration,
    this.noItemConfiguration,
    this.showFilters = false,
    this.grids,
    this.titleWidget,
    this.title,
    this.titleSize,
    this.titleWeight,
    this.titleColor,
    this.appBarElevation,
    this.gridViewSpacing,
    this.gridViewMainAlignment,
    this.gridViewMainAxisSize,
    this.gridViewCrossAlignment,
    this.loadingBuilder,
    this.emptyBuilder,
    this.onGridChanged,
    this.onLayoutChanged,
    this.loadingColor,
  });
}