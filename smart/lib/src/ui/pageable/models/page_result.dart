/// {@template page_result}
/// Represents the result of a single page fetch operation in a paginated data source.
///
/// This class simplifies the handling of page data by grouping
/// the fetched items with their associated page key and optional metadata.
///
/// Generic parameters:
/// - [PageKey]: The type used to identify pages (e.g., int, String, DateTime).
/// - [Item]: The type of individual items contained in the page.
///
/// Example usage:
/// ```dart
/// final pageResult = PageResult<int, String>(
///   pageKey: 1,
///   items: ['Item 1', 'Item 2', 'Item 3'],
///   totalCount: 100,
///   metadata: {'fetchedAt': DateTime.now()},
/// );
///
/// print(pageResult.hasItems); // true
/// print(pageResult.itemCount); // 3
/// print(pageResult);
/// ```
///
/// {@endtemplate}
class PageResult<PageKey, Item> {
  /// The unique key identifying this page.
  final PageKey pageKey;

  /// The list of items fetched for this page.
  final List<Item> items;

  /// Optional: The total number of items available across all pages.
  ///
  /// Useful for showing progress indicators or calculating completion.
  final int? totalCount;

  /// Optional: Any additional metadata related to this page.
  ///
  /// Can be used to store information such as fetch timestamp, cache status, etc.
  final Map<String, dynamic>? metadata;

  /// Creates a new [PageResult] instance with the given page key and items.
  ///
  /// [pageKey] and [items] are required.
  /// [totalCount] and [metadata] are optional.
  /// 
  /// {@macro page_result}
  const PageResult({
    required this.pageKey,
    required this.items,
    this.totalCount,
    this.metadata,
  });

  /// Returns `true` if this page contains any items.
  bool get hasItems => items.isNotEmpty;

  /// Returns the number of items in this page.
  int get itemCount => items.length;

  @override
  String toString() {
    return 'PageResult(pageKey: $pageKey, items: ${items.length}, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageResult<PageKey, Item> &&
        other.pageKey == pageKey &&
        other.items.length == items.length &&
        other.totalCount == totalCount;
  }

  @override
  int get hashCode {
    return Object.hash(pageKey, items.length, totalCount);
  }
}