import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart';

/// {@template multimedia_gallery_album_configuration}
/// Configuration for customizing the [MultimediaGalleryAlbum] view.
///
/// This class controls the layout, appearance, and behavior of the album
/// view in a multimedia gallery interface. It allows developers to configure:
/// - Filter behavior (e.g., All, Photos, Videos)
/// - Grid layout and title appearance
/// - Icon and button customization
/// - Loading, empty, and grid-changing behavior
///
/// This is useful when building a flexible, theme-able gallery browsing experience
/// that can adapt to different use cases or platform requirements.
///
/// ### Example
/// ```dart
/// MultimediaGalleryAlbumConfiguration(
///   popAllWhileGoingBack: false,
///   showFilters: true,
///   title: 'Media',
///   titleColor: Colors.black,
///   appBarElevation: 2,
///   grids: ['2x', '3x'],
///   onGridChanged: (grid) => print('Changed to: $grid'),
///   loadingColor: Colors.blue,
/// )
/// ```
/// {@endtemplate}
class MultimediaGalleryAlbumConfiguration {
  /// Whether navigating back should pop all previous routes in the navigation stack.
  ///
  /// This is useful in flow-based navigation (e.g., closing from deep in the app).
  ///
  /// Defaults to `true`.
  final bool popAllWhileGoingBack;

  /// Configuration for the appearance and layout of the album grid.
  ///
  /// Controls row/column spacing, padding, and grid structure.
  ///
  /// `null` by default.
  final AlbumViewConfiguration? configuration;

  /// Icon theme configuration for camera, grid toggle, and back icons.
  ///
  /// Use this to match your application's iconography or color scheme.
  ///
  /// `null` by default.
  final MultimediaIconConfiguration? iconConfiguration;

  /// Layout customization for the album view including padding and alignment.
  ///
  /// `null` by default.
  final MultimediaLayoutConfiguration? layoutConfiguration;

  /// Configuration for the 'Done' button, including its label and action style.
  ///
  /// `null` by default.
  final MultimediaDoneButtonConfiguration? doneButtonConfiguration;

  /// Configuration for the filters displayed above the grid.
  ///
  /// Typically includes tabs or chips for filtering by media type.
  ///
  /// `null` by default.
  final MultimediaGridFilterConfiguration? gridFilterConfiguration;

  /// Configuration for displaying a message or graphic when the album is empty.
  ///
  /// `null` by default.
  final MultimediaNoItemConfiguration? noItemConfiguration;

  /// Whether the media type filters (e.g., All, Photos, Videos) are visible.
  ///
  /// Defaults to `false`.
  final bool showFilters;

  /// A list of grid labels used to switch between grid styles (e.g., ['2x', '3x']).
  ///
  /// `null` by default.
  final List<String>? grids;

  /// Custom widget for the album title.
  ///
  /// This overrides the [title] field when provided.
  ///
  /// `null` by default.
  final Widget? titleWidget;

  /// Title text shown in the app bar of the album screen.
  ///
  /// Ignored if [titleWidget] is provided.
  ///
  /// `null` by default.
  final String? title;

  /// Font size for the album title text.
  ///
  /// `null` by default.
  final double? titleSize;

  /// Font weight for the album title text.
  ///
  /// `null` by default.
  final FontWeight? titleWeight;

  /// Color of the album title text.
  ///
  /// `null` by default.
  final Color? titleColor;

  /// Shadow depth of the app bar in the album view.
  ///
  /// Affects the elevation/visual prominence of the app bar.
  ///
  /// `null` by default.
  final double? appBarElevation;

  /// Vertical and horizontal spacing between grid items.
  ///
  /// `null` by default.
  final double? gridViewSpacing;

  /// Alignment of grid view items along the main axis (vertical).
  ///
  /// Examples: [MainAxisAlignment.start], [MainAxisAlignment.center].
  ///
  /// `null` by default.
  final MainAxisAlignment? gridViewMainAlignment;

  /// Determines how much vertical space the grid should occupy.
  ///
  /// Example: [MainAxisSize.max], [MainAxisSize.min].
  ///
  /// `null` by default.
  final MainAxisSize? gridViewMainAxisSize;

  /// Alignment of grid view items along the cross axis (horizontal).
  ///
  /// Example: [CrossAxisAlignment.start], [CrossAxisAlignment.stretch].
  ///
  /// `null` by default.
  final CrossAxisAlignment? gridViewCrossAlignment;

  /// Builder for the loading state shown when media is being fetched.
  ///
  /// `null` by default.
  final WidgetBuilder? loadingBuilder;

  /// Builder for the empty state when no media items exist in the album.
  ///
  /// `null` by default.
  final WidgetBuilder? emptyBuilder;

  /// Callback triggered when the user changes the grid view layout.
  ///
  /// Use this to track UI interactions or update other components.
  ///
  /// `null` by default.
  final OnMultimediaGridChanged? onGridChanged;

  /// Callback triggered when the layout configuration is updated.
  ///
  /// Can be triggered by user interactions or programmatic changes.
  ///
  /// `null` by default.
  final OnMultimediaLayoutChanged? onLayoutChanged;

  /// Color of the loading indicator (e.g., CircularProgressIndicator color).
  ///
  /// `null` by default.
  final Color? loadingColor;

  /// Maximum file size for displayed media.
  ///
  /// Items larger than this will be excluded.
  ///
  /// `null` by default.
  final int? maxSize;

  /// Minimum file size for displayed media.
  ///
  /// Items smaller than this will be excluded.
  ///
  /// `null` by default.
  final int? minSize;

  /// Called when a media error occurs, such as permission denial or hardware failure.
  ///
  /// `null` by default.
  final OnErrorReceived? onErrorReceived;

  /// Called when media emits an informational message.
  ///
  /// For example, focus locked or exposure adjusted.
  ///
  /// `null` by default.
  final OnInformationReceived? onInfoReceived;

  /// {@macro multimedia_gallery_album_configuration}
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
    this.maxSize,
    this.minSize,
    this.onErrorReceived,
    this.onInfoReceived
  });
}