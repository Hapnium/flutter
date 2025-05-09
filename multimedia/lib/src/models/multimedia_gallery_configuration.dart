import 'package:flutter/cupertino.dart';
import 'package:multimedia/multimedia.dart';

/// Configuration for customizing the [MultimediaGallery] widget.
class MultimediaGalleryConfiguration {
  /// Title shown in the gallery app bar.
  final String title;

  /// Whether to show only videos.
  final bool showOnlyVideo;

  /// Whether to show only photos.
  final bool showOnlyPhoto;

  /// If true, allows multiple media selections.
  final bool allowMultipleSelection;

  /// Callback triggered when media is selected.
  final SelectedMediaListReceived? onMediaReceived;

  /// Maximum number of selectable items (null = unlimited).
  final int? maxSelection;

  /// UI configuration for the gallery grid/list view.
  final GalleryViewConfiguration? configuration;

  /// Custom icons used in the gallery.
  final MultimediaIconConfiguration? iconConfiguration;

  /// Custom layout options for gallery UI elements.
  final MultimediaLayoutConfiguration? layoutConfiguration;

  /// Configuration to display when no media items are found.
  final MultimediaNoItemConfiguration? noItemConfiguration;

  /// Configuration to display when permissions are not granted.
  final MultimediaNoPermissionConfiguration? noPermissionConfiguration;

  /// Configuration for managing files from the gallery.
  final MultimediaFileManagerConfiguration? fileManagerConfiguration;

  /// Elevation of the app bar.
  final double? appBarElevation;

  /// Color of the app bar title.
  final Color? titleColor;

  /// Font weight of the app bar title.
  final FontWeight? titleWeight;

  /// Font size of the app bar title.
  final double? titleSize;

  /// Custom widget to use instead of the default title.
  final Widget? titleWidget;

  /// Divider color used between sections.
  final Color? dividerColor;

  /// Thickness of the divider.
  final double? dividerThickness;

  /// Whether to show the header.
  final bool showHeader;

  /// Padding around the header.
  final EdgeInsets? headerPadding;

  /// Color of the header text.
  final Color? headerColor;

  /// Font size of the header text.
  final double? headerSize;

  /// Font weight of the header text.
  final FontWeight? headerWeight;

  /// Whether to show a divider.
  final bool showDivider;

  /// Whether to show the media manager at the bottom.
  final bool showManager;

  /// Builder for the empty state widget.
  final WidgetBuilder? emptyBuilder;

  /// Builder for the no-permission widget.
  final WidgetBuilder? noPermissionBuilder;

  /// Spacing between grid/list items.
  final double? spacing;

  /// MainAxisAlignment of media items.
  final MainAxisAlignment? mainAxisAlignment;

  /// MainAxisSize of media items.
  final MainAxisSize? mainAxisSize;

  /// CrossAxisAlignment of media items.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Callback when the layout is changed (e.g., grid to list).
  final OnMultimediaLayoutChanged? onLayoutChanged;

  /// Optional permission check override.
  final Future<bool> Function()? hasPermission;

  /// Creates a [MultimediaGalleryConfiguration] with optional customization.
  const MultimediaGalleryConfiguration({
    this.title = "",
    this.showOnlyVideo = false,
    this.showOnlyPhoto = true,
    this.onMediaReceived,
    this.allowMultipleSelection = false,
    this.maxSelection,
    this.configuration,
    this.iconConfiguration,
    this.layoutConfiguration,
    this.noItemConfiguration,
    this.noPermissionConfiguration,
    this.fileManagerConfiguration,
    this.appBarElevation,
    this.titleColor,
    this.titleWeight,
    this.titleSize,
    this.titleWidget,
    this.dividerColor,
    this.dividerThickness,
    this.showHeader = true,
    this.headerPadding,
    this.headerColor,
    this.headerSize,
    this.headerWeight,
    this.showDivider = true,
    this.showManager = true,
    this.emptyBuilder,
    this.noPermissionBuilder,
    this.spacing,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.onLayoutChanged,
    this.hasPermission,
  });
}