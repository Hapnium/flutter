import '../models/paged.dart';
import '../models/paged_request.dart';
import 'paged_controller.dart';

/// Extension on [PagedController] with `int` as the page key type.
/// 
/// Provides a utility method to build a [Paged] object from a list of items
/// using integer-based pagination.
extension IntPagedControllerExtension<Item> on PagedController<int, Item> {
  /// Builds a [Paged] object from a list of [items] with optional configuration.
  ///
  /// - [items]: The list of items to paginate.
  /// - [pageSize]: The number of items per page. Defaults to 10.
  /// - [useCurrent]: If `true`, preserves current controller state such as
  ///   [PagedController.value.showLog] and [PagedController.value.isLoading].
  ///
  /// Returns a [Paged] instance initialized with the given data.
  Paged<int, Item> build(List<Item> items, {int pageSize = 10, bool useCurrent = false}) {
    final request = PagedRequest.ofIntPage(items, pageSize: pageSize);

    return Paged(
      pages: request.pages,
      nextPage: request.nextPage,
      previousPage: null,
      showLog: useCurrent ? value.showLog : false,
      isLoading: useCurrent ? value.isLoading : false,
    );
  }
}

/// Extension on [PagedController] with generic page key type [Page].
///
/// Useful when pagination is based on custom keys (e.g., strings, objects).
extension PageTypePagedControllerExtension<Page, Item> on PagedController<Page, Item> {
  /// Builds a [Paged] object from a list of [items] with custom page key logic.
  ///
  /// - [items]: The list of items to paginate.
  /// - [pageSize]: The number of items per page. Defaults to 10.
  /// - [useCurrent]: If `true`, preserves current controller state such as
  ///   [PagedController.value.showLog] and [PagedController.value.isLoading].
  /// - [keyBuilder]: A function that generates a page key of type [Page] based on index.
  /// - [nextPageBuilder]: An optional function to determine the next page key
  ///   from the current list of pages and items.
  ///
  /// Returns a [Paged] instance initialized with the given data and logic.
  Paged<Page, Item> build(
    List<Item> items, {
    int pageSize = 10,
    bool useCurrent = false,
    required Page Function(int index) keyBuilder,
    Page Function(List<Page> pages, List<Item> items)? nextPageBuilder,
  }) {
    final request = PagedRequest.ofPageType<Page, Item>(
      items,
      pageSize: pageSize,
      keyBuilder: keyBuilder,
      nextPageBuilder: nextPageBuilder,
    );

    return Paged(
      pages: request.pages,
      nextPage: request.nextPage,
      previousPage: null,
      showLog: useCurrent ? value.showLog : false,
      isLoading: useCurrent ? value.isLoading : false,
    );
  }
}