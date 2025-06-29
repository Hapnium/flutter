part of 'paged_list_view.dart';

class _PagedListViewState<Page, Item> extends State<PagedListView<Page, Item>> {
  late final ScrollController _scrollController;

  @protected
  IndexedWidgetBuilder? get separatorBuilder => widget.separatorBuilder;

  @protected
  PagedItemSeparatorStrategy get strategy => widget.separatorStrategy ?? PagedHelper.defaultStrategy;

  @protected
  Widget get spacing => widget.spacing;

  @protected
  Widget child(BuildContext context, int index, IndexedWidgetBuilder childItemBuilder) {
    if(WidgetUtils.hasContent(spacing)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          childItemBuilder(context, index),
          spacing,
        ]
      );
    } else {
      return childItemBuilder(context, index);
    }
  }

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PagedListView<Page, Item> oldWidget) {
    if (oldWidget.scrollController != widget.scrollController) {
      setState(() {});
    } else if(oldWidget.separatorBuilder.notEquals(widget.separatorBuilder) || oldWidget.separatorStrategy.notEquals(widget.separatorStrategy)) {
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.scrollController.isNull) {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedBuilder<Page, Item>(
      controller: widget.controller,
      builderDelegate: widget.builderDelegate,
      childBuilder: (int itemCount, PagedStatus _, Boolean _b, IndexedWidgetBuilder childItemBuilder) {
        if(separatorBuilder.isNotNull) {
          return ListView.separated(
            controller: _scrollController,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            separatorBuilder: (context, index) {
              final isLast = index == itemCount - 1;
              final shouldApply = strategy(index) && (widget.applySeparatorToLastItem || !isLast);

              if (shouldApply) {
                return child(context, index, separatorBuilder!);
              } else {
                return spacing;
              }
            },
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            hitTestBehavior: widget.hitTestBehavior,
            findChildIndexCallback: widget.findChildIndexCallback,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return child(context, index, childItemBuilder);
            },
          );
        } else {
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemExtent: widget.itemExtent,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            hitTestBehavior: widget.hitTestBehavior,
            findChildIndexCallback: widget.findChildIndexCallback,
            itemExtentBuilder: widget.itemExtentBuilder,
            prototypeItem: widget.prototypeItem,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return child(context, index, childItemBuilder);
            },
          );
        }
      }
    );
  }
}