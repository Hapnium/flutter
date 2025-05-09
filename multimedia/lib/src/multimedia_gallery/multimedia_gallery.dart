import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import 'widgets/gallery_grid_view.dart';
import 'widgets/gallery_list_view.dart';
import 'widgets/not_item_found.dart';

part 'multimedia_gallery_state.dart';

/// A widget that displays a media gallery with support for photos, videos,
/// single/multiple selection, and custom UI configurations.
class MultimediaGallery extends SmartStateful {
  /// The route name of the screen
  final String route;

  /// Configuration object to customize the gallery's appearance and behavior.
  final MultimediaGalleryConfiguration configuration;

  /// Creates a [MultimediaGallery] widget with the provided [configuration].
  const MultimediaGallery({super.key, required this.configuration, required this.route});

  /// Pushes the [MultimediaGallery] onto the navigation stack and returns
  /// the result asynchronously.
  ///
  /// - [context]: The BuildContext to use for navigation.
  /// - [configuration]: Configuration settings for the gallery.
  /// - [maintainState]: Whether the route should remain in memory.
  /// - [fullscreenDialog]: Whether to show the gallery as a fullscreen dialog.
  /// - [allowSnapshotting]: Whether the page can be snapshotted.
  /// - [barrierDismissible]: If true, the gallery can be dismissed by tapping outside.
  /// - [settings]: Optional route settings.
  /// - [routeName]: Optional name for the route.
  ///
  /// Returns a [Future] that resolves to a value of type [T], or null.
  static Future<T?>? to<T>({
    required BuildContext context,
    required MultimediaGalleryConfiguration configuration,
    bool maintainState = true,
    bool fullscreenDialog = true,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    RouteSettings? settings,
    String? routeName
  }) {
    String route = routeName ?? settings?.name ?? "/gallery";

    return Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => MultimediaGallery(configuration: configuration, route: route),
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
      barrierDismissible: barrierDismissible,
      settings: settings ?? RouteSettings(name: routeName ?? "/gallery"),
    ));
  }

  @override
  SmartState<MultimediaGallery> createState() => _MultimediaGalleryState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('onMediaReceived', configuration.onMediaReceived));
    properties.add(DiagnosticsProperty('allowMultipleSelection', configuration.allowMultipleSelection));
    properties.add(DiagnosticsProperty('maxSelection', configuration.maxSelection));
    properties.add(DiagnosticsProperty('configuration', configuration.configuration));
    properties.add(DiagnosticsProperty('icon_configuration', configuration.iconConfiguration));
    properties.add(DiagnosticsProperty('layout_configuration', configuration.layoutConfiguration));
    properties.add(DiagnosticsProperty('no_item_configuration', configuration.noItemConfiguration));
    properties.add(DiagnosticsProperty('no_permission_configuration', configuration.noPermissionConfiguration));
    properties.add(DiagnosticsProperty('file_manager_configuration', configuration.fileManagerConfiguration));
    properties.add(DiagnosticsProperty('appBarElevation', configuration.appBarElevation));
    properties.add(DiagnosticsProperty('titleColor', configuration.titleColor));
    properties.add(DiagnosticsProperty('titleWeight', configuration.titleWeight));
    properties.add(DiagnosticsProperty('titleSize', configuration.titleSize));
    properties.add(DiagnosticsProperty('titleWidget', configuration.titleWidget));
    properties.add(DiagnosticsProperty('dividerColor', configuration.dividerColor));
    properties.add(DiagnosticsProperty('dividerThickness', configuration.dividerThickness));
    properties.add(DiagnosticsProperty('showHeader', configuration.showHeader));
    properties.add(DiagnosticsProperty('headerPadding', configuration.headerPadding));
    properties.add(DiagnosticsProperty('headerColor', configuration.headerColor));
    properties.add(DiagnosticsProperty('headerSize', configuration.headerSize));
    properties.add(DiagnosticsProperty('headerWeight', configuration.headerWeight));
    properties.add(DiagnosticsProperty('showDivider', configuration.showDivider));
    properties.add(DiagnosticsProperty('showManager', configuration.showManager));
    properties.add(DiagnosticsProperty('emptyBuilder', configuration.emptyBuilder));
    properties.add(DiagnosticsProperty('noPermissionBuilder', configuration.noPermissionBuilder));
    properties.add(DiagnosticsProperty('spacing', configuration.spacing));
    properties.add(DiagnosticsProperty('mainAxisAlignment', configuration.mainAxisAlignment));
    properties.add(DiagnosticsProperty('mainAxisSize', configuration.mainAxisSize));
    properties.add(DiagnosticsProperty('crossAxisAlignment', configuration.crossAxisAlignment));
    properties.add(DiagnosticsProperty('onLayoutChanged', configuration.onLayoutChanged));
    properties.add(DiagnosticsProperty('hasPermission', configuration.hasPermission));
    properties.add(StringProperty('title', configuration.title));
    properties.add(DiagnosticsProperty('showOnlyVideo', configuration.showOnlyVideo));
    properties.add(DiagnosticsProperty('showOnlyPhoto', configuration.showOnlyPhoto));
    properties.add(StringProperty('route', route));
  }
}