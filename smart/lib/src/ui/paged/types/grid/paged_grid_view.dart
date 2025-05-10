import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart' show PagedStatus;
import 'package:smart/utilities.dart' show WidgetUtils;
import 'package:smart/extensions.dart';

import '../../../export.dart';
import '../../helpers/paged_helper.dart';
import '../../helpers/status_builders/new_page_indicators.dart';

part 'paged_grid_view_state.dart';

/// A scrollable grid view that supports pagination.
///
/// [PagedGridView] automatically handles fetching, displaying, and paginating
/// data using a [PagedController]. It supports vertical and horizontal scrolling
/// and provides various customization options.
///
/// - [PageKeyType] represents the type of key used for pagination.
/// - [ItemType] represents the type of data displayed in the grid.
///
/// **Purpose:**
///
/// The [PagedGridView] widget simplifies the creation of paginated grid views by
/// abstracting the complexities of data fetching and display. It provides
/// a flexible and efficient way to load and render large datasets in a
/// scrollable grid view.
///
/// **Usage:**
///
/// Use [PagedGridView] to create a scrollable grid that fetches and displays
/// data in pages. Provide a [PagedController] to manage the pagination logic,
/// a [SliverGridDelegate] to define the grid layout, and a
/// [PagedChildBuilderDelegate] to define how grid items are built.
///
/// **Example:**
///
/// ```dart
/// PagedGridView<int, Item>(
///   controller: _pagedController,
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
///   builderDelegate: PagedChildBuilderDelegate<Item>(
///     itemBuilder: (context, item, index) => GridTile(child: Text(item.title)),
///   ),
/// )
/// ```
///
/// **Customization:**
///
/// You can customize the appearance and behavior of the [PagedGridView] by
/// providing a custom [ScrollController], [SliverGridDelegate],
/// [PagedChildBuilderDelegate], and [PagedController]. The
/// [PagedChildBuilderDelegate] allows you to define how grid items are built,
/// while the [PagedController] manages the pagination logic.
///
/// **Separated Grids:**
///
/// Use the [.separated] constructor to create a [PagedGridView] with separators
/// between items. This constructor requires a [separatorBuilder] to define
/// how separators are built.
///
/// **Note:**
///
/// The [PagedGridView] widget is a specialized version of the [GridView] widget
/// that integrates with the [PagedController] for pagination support.
class PagedGridView<PageKeyType, ItemType> extends StatefulWidget {
  /// A delegate that controls the layout of the children within the PagedGridView.
  ///
  /// The [PagedGridView].builder, and [PagedGridView].separator constructors let you
  /// specify this delegate explicitly. The other constructors create a gridDelegate implicitly.
  final SliverGridDelegate gridDelegate;

  /// The controller responsible for managing pagination.
  final PagedController<PageKeyType, ItemType> controller;

  /// The builder delegate used to create list items.
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

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

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [AxisDirection] determined
  /// by [scrollDirection] and [reverse] relative to the [center]. Children
  /// before [center] will be placed in the opposite of the axis direction
  /// relative to the [center]. This makes the [center] the inflection point of
  /// the growth direction.
  ///
  /// The [center] must be the key of one of the slivers built by [buildSlivers].
  ///
  /// Of the built-in subclasses of [ScrollView], only [CustomScrollView]
  /// supports [center]; for that class, the given key must be the key of one of
  /// the slivers in the [CustomScrollView.slivers] list.
  ///
  /// Most scroll views by default are ordered [GrowthDirection.forward].
  /// Changing the default values of [ScrollView.anchor],
  /// [ScrollView.center], or both, can configure a scroll view for
  /// [GrowthDirection.reverse].
  ///
  /// {@tool dartpad}
  /// This sample shows a [CustomScrollView], with [Radio] buttons in the
  /// [AppBar.bottom] that change the [AxisDirection] to illustrate different
  /// configurations. The [CustomScrollView.anchor] and [CustomScrollView.center]
  /// properties are also set to have the 0 scroll offset positioned in the middle
  /// of the viewport, with [GrowthDirection.forward] and [GrowthDirection.reverse]
  /// illustrated on either side. The sliver that shares the
  /// [CustomScrollView.center] key is positioned at the [CustomScrollView.anchor].
  ///
  /// ** See code in examples/api/lib/rendering/growth_direction/growth_direction.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [anchor], which controls where the [center] as aligned in the viewport.
  final Key? center;

  /// The relative position of the zero scroll offset.
  ///
  /// For example, if [anchor] is 0.5 and the [AxisDirection] determined by
  /// [scrollDirection] and [reverse] is [AxisDirection.down] or
  /// [AxisDirection.up], then the zero scroll offset is vertically centered
  /// within the viewport. If the [anchor] is 1.0, and the axis direction is
  /// [AxisDirection.right], then the zero scroll offset is on the left edge of
  /// the viewport.
  ///
  /// Most scroll views by default are ordered [GrowthDirection.forward].
  /// Changing the default values of [ScrollView.anchor],
  /// [ScrollView.center], or both, can configure a scroll view for
  /// [GrowthDirection.reverse].
  ///
  /// {@tool dartpad}
  /// This sample shows a [CustomScrollView], with [Radio] buttons in the
  /// [AppBar.bottom] that change the [AxisDirection] to illustrate different
  /// configurations. The [CustomScrollView.anchor] and [CustomScrollView.center]
  /// properties are also set to have the 0 scroll offset positioned in the middle
  /// of the viewport, with [GrowthDirection.forward] and [GrowthDirection.reverse]
  /// illustrated on either side. The sliver that shares the
  /// [CustomScrollView.center] key is positioned at the [CustomScrollView.anchor].
  ///
  /// ** See code in examples/api/lib/rendering/growth_direction/growth_direction.0.dart **
  /// {@end-tool}
  final double anchor;

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
  final NullableIndexedWidgetBuilder? separatorBuilder;

  final ScrollBehavior? scrollBehavior;

  /// Creates a [ScrollView] uses a single child layout model.
  final HitTestBehavior hitTestBehavior;

  /// A strategy function to determine when to show separators.
  final PagedItemSeparatorStrategy? separatorStrategy;

  /// Whether to automatically keep items alive.
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries around items.
  final bool addRepaintBoundaries;

  /// Whether to add semantic indexes for accessibility.
  final bool addSemanticIndexes;

  /// Creates a scrollable, linear array of widgets that are created on demand.
  final ChildIndexGetter? findChildIndexCallback;

  /// Whether to apply a separator to the last item.
  final bool applySeparatorToLastItem;

  /// Creates a [PagedGridView] with pagination support.
  ///
  /// Use this constructor for a standard paged list without separators.
  const PagedGridView.builder({
    super.key,
    required this.controller,
    required this.gridDelegate,
    required this.builderDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
  }) : separatorBuilder = null, separatorStrategy = null, applySeparatorToLastItem = false;

  /// Creates a [PagedGridView] with pagination support and separators.
  ///
  /// Use this constructor when a separator is required between items.
  const PagedGridView.separated({
    super.key,
    required this.controller,
    required this.builderDelegate,
    required this.separatorBuilder,
    required this.gridDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.separatorStrategy,
    this.addAutomaticKeepAlives = true,
    this.applySeparatorToLastItem = false,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
  }) : semanticChildCount = null;

  @override
  State<PagedGridView<PageKeyType, ItemType>> createState() => _PagedGridViewState<PageKeyType, ItemType>();

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
    properties.add(DiagnosticsProperty<Key?>('center', center));
    properties.add(DoubleProperty('anchor', anchor));
    properties.add(DoubleProperty('cacheExtent', cacheExtent));
    properties.add(IntProperty('semanticChildCount', semanticChildCount));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
    properties.add(EnumProperty<ScrollViewKeyboardDismissBehavior>('keyboardDismissBehavior', keyboardDismissBehavior));
    properties.add(StringProperty('restorationId', restorationId));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
    properties.add(DiagnosticsProperty<NullableIndexedWidgetBuilder?>('separatorBuilder', separatorBuilder));
    properties.add(DiagnosticsProperty<ScrollBehavior?>('scrollBehavior', scrollBehavior));
    properties.add(EnumProperty<HitTestBehavior>('hitTestBehavior', hitTestBehavior));
    properties.add(DiagnosticsProperty<SliverGridDelegate>('gridDelegate', gridDelegate));
    properties.add(DiagnosticsProperty<PagedItemSeparatorStrategy?>('separatorStrategy', separatorStrategy));
    properties.add(FlagProperty('addAutomaticKeepAlives', value: addAutomaticKeepAlives, ifTrue: 'keeps alive'));
    properties.add(FlagProperty('addRepaintBoundaries', value: addRepaintBoundaries, ifTrue: 'adds repaint boundaries'));
    properties.add(FlagProperty('addSemanticIndexes', value: addSemanticIndexes, ifTrue: 'adds semantic indexes'));
    properties.add(DiagnosticsProperty<ChildIndexGetter?>('findChildIndexCallback', findChildIndexCallback));
    properties.add(FlagProperty('applySeparatorToLastItem', value: applySeparatorToLastItem, ifTrue: 'apply separator to last item'));
  }
}