import 'package:flutter/material.dart';

import '../../export.dart';

/// {@template paged_listener}
/// A widget that listens to a [PagedController] and rebuilds whenever the pagination state changes.
///
/// This is useful for integrating pagination logic (loading, errors, new items)
/// with custom UI widgets.
///
/// It uses a [ValueListenableBuilder] internally to react to changes in the [PagedController].
///
/// ### Example:
/// ```dart
/// PagedListener<int, Product>(
///   controller: controller,
///   builder: (context, state, fetchNextPage) {
///     if (state.isLoading && state.items == null) {
///       return Center(child: CircularProgressIndicator());
///     }
///
///     if (state.error != null) {
///       return Center(child: Text('Error: ${state.error}'));
///     }
///
///     final items = state.items ?? [];
///     return ListView.builder(
///       itemCount: items.length + 1,
///       itemBuilder: (context, index) {
///         if (index == items.length) {
///           // Fetch more items when reaching the end
///           fetchNextPage();
///           return const Padding(
///             padding: EdgeInsets.all(16.0),
///             child: Center(child: CircularProgressIndicator()),
///           );
///         }
///
///         final product = items[index];
///         return ListTile(title: Text(product.name));
///       },
///     );
///   },
/// )
/// ```
/// {@endtemplate}
class PagedListener<Page, Item> extends StatelessWidget {
  /// {@macro paged_listener}
  const PagedListener({
    super.key,
    required this.controller,
    required this.builder,
  });

  /// The [PagedController] that holds the paginated state and notifies listeners when changed.
  final PagedController<Page, Item> controller;

  /// Called every time the controller's value changes.
  ///
  /// This function provides:
  /// - [context] - The build context
  /// - [state] - The current paginated state from the controller
  /// - [fetchNextPage] - A function you can call to trigger the next page fetch
  final Widget Function(BuildContext context, Paged<Page, Item> state, VoidCallback fetchNextPage) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Paged<Page, Item>>(
      valueListenable: controller,
      builder: (context, state, _) => builder(context, state, controller.fetchNextPage),
    );
  }
}