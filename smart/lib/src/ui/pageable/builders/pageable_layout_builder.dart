import 'package:flutter/material.dart';

import '../controller/pageable_controller.dart';
import '../models/pageable_builder_delegate.dart';
import 'pageable_builder.dart';
import 'pageable_listener.dart';

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
typedef PageableWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  WidgetBuilder? widgetBuilder,
  IndexedWidgetBuilder itemBuilder,
);

/// {@template pageable_layout_builder}
/// A base builder widget for creating paginated scrollable layouts.
///
/// [PageableLayoutBuilder] serves as the foundational widget to build any paged
/// scrollable UI, such as lists, grids, or other custom layouts that require
/// pagination support.
///
/// It handles the core logic of fetching, displaying, and paginating data using
/// a [PageableController], and provides flexible builders for various states 
/// (loading, error, completed).
///
/// This widget does not impose a specific layout; instead, it provides the 
/// paged data and state management, which can then be used by subclasses or 
/// custom builders (e.g., paged list, paged grid) to render the content.
///
/// Generics:
/// - `PageKey` is the type used as the pagination key.
/// - `Item` is the type of data displayed.
///
/// **Example:**
///
/// ```dart
/// PageableLayoutBuilder<int, Item>(
///   controller: _pageableController,
///   builderDelegate: PageableBuilderDelegate<Item>(
///     itemBuilder: (context, item, index) => ListTile(title: Text(item.title)),
///   ),
///   loadingBuilder: (context, itemCount, indicatorBuilder, itemBuilder) => 
///     ListView.builder(itemCount: itemCount + 1, itemBuilder: itemBuilder),
///   errorBuilder: (context, itemCount, indicatorBuilder, itemBuilder) => 
///     ListView.builder(itemCount: itemCount + 1, itemBuilder: itemBuilder),
///   completedBuilder: (context, itemCount, indicatorBuilder, itemBuilder) => 
///     ListView.builder(itemCount: itemCount + 1, itemBuilder: itemBuilder),
/// )
/// ```
///
/// Subclasses or other widgets can extend this to create specific paged layouts,
/// such as lists, grids, or other custom scrollable widgets.
/// 
/// {@endtemplate}
class PageableLayoutBuilder<PageKey, Item> extends StatelessWidget {
  /// The controller responsible for managing pagination state and fetching data.
  final PageableController<PageKey, Item> controller;

  /// Delegate responsible for building the list items.
  final PageableBuilderDelegate<Item> builderDelegate;

  /// Builder called when the paged data is loading more items.
  ///
  /// Receives:
  /// - context: Build context
  /// - itemCount: Number of items currently loaded
  /// - indicatorBuilder: Builder for loading indicator (can be null)
  /// - itemBuilder: Builder for individual items
  final PageableWidgetBuilder loadingBuilder;

  /// Builder called when an error occurs during data fetching.
  ///
  /// Receives:
  /// - context: Build context
  /// - itemCount: Number of items currently loaded
  /// - indicatorBuilder: Builder for error indicator (can be null)
  /// - itemBuilder: Builder for individual items
  final PageableWidgetBuilder errorBuilder;

  /// Builder called when all data has been successfully loaded.
  ///
  /// Receives:
  /// - context: Build context
  /// - itemCount: Number of items currently loaded
  /// - indicatorBuilder: Builder for completion indicator (can be null)
  /// - itemBuilder: Builder for individual items
  final PageableWidgetBuilder completedBuilder;

  /// Creates a [PageableLayoutBuilder] instance.
  ///
  /// Requires a [controller] to manage pagination and a [builderDelegate] to
  /// build list items. Additionally, [loadingBuilder], [errorBuilder], and
  /// [completedBuilder] must be provided to handle respective states.
  /// 
  /// {@macro pageable_layout_builder}
  const PageableLayoutBuilder({
    super.key,
    required this.controller,
    required this.builderDelegate,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.completedBuilder,
  });

  @override
  Widget build(BuildContext context) => PageableListener(
    controller: controller,
    builder: (context, controller) => PageableBuilder<PageKey, Item>(
      controller: controller,
      builderDelegate: builderDelegate,
      completedBuilder: completedBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    ),
  );
}