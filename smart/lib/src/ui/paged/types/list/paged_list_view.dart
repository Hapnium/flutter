import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/utilities.dart' show WidgetUtils;
import 'package:smart/enums.dart' show PagedStatus;

import '../../../export.dart';
import '../../helpers/paged_helper.dart';

part 'paged_list_view_state.dart';

const Widget _defaultSpacing = const SizedBox.shrink();

/// A scrollable list view that supports pagination.
///
/// `PagedListView` automatically handles fetching, displaying, and paginating
/// data using a [PagedController]. It supports vertical and horizontal scrolling
/// and provides various customization options.
///
/// - [Page] represents the type of key used for pagination.
/// - [Item] represents the type of data displayed in the list.
///
/// **Purpose:**
///
/// The [PagedListView] widget simplifies the creation of paginated lists by
/// abstracting the complexities of data fetching and display. It provides
/// a flexible and efficient way to load and render large datasets in a
/// scrollable list view.
///
/// **Usage:**
///
/// Use [PagedListView] to create a scrollable list that fetches and displays
/// data in pages. Provide a [PagedController] to manage the pagination logic
/// and a [PagedChildBuilderDelegate] to define how list items are built.
///
/// **Example:**
///
/// ```dart
/// PagedListView<int, Item>(
///   controller: _pagedController,
///   builderDelegate: PagedChildBuilderDelegate<Item>(
///     itemBuilder: (context, item, index) => ListTile(title: Text(item.title)),
///   ),
/// )
/// ```
///
/// **Customization:**
///
/// You can customize the appearance and behavior of the [PagedListView] by
/// providing a custom [ScrollController], [PagedChildBuilderDelegate], and
/// [PagedController]. The [PagedChildBuilderDelegate] allows you to define
/// how list items are built, while the [PagedController] manages the
/// pagination logic.
///
/// **Separated Lists:**
///
/// Use the [.separated] constructor to create a [PagedListView] with separators
/// between items. This constructor requires a [separatorBuilder] to define
/// how separators are built.
///
/// **Note:**
///
/// The [PagedListView] widget is a specialized version of the [ListView] widget
/// that integrates with the [PagedController] for pagination support.
class PagedListView<Page, Item> extends StatefulWidget {
  /// The controller responsible for managing pagination.
  final PagedController<Page, Item> controller;

  /// The builder delegate used to create list items.
  final PagedChildBuilderDelegate<Item> builderDelegate;

  /// The axis along which the list scrolls. Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the list is reversed (i.e., starts from the bottom).
  final bool reverse;

  /// The scroll controller used to manage scrolling.
  final ScrollController? scrollController;

  /// Whether this is the primary scroll view associated with user input.
  final bool? primary;

  /// Defines the scroll physics for the list.
  final ScrollPhysics? physics;

  /// Whether the list should shrink to fit its children.
  final bool shrinkWrap;

  /// The padding around the list.
  final EdgeInsetsGeometry? padding;

  /// The fixed extent for each item in the list.
  final double? itemExtent;

  /// Whether to automatically keep items alive.
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries around items.
  final bool addRepaintBoundaries;

  /// Whether to add semantic indexes for accessibility.
  final bool addSemanticIndexes;

  /// The number of pixels to cache for preloading items.
  final double? cacheExtent;

  /// The number of children for semantic accessibility.
  final int? semanticChildCount;

  /// Defines the behavior when a drag starts.
  final DragStartBehavior dragStartBehavior;

  /// Determines how the keyboard should be dismissed when scrolling.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The restoration ID used to restore scroll position.
  final String? restorationId;

  /// The clipping behavior for the list.
  final Clip clipBehavior;

  /// The builder for separators in `.separated` constructor.
  final IndexedWidgetBuilder? separatorBuilder;

  /// Creates a scrollable, linear array of widgets that are created on demand.
  final ChildIndexGetter? findChildIndexCallback;

  /// Creates a [ScrollView] uses a single child layout model.
  final HitTestBehavior hitTestBehavior;

  /// If non-null, forces the children to have the corresponding extent returned by the builder.
  ///
  // Specifying an itemExtentBuilder is more efficient than letting the children determine their
  // own extent because the scrolling machinery can make use of the foreknowledge of the children's
  // extent to save work, for example when the scroll position changes drastically.
  final ItemExtentBuilder? itemExtentBuilder;

  /// If non-null, forces the children to have the same extent as the given widget in the scroll direction.
  ///
  // Specifying an prototypeItem is more efficient than letting the children determine their own extent because
  // the scrolling machinery can make use of the foreknowledge of the children's extent to save work,
  // for example when the scroll position changes drastically.
  final Widget? prototypeItem;

  /// A strategy function to determine when to show separators.
  final PagedItemSeparatorStrategy? separatorStrategy;

  /// This is the applied spacing between each item in the list
  final Widget spacing;

  /// Whether to apply a separator to the last item.
  final bool applySeparatorToLastItem;

  /// Creates a [PagedListView] with pagination support.
  ///
  /// Use this constructor for a standard paged list without separators.
  const PagedListView.builder({
    super.key,
    required this.controller,
    required this.builderDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.findChildIndexCallback,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.separatorStrategy,
    this.spacing = _defaultSpacing
  }) : separatorBuilder = null, applySeparatorToLastItem = false;

  /// Creates a [PagedListView] with pagination support and separators.
  ///
  /// Use this constructor when a separator is required between items.
  const PagedListView.separated({
    super.key,
    required this.controller,
    required this.builderDelegate,
    required this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.findChildIndexCallback,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.separatorStrategy,
    this.applySeparatorToLastItem = false,
    this.spacing = _defaultSpacing
  }) : itemExtent = null, semanticChildCount = null, itemExtentBuilder = null, prototypeItem = null;

  @override
  State<PagedListView<Page, Item>> createState() => _PagedListViewState<Page, Item>();

  /// Debug properties for [PagedListView].
  ///
  /// This helps in debugging by providing insights into the widget’s properties.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('pagingController', controller));
    properties.add(DiagnosticsProperty('builderDelegate', builderDelegate));
    properties.add(EnumProperty<Axis>('scrollDirection', scrollDirection));
    properties.add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'));
    properties.add(DiagnosticsProperty<ScrollController?>('scrollController', scrollController));
    properties.add(DiagnosticsProperty<bool?>('primary', primary));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(FlagProperty('shrinkWrap', value: shrinkWrap, ifTrue: 'shrinkWrap enabled'));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DoubleProperty('itemExtent', itemExtent));
    properties.add(FlagProperty('addAutomaticKeepAlives', value: addAutomaticKeepAlives, ifTrue: 'keeps alive'));
    properties.add(FlagProperty('addRepaintBoundaries', value: addRepaintBoundaries, ifTrue: 'adds repaint boundaries'));
    properties.add(FlagProperty('addSemanticIndexes', value: addSemanticIndexes, ifTrue: 'adds semantic indexes'));
    properties.add(DoubleProperty('cacheExtent', cacheExtent));
    properties.add(IntProperty('semanticChildCount', semanticChildCount));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(EnumProperty<ScrollViewKeyboardDismissBehavior>('keyboardDismissBehavior', keyboardDismissBehavior));
    properties.add(StringProperty('restorationId', restorationId));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<IndexedWidgetBuilder?>('separatorBuilder', separatorBuilder));
    properties.add(DiagnosticsProperty<ChildIndexGetter?>('findChildIndexCallback', findChildIndexCallback));
    properties.add(EnumProperty<HitTestBehavior>('hitTestBehavior', hitTestBehavior));
    properties.add(DiagnosticsProperty<ItemExtentBuilder?>('itemExtentBuilder', itemExtentBuilder));
    properties.add(DiagnosticsProperty<Widget?>('prototypeItem', prototypeItem));
    properties.add(DiagnosticsProperty<PagedItemSeparatorStrategy?>('separatorStrategy', separatorStrategy));
    properties.add(DiagnosticsProperty<Widget>('spacing', spacing));
    properties.add(FlagProperty('applySeparatorToLastItem', value: applySeparatorToLastItem, ifTrue: 'apply separator to last item'));
  }
}