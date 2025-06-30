import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';

/// {@template paged}
/// A container that holds the current state of a paginated data fetch,
/// including fetched items, pagination keys, errors, and status.
///
/// Used in conjunction with a paginated controller to manage the lifecycle
/// and transitions of pagination.
/// 
/// {@endtemplate}
@immutable
class Paged<Page, Item> {
  /// A map of fetched items grouped by their corresponding page keys.
  ///
  /// This structure maintains an association between each page and the list of items it returned.
  /// It enables grouping or labeling items by their originating page.
  final Map<Page, List<Item>>? pages;

  /// Any error that occurred during the last pagination request.
  final dynamic error;

  /// The key for the next page to be fetched.
  ///
  /// If `null`, this indicates there are no more pages to load.
  final Page? nextPage;

  /// The key for the previous page, useful for tracking reverse pagination or context.
  final Page? previousPage;

  /// Indicates whether logging should be enabled for debug purposes.
  final bool showLog;

  /// Indicates whether the list is currently loading.
  final bool isLoading;

  /// Creates a [Paged] instance with optional state values.
  /// 
  /// {@macro paged}
  const Paged({
    this.nextPage,
    this.pages,
    this.error,
    this.showLog = false,
    this.previousPage,
    this.isLoading = false,
  });

  /// Creates a new [Paged] instance with all values reset to their initial state.
  /// 
  /// {@macro paged}
  Paged<Page, Item> reset() {
    return Paged<Page, Item>(
      pages: null,
      error: null,
      nextPage: null,
      previousPage: null,
      showLog: false,
      isLoading: false,
    );
  }

  /// Creates a copy of this [Paged] instance with overridden values.
  /// 
  /// {@macro paged}
  Paged<Page, Item> copyWith({
    Map<Page, List<Item>>? pages,
    dynamic error,
    Page? nextPage,
    Page? previousPage,
    bool? showLog,
    bool? isLoading,
  }) {
    return Paged<Page, Item>(
      pages: pages ?? this.pages,
      error: error ?? this.error,
      nextPage: nextPage ?? this.nextPage,
      previousPage: previousPage ?? this.previousPage,
      showLog: showLog ?? this.showLog,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// A flattened list of all fetched items across all pages.
  ///
  /// Returns `null` if no items have been fetched yet.
  List<Item>? get items => pages != null ? List.unmodifiable(pages!.values.expand((e) => e)) : null;

  /// A list of all page keys in the order they were fetched.
  ///
  /// Returns `null` if no pages have been loaded yet.
  List<Page>? get pageKeys => pages != null ? List.unmodifiable(pages!.keys) : null;

  /// Whether the last fetched page is empty.
  ///
  /// Useful for detecting end-of-pagination conditions when the API returns
  /// an empty result rather than a `null` next page.
  bool get lastPageIsEmpty => pages != null ? pages![pages!.keys.last]?.isEmpty ?? false : false;

  /// Internal helper: total number of items fetched.
  int? get _itemCount => items?.length;

  /// Internal helper: whether there’s another page to be fetched.
  bool get hasNextPage => nextPage.isNotNull;

  /// Internal helper: whether any items have been fetched.
  bool get _hasItems {
    final itemCount = _itemCount;
    return itemCount.isNotNull && itemCount!.isGt(0);
  }

  /// Internal helper: whether an error has occurred.
  bool get _hasError => error != null;

  /// Internal helper: whether the list is loading with more pages expected.
  bool get _isListingUnfinished => _hasItems && hasNextPage;

  /// Internal helper: whether data is currently loading or incomplete and has no errors yet.
  bool get _isOngoing => _isListingUnfinished && !_hasError;

  /// Internal helper: whether listing is completed and there are no more pages.
  bool get _isCompleted => _hasItems && !hasNextPage;

  /// Internal helper: whether this is the initial loading state (first page).
  bool get _isLoadingFirstPage => _itemCount == null && !_hasError;

  /// Internal helper: whether the error occurred after the first page.
  bool get _hasSubsequentPageError => _isListingUnfinished && _hasError;

  /// Internal helper: whether the listing is empty and completed.
  bool get _isEmpty => _itemCount.isNotNull && _itemCount == 0;

  /// The computed pagination status based on current state.
  ///
  /// - [PagedStatus.ONGOING] - More pages expected and no error yet.
  /// - [PagedStatus.COMPLETED] - All items fetched, no more pages.
  /// - [PagedStatus.LOADING_FIRST_PAGE] - No items fetched yet, still loading.
  /// - [PagedStatus.SUBSEQUENT_PAGE_ERROR] - An error occurred while fetching after the first page.
  /// - [PagedStatus.NO_ITEMS_FOUND] - No items available (empty first page).
  /// - [PagedStatus.FIRST_PAGE_ERROR] - An error occurred while fetching the first page.
  PagedStatus get status {
    if (_isOngoing) return PagedStatus.ONGOING;
    if (_isCompleted) return PagedStatus.COMPLETED;
    if (_isLoadingFirstPage) return PagedStatus.LOADING_FIRST_PAGE;
    if (_hasSubsequentPageError) return PagedStatus.SUBSEQUENT_PAGE_ERROR;
    if (_isEmpty) return PagedStatus.NO_ITEMS_FOUND;
    return PagedStatus.FIRST_PAGE_ERROR;
  }

  @override
  String toString() => '${objectRuntimeType(this, 'Paged')}(items: \u2524'
          '$items\u251C, error: $error, nextPage: $nextPage, previousPage: $previousPage, showLog: $showLog, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Paged &&
        other.items == items &&
        other.error == error &&
        other.nextPage == nextPage &&
        other.previousPage == previousPage &&
        other.showLog == showLog &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => Object.hash(items.hashCode, error.hashCode, nextPage.hashCode, previousPage.hashCode, showLog.hashCode, isLoading.hashCode);
}