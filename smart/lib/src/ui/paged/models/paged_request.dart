import 'package:flutter/foundation.dart';

import 'paged.dart';

/// {@template paged_request}
/// A container representing the state of a paginated request,
/// holding fetched pages and the next page key.
///
/// Used alongside a paginated controller to maintain and transition
/// between states in a paginated list or grid view.
/// {@endtemplate}
@immutable
class PagedRequest<Page, Item> {
  /// A map of fetched items grouped by their page key.
  ///
  /// This allows for efficient lookups and incremental page loading.
  final Pageable<Page, Item>? pages;

  /// The key for the next page to be fetched.
  ///
  /// If `null`, there are no more pages to load.
  final Page? nextPage;

  /// Creates a new instance of [PagedRequest].
  /// 
  /// {@macro paged_request}
  const PagedRequest({
    this.pages,
    this.nextPage,
  });

  /// Returns an empty [PagedRequest].
  /// 
  /// {@macro paged_request}
  factory PagedRequest.empty() => PagedRequest<Page, Item>();

  /// Creates a [PagedRequest] from a flat list of [Item]s and page size,
  /// using integer-based page keys.
  ///
  /// Useful for quickly building a `PagedRequest<int, Item>` for testing or initial state.
  /// 
  /// {@macro paged_request}
  static PagedRequest<int, Item> ofIntPage<Item>(List<Item> items, {int pageSize = 10}) {
    if (pageSize <= 0) {
      throw ArgumentError('Page size must be greater than 0');
    }

    Pageable<int, Item> pages = <int, List<Item>>{};
    for (int i = 0; i < items.length; i += pageSize) {
      final pageKey = i ~/ pageSize;
      pages[pageKey] = items.skip(i).take(pageSize).toList();
    }

    final nextPage = pages.isEmpty ? 0 : pages.keys.last + 1;

    return PagedRequest<int, Item>(
      pages: pages,
      nextPage: nextPage,
    );
  }

  /// Creates a [PagedRequest] from a flat list of [Item]s and a custom page key list.
  ///
  /// You must provide a [keyBuilder] that maps an item index to a `Page` key.
  /// Use this for non-integer pagination types like `String`, `DateTime`, etc.
  /// 
  /// {@macro paged_request}
  static PagedRequest<Page, Item> ofPageType<Page, Item>(List<Item> items, {
    required Page Function(int index) keyBuilder,
    required int pageSize,
    Page Function(List<Page> pages, List<Item> items)? nextPageBuilder,
  }) {
    if (pageSize <= 0) {
      throw ArgumentError('Page size must be greater than 0');
    }

    Pageable<Page, Item> pages = <Page, List<Item>>{};
    for (int i = 0; i < items.length; i += pageSize) {
      final key = keyBuilder(i);
      pages[key] = items.skip(i).take(pageSize).toList();
    }

    return PagedRequest<Page, Item>(
      pages: pages,
      nextPage: nextPageBuilder?.call(pages.keys.toList(), items),
    );
  }

  @override
  String toString() => '${objectRuntimeType(this, 'PagedRequest')}(pages: $pages, nextPage: $nextPage)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PagedRequest<Page, Item> && mapEquals(other.pages, pages) && other.nextPage == nextPage;

  @override
  int get hashCode => Object.hash(pages, nextPage);
}