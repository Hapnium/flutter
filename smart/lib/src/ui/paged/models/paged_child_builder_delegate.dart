import 'package:flutter/cupertino.dart';

import '../../export.dart';

/// A delegate for building paginated list items and indicators.
///
/// This class provides various builder functions to handle different states
/// in a paginated list, such as loading indicators, error messages, and empty states.
///
/// [ItemType] - The type of the items displayed in the list.
class PagedChildBuilderDelegate<ItemType> {
  /// Builds the widget for an individual item in the list.
  ///
  /// This function is required and is used to generate the UI for each list item.
  final ItemWidgetBuilder<ItemType> itemBuilder;

  /// Builds the progress indicator widget for the first page when loading.
  ///
  /// If `null`, no default loading indicator will be displayed.
  final WidgetBuilder? firstPageProgressIndicatorBuilder;

  /// Builds the progress indicator widget when a new page is being loaded.
  ///
  /// If `null`, no default loading indicator will be displayed for new pages.
  final WidgetBuilder? newPageProgressIndicatorBuilder;

  /// Builds the error indicator widget when the first page fails to load.
  ///
  /// If `null`, no default error message will be displayed.
  final WidgetBuilder? firstPageErrorIndicatorBuilder;

  /// Builds the error indicator widget when a new page fails to load.
  ///
  /// If `null`, no default error message will be displayed for new pages.
  final WidgetBuilder? newPageErrorIndicatorBuilder;

  /// Builds the indicator widget when no items are found in the list.
  ///
  /// If `null`, no default "no items found" message will be displayed.
  final WidgetBuilder? noItemsFoundIndicatorBuilder;

  /// Builds the indicator widget when no more items are available to load.
  ///
  /// If `null`, no default "no more items" message will be displayed.
  final WidgetBuilder? noMoreItemsIndicatorBuilder;

  /// Creates a new [PagedChildBuilderDelegate] with the specified builder functions.
  ///
  /// The [itemBuilder] is required, while other indicator builders are optional.
  const PagedChildBuilderDelegate({
    required this.itemBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
  });
}