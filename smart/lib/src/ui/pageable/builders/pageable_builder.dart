import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/ui.dart' show ItemMetadata;

import '../models/pageable.dart';
import '../models/pageable_status.dart';
import '../models/pageable_builder_delegate.dart';
import 'pageable_builder_animator.dart';
import 'pageable_indicators.dart';

/// Signature for layout builders that receive the total item count,
/// an optional indicator builder, and the item builder.
///
/// Used to build a paginated list/grid UI with optional loading or error indicators.
///
/// Parameters:
/// - [context]: The build context.
/// - [itemCount]: The total number of items to be displayed.
/// - [indicatorBuilder]: Optional builder for loading/error indicators, may be null.
/// - [itemBuilder]: Builder for individual items given their index.
///
/// Returns a [Widget] representing the entire pageable layout.
///
/// Example:
/// ```dart
/// PageableStatusWidgetBuilder<MyItem> builder = (context, itemCount, indicatorBuilder, itemBuilder) {
///   return ListView.builder(
///     itemCount: itemCount + (indicatorBuilder != null ? 1 : 0),
///     itemBuilder: (context, index) {
///       if (index == itemCount && indicatorBuilder != null) {
///         return indicatorBuilder(context);
///       }
///       return itemBuilder(context, index);
///     },
///   );
/// };
/// ```
typedef PageableStatusWidgetBuilder<Item> = Widget Function(
  BuildContext context,
  int itemCount,
  WidgetBuilder? indicatorBuilder,
  IndexedWidgetBuilder itemBuilder,
);

/// {@template pageable_builder}
/// Widget that builds UI based on the current [Pageable] state using
/// delegate and layout builder patterns.
///
/// It handles rendering items, loading indicators, error indicators,
/// and completion states in a paginated list or grid.
///
/// Generic parameters:
/// - [PageKey]: The type used for page keys in pagination (e.g., int, String).
/// - [Item]: The type of items being paginated.
///
/// Required parameters:
/// - [pageable]: The current pageable state including loaded pages and metadata.
/// - [fetchFirstPage]: Callback to trigger fetching the first page of items.
/// - [fetchNextPage]: Callback to trigger fetching the next page of items.
/// - [retry]: Callback to retry loading after an error.
/// - [builderDelegate]: Provides [itemBuilder] for items rendering.
/// - [loadingBuilder]: Builds the UI when loading more items (beyond the first page).
/// - [errorBuilder]: Builds the UI when there is an error loading more items.
/// - [completedBuilder]: Builds the UI when all pages are loaded.
///
/// Example usage:
/// ```dart
/// PageableBuilder<int, MyItem>(
///   pageable: pageable,
///   fetchFirstPage: () => controller.fetchFirstPage(),
///   fetchNextPage: () => controller.fetchNextPage(),
///   retry: () => controller.retry(),
///   builderDelegate: MyItemDelegate(),
///   loadingBuilder: myLoadingBuilder,
///   errorBuilder: myErrorBuilder,
///   completedBuilder: myCompletedBuilder,
/// )
/// ```
/// 
/// {@endtemplate}
class PageableBuilder<PageKey, Item> extends StatefulWidget {
  /// The current pageable state holding loaded pages and metadata.
  final Pageable<PageKey, Item> pageable;

  /// Callback to trigger fetching the first page of items.
  final VoidCallback fetchFirstPage;

  /// Callback to trigger fetching the next page of items.
  final VoidCallback fetchNextPage;

  /// Callback to retry loading after an error.
  final VoidCallback retry;

  /// Delegate responsible for building individual item widgets.
  final PageableBuilderDelegate<Item> builderDelegate;

  /// Builder for the loading state when more pages are being loaded.
  final PageableStatusWidgetBuilder<Item> loadingBuilder;

  /// Builder for the error state when loading additional pages fails.
  final PageableStatusWidgetBuilder<Item> errorBuilder;

  /// Builder for the completed state when no more pages are left to load.
  final PageableStatusWidgetBuilder<Item> completedBuilder;

  /// Creates a [PageableBuilder].
  /// 
  /// {@macro pageable_builder}
  const PageableBuilder({
    super.key,
    required this.pageable,
    required this.builderDelegate,
    required this.fetchFirstPage,
    required this.fetchNextPage,
    required this.retry,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.completedBuilder,
  });

  @override
  State<PageableBuilder<PageKey, Item>> createState() => _PageableBuilderState<PageKey, Item>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<Pageable<PageKey, Item>>('pageable', pageable));
    properties.add(DiagnosticsProperty<PageableBuilderDelegate<Item>>('builderDelegate', builderDelegate));
    properties.add(DiagnosticsProperty<PageableStatusWidgetBuilder<Item>>('loadingBuilder', loadingBuilder));
    properties.add(DiagnosticsProperty<PageableStatusWidgetBuilder<Item>>('errorBuilder', errorBuilder));
    properties.add(DiagnosticsProperty<PageableStatusWidgetBuilder<Item>>('completedBuilder', completedBuilder));

    super.debugFillProperties(properties);
  }
}

class _PageableBuilderState<PageKey, Item> extends State<PageableBuilder<PageKey, Item>> {
  /// Avoids duplicate requests on rebuilds
  bool _hasRequestedNextPage = false;

  @protected
  Pageable<PageKey, Item> get value => widget.pageable;

  @protected
  PageableBuilderDelegate<Item> get delegate => widget.builderDelegate;

  @protected
  VoidCallback get fetchNextPage => () => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    widget.fetchNextPage();
  });

  @protected
  WidgetBuilder get firstPageErrorBuilder => delegate.firstPageErrorIndicatorBuilder ?? (_) => FirstPageErrorIndicator(
    onTryAgain: widget.retry,
  );

  @protected
  WidgetBuilder get newPageErrorBuilder => delegate.newPageErrorIndicatorBuilder ?? (_) => NewPageErrorIndicator(
    onTap: widget.retry,
  );

  @protected
  WidgetBuilder get firstPageProgressBuilder => delegate.firstPageProgressIndicatorBuilder ?? (_) => FirstPageProgressIndicator();

  @protected
  WidgetBuilder get newPageProgressBuilder => delegate.newPageProgressIndicatorBuilder ?? (_) => NewPageProgressIndicator();

  @protected
  WidgetBuilder get noItemsFoundBuilder => delegate.noItemsFoundIndicatorBuilder ?? (_) => NoItemsFoundIndicator();

  @protected
  WidgetBuilder get noMoreItemsBuilder => delegate.noMoreItemsIndicatorBuilder ?? (_) => SizedBox.shrink();

  @protected
  ItemWidgetBuilder<Item> get itemBuilder => delegate.itemBuilder;

  @protected
  int get invisibleItemsThreshold => delegate.invisibleItemsThreshold;

  @protected
  List<Item> get list => value.items;

  @protected
  int get itemCount => list.length;

  @protected
  bool get hasNextPage => value.hasNextPage;

  @override
  void didUpdateWidget(covariant PageableBuilder<PageKey, Item> oldWidget) {
    if (oldWidget.pageable != widget.pageable) {
      if (value.status.isLoaded) {
        _hasRequestedNextPage = false;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PageableBuilderAnimator(
      animateTransitions: delegate.animateTransitions,
      transitionDuration: delegate.transitionDuration,
      child: switch (value.status) {
        PageableStatus.LOADING_FIRST_PAGE => firstPageProgressBuilder(context),
        PageableStatus.FIRST_PAGE_ERROR => firstPageErrorBuilder(context),
        PageableStatus.NO_ITEMS_FOUND => noItemsFoundBuilder(context),
        PageableStatus.LOADING_NEW_PAGE => widget.loadingBuilder(
          context,
          itemCount,
          newPageProgressBuilder,
          (context, index) => _buildItem(context, index, list),
        ),
        PageableStatus.NEW_PAGE_ERROR => widget.errorBuilder(
          context,
          itemCount,
          newPageErrorBuilder,
          (context, index) => _buildItem(context, index, list),
        ),
        PageableStatus.COMPLETED || PageableStatus.LOADED_FIRST_PAGE => widget.completedBuilder(
          context,
          itemCount,
          noMoreItemsBuilder,
          (context, index) => _buildItem(context, index, list),
        ),
      },
    );
  }

  /// Builds a list item and triggers page fetching when nearing the end
  Widget _buildItem(BuildContext context, int index, List<Item> items) {
    // Handle indicator at the end
    if (index >= itemCount) {
      return const SizedBox.shrink();
    }

    // Trigger next page fetch when approaching the end
    if (!_hasRequestedNextPage && hasNextPage) {
      final maxIndex = max(0, itemCount - 1);
      final triggerIndex = max(0, maxIndex - invisibleItemsThreshold);
      
      if (index >= triggerIndex) {
        _hasRequestedNextPage = true;
        fetchNextPage();
      }
    }

    ItemMetadata<Item> metadata = ItemMetadata(
      isFirst: index == 0,
      isLast: index == (itemCount - 1),
      index: index,
      totalItems: itemCount,
      item: items[index],
    );

    return itemBuilder(context, metadata);
  }
}