import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import '../widgets/not_item_found.dart';
import 'widgets/album_grid_view.dart';
import 'widgets/album_list_view.dart';

part 'multimedia_gallery_album_state.dart';

/// A widget that displays all media from a single album in a grid layout,
/// supporting filtering, selection, and custom styling options.
class MultimediaGalleryAlbum extends StatefulWidget {
  /// The parent route name of the screen
  final String parentRoute;

  /// The album to display.
  final Album album;

  /// Whether multiple media selection is allowed.
  final bool multipleAllowed;

  /// Callback triggered when media is selected.
  final MediumListReceived? onMediumReceived;

  /// Maximum number of items that can be selected.
  final int? maxSelection;

  /// Configuration object for customizing the album screen.
  final MultimediaGalleryAlbumConfiguration configuration;

  /// Creates a [MultimediaGalleryAlbum] widget.
  const MultimediaGalleryAlbum({
    super.key,
    required this.album,
    required this.maxSelection,
    required this.onMediumReceived,
    required this.multipleAllowed,
    required this.configuration,
    required this.parentRoute
  });

  @override
  State<MultimediaGalleryAlbum> createState() => _MultimediaGalleryAlbumState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onMediumReceived', onMediumReceived));
    properties.add(DiagnosticsProperty('album', album));
    properties.add(StringProperty('album_id', album.id));
    properties.add(StringProperty('album_name', album.name));
    properties.add(DiagnosticsProperty('album_newest', album.newest));
    properties.add(EnumProperty('album_medium_type', album.mediumType));
    properties.add(IntProperty('album_count', album.count));
    properties.add(StringProperty('album_view', album.toString()));
    properties.add(IntProperty('max_selection', maxSelection));
    properties.add(DiagnosticsProperty('multiple_allowed', multipleAllowed));
    properties.add(DiagnosticsProperty('pop_all_while_going_back', configuration.popAllWhileGoingBack));
    properties.add(DiagnosticsProperty('configuration', configuration));
    properties.add(DiagnosticsProperty('icon_configuration', configuration.iconConfiguration));
    properties.add(DiagnosticsProperty('layout_configuration', configuration.layoutConfiguration));
    properties.add(DiagnosticsProperty('done_button_configuration', configuration.doneButtonConfiguration));
    properties.add(DiagnosticsProperty('grid_filter_configuration', configuration.gridFilterConfiguration));
    properties.add(DiagnosticsProperty('no_item_configuration', configuration.noItemConfiguration));
    properties.add(DiagnosticsProperty('show_filters', configuration.showFilters));
    properties.add(DiagnosticsProperty('grids', configuration.grids));
    properties.add(DiagnosticsProperty('title_widget', configuration.titleWidget));

    if(configuration.title != null) {
      properties.add(StringProperty('title', configuration.title!));
    }

    properties.add(DiagnosticsProperty('title_size', configuration.titleSize));
    properties.add(DiagnosticsProperty('title_weight', configuration.titleWeight));
    properties.add(DiagnosticsProperty('title_color', configuration.titleColor));
    properties.add(DiagnosticsProperty('app_bar_elevation', configuration.appBarElevation));
    properties.add(DiagnosticsProperty('grid_view_spacing', configuration.gridViewSpacing));
    properties.add(DiagnosticsProperty('grid_view_main_alignment', configuration.gridViewMainAlignment));
    properties.add(DiagnosticsProperty('grid_view_main_axis_size', configuration.gridViewMainAxisSize));
    properties.add(DiagnosticsProperty('grid_view_cross_alignment', configuration.gridViewCrossAlignment));
    properties.add(DiagnosticsProperty('loading_builder', configuration.loadingBuilder));
    properties.add(DiagnosticsProperty('empty_builder', configuration.emptyBuilder));
    properties.add(DiagnosticsProperty('on_grid_changed', configuration.onGridChanged));
    properties.add(DiagnosticsProperty('on_layout_changed', configuration.onLayoutChanged));
    properties.add(DiagnosticsProperty('loading_color', configuration.loadingColor));
    properties.add(StringProperty('parent_route', parentRoute));
  }
}