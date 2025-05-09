import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

import '../album/multimedia_gallery_album.dart';
import 'album_information.dart';

/// A responsive grid view for displaying media albums in a tiled layout.
///
/// The `GalleryGridView` shows `Album` objects in a grid. Each item includes
/// an image thumbnail and metadata. The layout adapts based on provided size
/// or screen constraints. Navigation and selection are built in, or can be customized.
///
/// ### Example:
/// ```dart
/// GalleryGridView(
///   albums: albums,
///   onSelected: (media) => print(media),
///   multipleAllowed: false,
///   displayCount: 3,
/// )
/// ```
class GalleryGridView extends StatelessWidget {
  /// The parent route name of the screen
  final String parentRoute;

  /// List of albums to be displayed.
  final List<Album> albums;

  /// Tells if multiple selection is allowed.
  final bool multipleAllowed;

  /// Callback when media is selected from an album.
  final MediumListReceived onSelected;

  /// Optional limit on how many media items can be selected.
  final int? maxSelection;

  /// The configuration for the gallery view.
  final GalleryViewConfiguration configuration;

  /// A responsive grid view for displaying media albums in a tiled layout.
  ///
  /// The `GalleryGridView` shows `Album` objects in a grid. Each item includes
  /// an image thumbnail and metadata. The layout adapts based on provided size
  /// or screen constraints. Navigation and selection are built in, or can be customized.
  ///
  /// ### Example:
  /// ```dart
  /// GalleryGridView(
  ///   albums: albums,
  ///   onSelected: (media) => print(media),
  ///   multipleAllowed: false,
  ///   displayCount: 3,
  /// )
  /// ```
  const GalleryGridView({
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
    return Padding(
      padding: configuration.padding ?? const EdgeInsets.all(4.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int count = configuration.displayCount ?? 2;
          double gridWidth = configuration.width ?? (constraints.maxWidth - 20) / count;

          return Scrollbar(
            thickness: configuration.scrollThickness ?? 5.0,
            child: GridView.builder(
              padding: configuration.padding ?? const EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: configuration.ratio ?? gridWidth / (gridWidth + 50),
                crossAxisCount: count,
                mainAxisSpacing: configuration.mainAxisSpacing ?? 10.0,
                crossAxisSpacing: configuration.crossAxisSpacing ?? 10.0,
              ),
              itemCount: albums.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Album album = albums[index];
                ImageProvider image = AlbumThumbnailProvider(album: album, highQuality: true);
                String route = "$parentRoute/${configuration.route ?? "?album=${album.id}"}";

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: configuration.imageBackgroundColor ?? Colors.grey[300],
                          width: gridWidth,
                          child: FadeInImage(fit: configuration.imageFit ?? BoxFit.cover, placeholder: image, image: image),
                        ),
                      ),
                      Padding(
                        padding: configuration.contentPadding ?? const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: configuration.contentSpacing ?? 2,
                          mainAxisAlignment: configuration.contentMainAxisAlignment ?? MainAxisAlignment.start,
                          crossAxisAlignment: configuration.contentCrossAxisAlignment ?? CrossAxisAlignment.start,
                          children: [
                            AlbumInformation(
                              album: album,
                              newestColor: configuration.newestColor,
                              oldestColor: configuration.oldestColor,
                              infoColor: configuration.infoColor,
                              infoSize: configuration.infoSize,
                              infoPadding: configuration.infoPadding,
                              infoRadius: configuration.infoRadius
                            ),
                            TextBuilder(
                              text: "(${album.count}) ${(album.name ?? "Unnamed Album").capitalizeEach}",
                              size: configuration.nameSize ?? 14,
                              autoSize: false,
                              weight: configuration.nameWeight ?? FontWeight.bold,
                              color: configuration.nameColor ?? Theme.of(context).primaryColor,
                              flow: TextOverflow.ellipsis,
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          );
        }
      )
    );
  }
}