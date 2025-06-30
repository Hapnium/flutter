import 'dart:math';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';
import 'package:smart/extensions.dart';

import '../indicators/new_page_indicators.dart';
import '../indicators/no_items_found_indicators.dart';
import '../indicators/first_page_indicators.dart';
import '../../export.dart';
import 'paged_builder_animator.dart';

part 'paged_builder_state.dart';

/// Signature for a callback that triggers the fetching of the next page of data.
///
/// Typically used in paginated list views to load more data when the user
/// scrolls near the end of the current list.
typedef NextPageCallback = VoidCallback;

/// Signature for building a widget that handles various paging states such as
/// loading, error, or completed.
///
/// This builder is responsible for rendering the list items using [itemBuilder],
/// along with an optional widget (like a loading indicator or error message)
/// after the last item.
///
/// Parameters:
/// - [context]: The build context.
/// - [index]: The total number of items to build (excluding the optional widget).
/// - [widgetBuilder]: A builder for an optional widget (e.g., loading indicator).
/// - [itemBuilder]: A builder for individual list items at a given index.
typedef PagedWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  WidgetBuilder? widgetBuilder,
  IndexedWidgetBuilder itemBuilder,
);

/// {@template paged_builder}
/// A highly customizable widget for building paginated scrollable views in Flutter.
///
/// The [PagedBuilder] widget is the core abstraction for displaying lists of items
/// with pagination support. It interacts with a [PagedController] and a [Paged] model
/// to manage data fetching, loading indicators, errors, and "no more items" state.
///
/// ---
///
/// ### Example:
///
/// ```dart
/// final controller = PagedController<int, Item>(
///   getNextPageKey: (state) => state.nextPage == null ? 1 : state.nextPage! + 1,
///   fetchPageAsync: (page) => repository.fetchItems(page),
/// );
///
/// PagedListener<int, Item>(
///   controller: controller,
///   builder: (context, state, fetchNextPage) {
///     return PagedBuilder<int, Item>(
///       paged: state,
///       fetchNextPage: fetchNextPage,
///       builderDelegate: PagedBuilderDelegate<Item>(
///         itemBuilder: (context, item, index) => ListTile(title: Text(item.name)),
///       ),
///       loadingBuilder: (context, itemBuilder, itemCount, noMoreBuilder) =>
///           ListView.builder(
///             itemCount: itemCount + 1,
///             itemBuilder: (context, index) {
///               if (index == itemCount) return CircularProgressIndicator();
///               return itemBuilder(context, index);
///             },
///           ),
///       errorBuilder: (context, itemBuilder, itemCount, _) =>
///           Center(child: Text('Failed to load data.')),
///       completedBuilder: (context, itemBuilder, itemCount, noMoreBuilder) =>
///           ListView.builder(
///             itemCount: itemCount,
///             itemBuilder: itemBuilder,
///           ),
///     );
///   },
/// );
/// ```
///
/// ---
///
/// ### Customization
/// - Pass different builders for `loadingBuilder`, `errorBuilder`, and `completedBuilder`
///   to fully control the UI at different stages of pagination.
/// - Use `PagedBuilderDelegate` to define how each item is built, and which
///   loading or error indicators to show.
///
/// ---
///
/// ### Generics
/// - `Page`: The type used as a key to identify each page (e.g. `int`, `String`, or `CursorObject`)
/// - `Item`: The type of each item displayed in the list (e.g. `Product`, `User`)
///
/// {@endtemplate}
class PagedBuilder<Page, Item> extends StatefulWidget {
  /// The paginated state including items, error, page info, etc.
  /// 
  /// The current paginated state, usually passed from a [PagedListener].
  final Paged<Page, Item> paged;

  /// Callback triggered to fetch the next page.
  /// 
  /// This callback is triggered when the user scrolls to the end of the list.
  final NextPageCallback fetchNextPage;

  /// Delegate that defines how to build each item and various indicator widgets.
  /// 
  /// Provides builders for items and optional indicators.
  final PagedBuilderDelegate<Item> builderDelegate;

  /// Called when the paged state is loading.
  /// 
  /// This builder is called when the paged state is loading.
  final PagedWidgetBuilder loadingBuilder;

  /// Called when an error occurs while fetching data.
  /// 
  /// This builder is called when an error occurs while fetching data.
  final PagedWidgetBuilder errorBuilder;

  /// Called when data loading is completed successfully.
  /// 
  /// This builder is called when data loading is completed successfully.
  final PagedWidgetBuilder completedBuilder;

  /// {@macro paged_builder}
  const PagedBuilder({
    super.key,
    required this.paged,
    required this.fetchNextPage,
    required this.builderDelegate,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.completedBuilder,
  });

  @override
  State<PagedBuilder<Page, Item>> createState() => _PagedBuilderState<Page, Item>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('paged', paged));
    properties.add(DiagnosticsProperty('fetchNextPage', fetchNextPage));
    properties.add(DiagnosticsProperty('builderDelegate', builderDelegate));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('loadingBuilder', loadingBuilder));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('errorBuilder', errorBuilder));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('completedBuilder', completedBuilder));
  }
}