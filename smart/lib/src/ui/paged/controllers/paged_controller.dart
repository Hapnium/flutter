import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tracing/tracing.dart' show console;

import '../../export.dart';

/// A function that returns the next page key based on current pagination state.
///
/// Returning `null` indicates that there are no more pages to load.
///
/// Example:
/// ```dart
/// final controller = PagedController<int, String>(
///   getNextPage: (state) {
///     return state.nextPage == null ? 0 : state.nextPage! + 1;
///   },
///   fetchPage: (page) async => fetchDataFromServer(page),
/// );
/// ```
typedef _NextPageCallback<Page, Item> = Page? Function(Paged<Page, Item> state);

/// A function that asynchronously returns a list of items for a given page key.
///
/// Example:
/// ```dart
/// Future<List<String>> fetchDataFromServer(int page) async {
///   final result = await api.fetch(page);
///   return result.items;
/// }
/// ```
typedef _PagedAsyncCallback<Page, Item> = FutureOr<List<Item>> Function(Page pageKey);

/// {@template paged_controller}
/// A controller that manages paginated data fetching and state for UI.
///
/// It tracks:
/// - Pages that have been fetched.
/// - The next page key.
/// - Loading/error state.
/// - A flat list of all fetched items.
///
/// Used with widgets that support infinite scroll or pagination.
///
/// ### Basic Usage:
/// ```dart
/// final controller = PagedController<int, Product>(
///   getNextPage: (state) => state.nextPage == null ? 0 : state.nextPage! + 1,
///   fetchPage: (page) async => await api.getProducts(page: page),
/// );
///
/// // Then in a scrollable widget
/// ListView.builder(
///   itemCount: controller.itemList?.length ?? 0,
///   itemBuilder: (context, index) {
///     final item = controller.itemList![index];
///
///     if (index >= controller.itemList!.length - 2) {
///       controller.fetchNextPage(); // Trigger next page fetch
///     }
///
///     return ProductCard(product: item);
///   },
/// );
/// ```
/// {@endtemplate}
class PagedController<Page, Item> extends ValueNotifier<Paged<Page, Item>> {
  /// {@macro paged_controller}
  /// 
  /// [value] is the initial state of the controller, useful in restoring pagination from cache or serialized state.
  /// 
  /// [showLog] is whether debug logs are enabled.
  /// 
  /// [getNextPage] is the function that returns the next page key based on current pagination state.
  /// 
  /// [fetchPage] is the function that asynchronously returns a list of items for a given page key.
  PagedController({
    Paged<Page, Item>? value,
    bool showLog = false,
    required _NextPageCallback<Page, Item> getNextPage,
    required _PagedAsyncCallback<Page, Item> fetchPage,
  })  : _getNextPage = getNextPage, _fetchPage = fetchPage, super(value ?? Paged<Page, Item>(showLog: showLog));

  final _NextPageCallback<Page, Item> _getNextPage;
  final _PagedAsyncCallback<Page, Item> _fetchPage;

  /// Flattened list of all fetched items.
  ///
  /// This is often used to build item UIs directly:
  /// ```dart
  /// ListView.builder(
  ///   itemCount: controller.itemList?.length ?? 0,
  ///   itemBuilder: (context, i) => Text(controller.itemList![i].name),
  /// );
  /// ```
  List<Item>? get itemList => value.items;

  /// A map of each fetched page and its item list.
  Map<Page, List<Item>>? get pages => value.pages;

  /// Error encountered during the last fetch attempt.
  ///
  /// Useful for showing retry prompts:
  /// ```dart
  /// if (controller.error != null) {
  ///   return ErrorCard(error: controller.error);
  /// }
  /// ```
  dynamic get error => value.error;

  /// Key for the next page to load.
  ///
  /// Null indicates that there are no more pages.
  Page? get nextPage => value.nextPage;

  /// Key for the last successfully loaded page.
  Page? get previousPage => value.previousPage;

  /// Whether debug logs are enabled.
  bool get showLog => value.showLog;

  /// A log prefix used in `console.log` for clarity.
  String get LOG_CONTEXT => "[PAGED CONTROLLER: ${Item}]";

  /// Internal operation tracking object.
  ///
  /// Avoid direct access; use `fetchNextPage()` or `cancel()` instead.
  @protected
  @visibleForTesting
  Object? operation;

  /// Loads the next page of data.
  ///
  /// No-op if a fetch is already in progress or all pages are loaded.
  ///
  /// Internally:
  /// - It computes the next page key via [_getNextPage].
  /// - It calls [_fetchPage] with that key.
  /// - Appends the result into the existing state.
  ///
  /// Example:
  /// ```dart
  /// controller.fetchNextPage();
  /// ```
  void fetchNextPage() async {
    if (operation != null) return;
    final currentOp = operation = Object();

    if (showLog) console.log("Starting page request", tag: LOG_CONTEXT);
    value = value.copyWith(isLoading: true, error: null);

    Paged<Page, Item> state = value;

    try {
      if (!state.hasNextPage) {
        if (showLog) console.log("No more pages to load", tag: LOG_CONTEXT);
        return;
      }

      final nextKey = _getNextPage(state);
      if (nextKey == null) {
        if (showLog) console.log("Reached end of pagination", tag: LOG_CONTEXT);
        value = value.copyWith(nextPage: null);
        return;
      }

      if (showLog) console.log("Fetching page for key: $nextKey", tag: LOG_CONTEXT);
      final result = _fetchPage(nextKey);

      final List<Item> newItems = result is Future ? await result : result;

      state = value; // Refresh state in case it was changed during fetch
      state = state.copyWith(
        pages: {
          ...?state.pages,
          nextKey: newItems,
        },
        nextPage: nextKey,
      );

      if (showLog) console.log("Fetched ${newItems.length} items for $nextKey", tag: LOG_CONTEXT);
    } catch (error) {
      if (showLog) console.log("Error fetching page: $error", tag: LOG_CONTEXT);
      state = state.copyWith(error: error);
      if (error is! Exception) rethrow;
    } finally {
      if (currentOp == operation) {
        value = state.copyWith(isLoading: false);
        operation = null;
      }
      if (showLog) console.log("Finished page request", tag: LOG_CONTEXT);
    }
  }

  /// Resets the state to the initial value and cancels any ongoing operation.
  ///
  /// Use this to restart pagination (e.g. after a pull-to-refresh).
  ///
  /// Example:
  /// ```dart
  /// controller.refresh();
  /// controller.fetchNextPage(); // Load first page again
  /// ```
  void refresh() {
    operation = null;
    if (showLog) console.log("Refreshing paged controller", tag: LOG_CONTEXT);
    value = value.reset();
  }

  /// Cancels any active fetch operation and marks the controller as not loading.
  ///
  /// Example:
  /// ```dart
  /// controller.cancel(); // Call before triggering manual refresh
  /// controller.fetchNextPage();
  /// ```
  void cancel() {
    operation = null;
    if (showLog) console.log("Cancelling page request", tag: LOG_CONTEXT);
    value = value.copyWith(isLoading: false);
  }

  @override
  void dispose() {
    operation = null;
    super.dispose();
  }
}