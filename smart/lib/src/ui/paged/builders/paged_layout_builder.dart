import 'package:flutter/material.dart' hide Page;
import 'package:flutter/rendering.dart';

import '../../export.dart';
import '../builders/paged_listener.dart';

/// A base builder widget for creating paginated scrollable layouts.
///
/// [PagedLayoutBuilder] serves as the foundational widget to build any paged
/// scrollable UI, such as lists, grids, or other custom layouts that require
/// pagination support.
///
/// It handles the core logic of fetching, displaying, and paginating data using
/// a [PagedController], and provides flexible builders for various states 
/// (loading, error, completed).
///
/// This widget does not impose a specific layout; instead, it provides the 
/// paged data and state management, which can then be used by subclasses or 
/// custom builders (e.g., paged list, paged grid) to render the content.
///
/// Generics:
/// - `Page` is the type used as the pagination key.
/// - `Item` is the type of data displayed.
///
/// **Example:**
///
/// ```dart
/// PagedLayoutBuilder<int, Item>(
///   controller: _pagedController,
///   builderDelegate: PagedChildBuilderDelegate<Item>(
///     itemBuilder: (context, item, index) => ListTile(title: Text(item.title)),
///   ),
///   loadingBuilder: (context) => CircularProgressIndicator(),
///   errorBuilder: (context, error) => Text('Error: $error'),
///   completedBuilder: (context) => Text('No more items'),
/// )
/// ```
///
/// Subclasses or other widgets can extend this to create specific paged layouts,
/// such as lists, grids, or other custom scrollable widgets.
class PagedLayoutBuilder<Page, Item> extends StatelessWidget {
  /// The controller responsible for managing pagination state and fetching data.
  final PagedController<Page, Item> controller;

  /// Delegate responsible for building the list items.
  final PagedBuilderDelegate<Item> builderDelegate;

  /// Builder called when the paged data is loading.
  ///
  /// Typically used to show loading indicators.
  final PagedWidgetBuilder loadingBuilder;

  /// Builder called when an error occurs during data fetching.
  ///
  /// Typically used to display error messages or retry options.
  final PagedWidgetBuilder errorBuilder;

  /// Builder called when all data has been successfully loaded.
  ///
  /// Typically used to show a "no more data" message or footer.
  final PagedWidgetBuilder completedBuilder;

  /// Creates a [PagedLayoutBuilder] instance.
  ///
  /// Requires a [controller] to manage pagination and a [builderDelegate] to
  /// build list items. Additionally, [loadingBuilder], [errorBuilder], and
  /// [completedBuilder] must be provided to handle respective states.
  const PagedLayoutBuilder({
    super.key,
    required this.controller,
    required this.builderDelegate,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.completedBuilder,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PagedController<Page, Item>>('pagingController', controller));
    properties.add(DiagnosticsProperty<PagedBuilderDelegate<Item>>('builderDelegate', builderDelegate));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('loadingBuilder', loadingBuilder));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('errorBuilder', errorBuilder));
    properties.add(DiagnosticsProperty<PagedWidgetBuilder>('completedBuilder', completedBuilder));
  }

  @override
  Widget build(BuildContext context) => PagedListener(
    controller: controller,
    builder: (context, state, fetchNextPage) {
      print("DEBUGGING::::::: PAGED LAYOUT BUILDER: State: $state");
      return PagedBuilder<Page, Item>(
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: builderDelegate,
        completedBuilder: completedBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
      );
    },
  );
}