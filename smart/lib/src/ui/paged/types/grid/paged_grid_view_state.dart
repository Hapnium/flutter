part of 'paged_grid_view.dart';

class _PagedGridViewState<PageKeyType, ItemType> extends State<PagedGridView<PageKeyType, ItemType>> {
  late final ScrollController _scrollController;

  @protected
  PagedController<PageKeyType, ItemType> get pagingController => widget.controller;

  @protected
  PagedChildBuilderDelegate<ItemType> get delegate => widget.builderDelegate;

  @protected
  NullableIndexedWidgetBuilder? get separatorBuilder => widget.separatorBuilder;

  @protected
  bool get hasSeparator => separatorBuilder.isNotNull;

  @protected
  PagedItemSeparatorStrategy get strategy => widget.separatorStrategy ?? PagedHelper.defaultStrategy;

  @protected
  WidgetBuilder get newPageErrorBuilder => delegate.newPageErrorIndicatorBuilder ?? (_) => PagedNewPageErrorIndicator(
    onTap: pagingController.retryLastFailedRequest,
  );

  @protected
  WidgetBuilder get newPageProgressBuilder => delegate.newPageProgressIndicatorBuilder ?? (_) => PagedNewPageProgressIndicator();

  @protected
  WidgetBuilder get noMoreItemsBuilder => delegate.noMoreItemsIndicatorBuilder ?? (_) => SizedBox.shrink();

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PagedGridView<PageKeyType, ItemType> oldWidget) {
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
    return PagedBuilder<PageKeyType, ItemType>(
      controller: widget.controller,
      builderDelegate: widget.builderDelegate,
      childBuilder: (int itemCount, PagedStatus status, Boolean showExtra, IndexedWidgetBuilder childItemBuilder) {
        int totalSeparators = hasSeparator
            ? PagedHelper.calculateTotalSeparators(strategy, separatorBuilder, context, itemCount)
            : 0;
        int totalItemCount = (PagedHelper.canAddExtra(status) ? itemCount - 1 : itemCount) + totalSeparators;
        // bool canShowSeparator(int index) => hasSeparator && totalSeparators.isGt(0) && strategy(index);

        bool canShowSeparator(int index) {
          final isLast = index == totalItemCount - 1;
          return hasSeparator && totalSeparators.isGt(0) && strategy(index) &&
              (widget.applySeparatorToLastItem || !isLast);
        }

        Widget? child(BuildContext context, int index) {
          int itemIndex = PagedHelper.getActualItemIndex(strategy, hasSeparator, index);

          if (canShowSeparator(index)) {
            return separatorBuilder!(context, itemIndex);
          }

          return childItemBuilder(context, itemIndex);
        }

        return CustomScrollView(
          controller: _scrollController,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          primary: widget.primary,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          center: widget.center,
          anchor: widget.anchor,
          cacheExtent: widget.cacheExtent,
          semanticChildCount: widget.semanticChildCount,
          dragStartBehavior: widget.dragStartBehavior,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          hitTestBehavior: widget.hitTestBehavior,
          scrollBehavior: widget.scrollBehavior,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(child,
                findChildIndexCallback: widget.findChildIndexCallback,
                childCount: totalItemCount,
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                addRepaintBoundaries: widget.addRepaintBoundaries,
                addSemanticIndexes: widget.addSemanticIndexes,
                semanticIndexCallback: (Widget widget, int index) {
                  return canShowSeparator(index)
                      ? null
                      : PagedHelper.getActualItemIndex(strategy, hasSeparator, index);
                },
              ),
              gridDelegate: widget.gridDelegate,
            ),

            if(showExtra && status.isOngoing) ...[
              SliverToBoxAdapter(child: newPageProgressBuilder(context)),
            ] else if(status.isSubsequentPageError) ...[
              SliverToBoxAdapter(child: newPageErrorBuilder(context)),
            ] else if(status.isCompleted && WidgetUtils.hasContent(noMoreItemsBuilder(context))) ...[
              SliverToBoxAdapter(child: noMoreItemsBuilder(context)),
            ]
          ],
        );
      }
    );
  }
}