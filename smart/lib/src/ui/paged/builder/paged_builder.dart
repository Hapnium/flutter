import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';
import 'package:smart/extensions.dart';

import '../helpers/listenable_listener.dart';
import '../helpers/paged_helper.dart';
import '../helpers/status_builders/new_page_indicators.dart';
import '../helpers/status_builders/no_items_found_indicators.dart';
import '../helpers/status_builders/first_page_indicators.dart';
import '../../export.dart';

part 'paged_builder_state.dart';

/// A scrollable list view that supports pagination.
///
/// [PagedBuilder] automatically handles fetching, displaying, and paginating
/// data using a [PagedController]. It supports vertical and horizontal scrolling
/// and provides various customization options.
///
/// - [PageKeyType] represents the type of key used for pagination.
/// - [ItemType] represents the type of data displayed in the list.
///
/// **Purpose:**
///
/// The [PagedBuilder] widget is designed to simplify the implementation of
/// paginated lists by abstracting the complexities of data fetching and
/// display. It provides a flexible and efficient way to load and render
/// large datasets in a scrollable view.
///
/// **Usage:**
///
/// Use [PagedBuilder] to create a scrollable list that fetches and displays
/// data in pages. Provide a [PagedController] to manage the pagination logic
/// and a [PagedChildBuilderDelegate] to define how list items are built.
///
/// **Example:**
///
/// ```dart
/// PagedBuilder<int, Item>(
///   controller: _pagedController,
///   builderDelegate: PagedChildBuilderDelegate<Item>(
///     itemBuilder: (context, item, index) => ListTile(title: Text(item.title)),
///   ),
///   childBuilder: (itemCount, itemBuilder) => ListView.builder(
///     itemCount: itemCount,
///     itemBuilder: itemBuilder
///   ),
/// )
/// ```
///
/// **Customization:**
///
/// You can customize the appearance and behavior of the [PagedBuilder] by
/// providing a custom [ScrollController], [PagedChildBuilderDelegate], and
/// [PagedController]. The [PagedChildBuilderDelegate] allows you to define
/// how list items are built, while the [PagedController] manages the
/// pagination logic.
///
/// **Note:**
///
/// The [PagedBuilder] serves as a base class that can be used to build other
/// list views like [ListView], [GridView], and more. It provides a flexible
/// and extensible way to create paginated lists in Flutter.
class PagedBuilder<PageKeyType, ItemType> extends StatefulWidget {
  /// The controller responsible for managing pagination.
  final PagedController<PageKeyType, ItemType> controller;

  /// The builder delegate used to create list items.
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// A builder function to create the scrollable widget (e.g., ListView, GridView).
  final PagedChildBuilder<PageKeyType, ItemType> childBuilder;

  /// Creates a [PagedBuilder] with pagination support.
  ///
  /// Use this constructor for a standard paged list without separators.
  const PagedBuilder({
    super.key,
    required this.controller,
    required this.builderDelegate,
    required this.childBuilder,
  });

  @override
  State<PagedBuilder<PageKeyType, ItemType>> createState() => _PagedBuilderState<PageKeyType, ItemType>();

  /// Debug properties for [PagedBuilder].
  ///
  /// This helps in debugging by providing insights into the widget’s properties.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('controller', controller));
    properties.add(DiagnosticsProperty('builderDelegate', builderDelegate));
    properties.add(DiagnosticsProperty<PagedChildBuilder<PageKeyType, ItemType>>('childBuilder', childBuilder));
  }
}