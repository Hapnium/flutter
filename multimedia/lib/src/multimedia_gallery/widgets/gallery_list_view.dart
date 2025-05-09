import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import '../album/multimedia_gallery_album.dart';
import 'album_information.dart';

/// A scrollable list view for displaying photo/video albums.
///
/// The `GalleryListView` widget shows a list of `Album` objects, each
/// rendered with a thumbnail, name, and count. It allows customization of layout,
/// styling, and selection behavior.
///
/// It supports navigation into a detailed album view using the `Animated` widget,
/// or full customization via a user-provided `albumItemBuilder`.
///
/// ### Example usage:
/// ```dart
/// GalleryListView(
///   albums: albums,
///   onSelected: handleSelection,
///   multipleAllowed: true,
///   maxSelection: 5,
/// )
/// ```
class GalleryListView extends StatelessWidget {
  /// The parent route name of the screen
  final String parentRoute;

  /// List of albums to be displayed.
  final List<Album> albums;

  /// Callback when media is selected from an album.
  final bool multipleAllowed;

  /// Optional limit on how many media items can be selected.
  final MediumListReceived onSelected;

  /// Whether multiple selections are allowed.
  final int? maxSelection;

  /// The configuration for the gallery view.
  final GalleryViewConfiguration configuration;

  /// A scrollable list view for displaying photo/video albums.
  ///
  /// The `GalleryListView` widget shows a list of `Album` objects, each
  /// rendered with a thumbnail, name, and count. It allows customization of layout,
  /// styling, and selection behavior.
  ///
  /// It supports navigation into a detailed album view using the `Animated` widget,
  /// or full customization via a user-provided `albumItemBuilder`.
  ///
  /// ### Example usage:
  /// ```dart
  /// GalleryListView(
  ///   albums: albums,
  ///   onSelected: handleSelection,
  ///   multipleAllowed: true,
  ///   maxSelection: 5,
  /// )
  /// ```
  const GalleryListView({
    super.key,
    required this.albums,
    required this.onSelected,
    required this.maxSelection,
    required this.multipleAllowed,
    required this.configuration,
    required this.parentRoute
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: configuration.scrollThickness ?? 5.0,
      child: ListView.separated(
        padding: configuration.padding ?? EdgeInsets.all(6.0),
        itemCount: albums.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return configuration.separator ?? SizedBox(height: 6);
        },
        itemBuilder: (context, index) {
          Album album = albums[index];
          String route = "$parentRoute/${configuration.route ?? "?album=${album.id}"}";
          ImageProvider image = AlbumThumbnailProvider(album: album, highQuality: true);

          if(configuration.albumItemBuilder.isNotNull) {
            return configuration.albumItemBuilder!(context, album, image);
          }

          return Animated(
            toWidget: MultimediaGalleryAlbum(
              album: album,
              onMediumReceived: onSelected,
              multipleAllowed: multipleAllowed,
              maxSelection: maxSelection,
              configuration: configuration.albumConfiguration,
              parentRoute: route
            ),
            borderRadius: configuration.borderRadius ?? BorderRadius.circular(12),
            route: route,
            closedElevation: 0,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: configuration.imageBackgroundColor ?? Colors.grey[300],
                  height: configuration.imageHeight ?? 70,
                  width: configuration.imageWidth ?? 70,
                  child: FadeInImage(fit: configuration.imageFit ?? BoxFit.cover, placeholder: image, image: image),
                ),
                Expanded(
                  child: Column(
                    spacing: configuration.contentSpacing ?? 0,
                    mainAxisAlignment: configuration.contentMainAxisAlignment ?? MainAxisAlignment.start,
                    crossAxisAlignment: configuration.contentCrossAxisAlignment ?? CrossAxisAlignment.start,
                    children: [
                      TextBuilder(
                        text: (album.name ?? "Unnamed Album").capitalizeEach,
                        size: configuration.nameSize ?? Sizing.font(14),
                        autoSize: false,
                        weight: configuration.nameWeight ?? FontWeight.bold,
                        color: configuration.nameColor ?? Theme.of(context).primaryColor,
                        flow: configuration.nameOverflow ?? TextOverflow.ellipsis,
                      ),
                      TextBuilder(
                        text: "${album.count}",
                        size: configuration.countSize ?? Sizing.font(12),
                        autoSize: false,
                        color: configuration.countColor ?? Theme.of(context).primaryColor,
                        flow: configuration.countOverflow ?? TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AlbumInformation(
                  album: album,
                  newestColor: configuration.newestColor,
                  oldestColor: configuration.oldestColor,
                  infoColor: configuration.infoColor,
                  infoSize: configuration.infoSize,
                  infoPadding: configuration.infoPadding,
                  infoRadius: configuration.infoRadius
                ),
              ],
            ),
          );
        }
      )
    );
  }
}