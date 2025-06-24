import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'widgets/gallery_grid_view.dart';
import 'widgets/gallery_list_view.dart';
import 'widgets/not_item_found.dart';

part 'multimedia_gallery_state.dart';

/// {@template multimedia_gallery}
/// A widget that displays a customizable media gallery interface.
///
/// The [MultimediaGallery] supports:
/// - Browsing photos and videos.
/// - Single or multiple selection modes.
/// - Display customization using UI configurations like layout, icons, colors, and typography.
/// - Permission handling and empty state builders.
/// - Callbacks for selected media.
///
/// It is ideal for media picker implementations where users need to select one or more images/videos.
///
/// ### Example usage:
/// ```dart
/// MultimediaGallery.to(
///   context: context,
///   configuration: MultimediaGalleryConfiguration(
///     allowMultipleSelection: true,
///     onMediaReceived: (List<Media> media) {
///       print('Selected media: $media');
///     },
///   ),
/// );
/// ```
/// {@endtemplate}
class MultimediaGallery extends SmartStateful {
  /// The route name of the screen.
  ///
  /// This is used for navigation and debugging. Default is `"/gallery"` if none is provided.
  final String route;

  /// Configuration object to customize the gallery's appearance and behavior.
  ///
  /// Includes layout settings, title options, icon configurations, selection options,
  /// empty states, permission handling, and media type filters.
  final MultimediaGalleryConfiguration configuration;

  /// {@macro multimedia_gallery}
  const MultimediaGallery({
    super.key,
    required this.configuration,
    required this.route,
  });

  /// Pushes the [MultimediaGallery] onto the navigation stack and returns the result asynchronously.
  ///
  /// - [context]: Build context used for navigation.
  /// - [configuration]: Media gallery configuration.
  /// - [maintainState]: Whether to keep the gallery alive after pop. Default: `true`.
  /// - [fullscreenDialog]: Show gallery as a fullscreen dialog. Default: `true`.
  /// - [allowSnapshotting]: Whether the gallery page allows OS-level snapshotting. Default: `true`.
  /// - [barrierDismissible]: If true, allows tapping outside to dismiss. Default: `false`.
  /// - [settings]: Optional custom [RouteSettings].
  /// - [routeName]: Optional route name override.
  ///
  /// Returns a [Future<T?>] that resolves with the gallery's result, or null if canceled.
  static Future<T?>? to<T>({
    required BuildContext context,
    required MultimediaGalleryConfiguration configuration,
    bool maintainState = true,
    bool fullscreenDialog = true,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    RouteSettings? settings,
    String? routeName,
  }) {
    String route = routeName ?? settings?.name ?? "/gallery";

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            MultimediaGallery(configuration: configuration, route: route),
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting,
        barrierDismissible: barrierDismissible,
        settings: settings ?? RouteSettings(name: route),
      ),
    );
  }

  @override
  SmartState<MultimediaGallery> createState() => _MultimediaGalleryState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onMediaReceived', configuration.onMediaReceived)); // null
    properties.add(DiagnosticsProperty('allowMultipleSelection', configuration.allowMultipleSelection)); // false
    properties.add(DiagnosticsProperty('maxSelection', configuration.maxSelection)); // null
    properties.add(DiagnosticsProperty('configuration', configuration.configuration)); // null
    properties.add(DiagnosticsProperty('icon_configuration', configuration.iconConfiguration)); // null
    properties.add(DiagnosticsProperty('layout_configuration', configuration.layoutConfiguration)); // null
    properties.add(DiagnosticsProperty('no_item_configuration', configuration.noItemConfiguration)); // null
    properties.add(DiagnosticsProperty('no_permission_configuration', configuration.noPermissionConfiguration)); // null
    properties.add(DiagnosticsProperty('file_manager_configuration', configuration.fileManagerConfiguration)); // null
    properties.add(DiagnosticsProperty('appBarElevation', configuration.appBarElevation)); // null
    properties.add(DiagnosticsProperty('titleColor', configuration.titleColor)); // null
    properties.add(DiagnosticsProperty('titleWeight', configuration.titleWeight)); // null
    properties.add(DiagnosticsProperty('titleSize', configuration.titleSize)); // null
    properties.add(DiagnosticsProperty('titleWidget', configuration.titleWidget)); // null
    properties.add(DiagnosticsProperty('dividerColor', configuration.dividerColor)); // null
    properties.add(DiagnosticsProperty('dividerThickness', configuration.dividerThickness)); // null
    properties.add(DiagnosticsProperty('showHeader', configuration.showHeader)); // true
    properties.add(DiagnosticsProperty('headerPadding', configuration.headerPadding)); // null
    properties.add(DiagnosticsProperty('headerColor', configuration.headerColor)); // null
    properties.add(DiagnosticsProperty('headerSize', configuration.headerSize)); // null
    properties.add(DiagnosticsProperty('headerWeight', configuration.headerWeight)); // null
    properties.add(DiagnosticsProperty('showDivider', configuration.showDivider)); // true
    properties.add(DiagnosticsProperty('showManager', configuration.showManager)); // true
    properties.add(DiagnosticsProperty('emptyBuilder', configuration.emptyBuilder)); // null
    properties.add(DiagnosticsProperty('noPermissionBuilder', configuration.noPermissionBuilder)); // null
    properties.add(DiagnosticsProperty('spacing', configuration.spacing)); // null
    properties.add(DiagnosticsProperty('mainAxisAlignment', configuration.mainAxisAlignment)); // null
    properties.add(DiagnosticsProperty('mainAxisSize', configuration.mainAxisSize)); // null
    properties.add(DiagnosticsProperty('crossAxisAlignment', configuration.crossAxisAlignment)); // null
    properties.add(DiagnosticsProperty('onLayoutChanged', configuration.onLayoutChanged)); // null
    properties.add(DiagnosticsProperty('hasPermission', configuration.hasPermission)); // null
    properties.add(StringProperty('title', configuration.title)); // null
    properties.add(DiagnosticsProperty('showOnlyVideo', configuration.showOnlyVideo)); // false
    properties.add(DiagnosticsProperty('showOnlyPhoto', configuration.showOnlyPhoto)); // false
    properties.add(StringProperty('route', route));
  }
}