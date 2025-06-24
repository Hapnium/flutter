part of '../gallery.dart';

/// {@template media_page}
/// A paginated set of [Medium] items from a single [Album].
///
/// This model supports pagination by calling [nextPage()] if available.
///
/// ### Example usage:
/// ```dart
/// MediaPage page = await Gallery._listMedia(album: album, take: 20);
///
/// for (var medium in page.items) {
///   print(medium.filename);
/// }
///
/// if (!page.isLast) {
///   MediaPage next = await page.nextPage();
/// }
/// ```
/// {@endtemplate}
@immutable
class MediaPage {
  /// The album this page belongs to.
  final Album album;

  /// The offset of the first item in this page.
  final int start;

  /// List of media items on this page.
  final List<Medium> items;

  /// If true, this page was retrieved using lightweight metadata.
  ///
  /// Default: `null`
  final bool? lightWeight;

  /// The offset for the next page.
  int get end => start + items.length;

  /// Whether this is the last page in the album.
  bool get isLast => end >= album.count;

  /// Creates a range of media from platform channel protocol.
  /// 
  /// {@macro media_page}
  MediaPage.fromJson(this.album, dynamic json, {this.lightWeight})
      : start = json['start'] ?? 0,
        items = json['items'].map<Medium>((x) => Medium.fromJson(x)).toList();

  /// Gets the next page of media in the album.
  /// 
  /// {@macro media_page}
  Future<MediaPage> nextPage() {
    assert(!isLast);
    return Gallery._listMedia(
      album: album,
      skip: end,
      take: items.length,
      lightWeight: lightWeight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaPage &&
          runtimeType == other.runtimeType &&
          album == other.album &&
          start == other.start &&
          listEquals(items, other.items);

  @override
  int get hashCode => album.hashCode ^ start.hashCode ^ items.hashCode;

  @override
  String toString() {
    return 'MediaPage{album: $album, '
        'start: $start, '
        'items: $items}';
  }
}