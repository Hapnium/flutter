part of 'paged_page_view.dart';

class _PagedPageViewState<PageKeyType, ItemType> extends State<PagedPageView<PageKeyType, ItemType>> {
  late final PageController _pageController;

  @protected
  PagedController<PageKeyType, ItemType> get pagingController => widget.controller;

  @protected
  NullableIndexedWidgetBuilder? get separatorBuilder => widget.separatorBuilder;

  @protected
  bool get hasSeparator => separatorBuilder.isNotNull;

  @protected
  PagedChildBuilderDelegate<ItemType> get delegate => widget.builderDelegate;

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
    _pageController = widget.pageController ?? PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PagedPageView<PageKeyType, ItemType> oldWidget) {
    if (oldWidget.pageController != widget.pageController) {
      setState(() {});
    } else if(oldWidget.separatorBuilder.notEquals(widget.separatorBuilder) || oldWidget.separatorStrategy.notEquals(widget.separatorStrategy)) {
      setState(() {});
    } else if(oldWidget.controller.notEquals(widget.controller) || oldWidget.builderDelegate.notEquals(widget.builderDelegate)) {
      setState(() {});
    } else if(oldWidget.scrollDirection.notEquals(widget.scrollDirection) || oldWidget.reverse.notEquals(widget.reverse)) {
      setState(() {});
    } else if(oldWidget.allowImplicitScrolling.notEquals(widget.allowImplicitScrolling) || oldWidget.onPageChanged.notEquals(widget.onPageChanged)) {
      setState(() {});
    } else if(oldWidget.physics.notEquals(widget.physics) || oldWidget.dragStartBehavior.notEquals(widget.dragStartBehavior) || oldWidget.hitTestBehavior.notEquals(widget.hitTestBehavior)) {
      setState(() {});
    } else if(oldWidget.restorationId.notEquals(widget.restorationId) || oldWidget.clipBehavior.notEquals(widget.clipBehavior) || oldWidget.scrollBehavior.notEquals(widget.scrollBehavior)) {
      setState(() {});
    } else if(oldWidget.padEnds.notEquals(widget.padEnds) || oldWidget.pageSnapping.notEquals(widget.pageSnapping)) {
      setState(() {});
    } else if(oldWidget.useStack.notEquals(widget.useStack)) {
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _pageController.dispose();
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
          Widget? child;

          int itemIndex = PagedHelper.getActualItemIndex(strategy, hasSeparator, index);
          bool isLastItem = index == totalItemCount - 1;

          if (canShowSeparator(index)) {
            child = separatorBuilder!(context, itemIndex);
          } else {
            child = childItemBuilder(context, itemIndex);
          }

          if(child.isNotNull) {
            if(widget.useStack) {
              final FloatingConfig config = widget.floatConfig ?? FloatingConfig();
              Positioned positioned(Widget child) => Positioned(
                left: config.left,
                right: config.right,
                top: config.top,
                bottom: config.bottom,
                height: config.height,
                width: config.width,
                child: child,
              );

              return Stack(
                fit: widget.fit ?? StackFit.loose,
                alignment: widget.alignment ?? AlignmentDirectional.topStart,
                clipBehavior: widget.itemClipBehavior ?? Clip.hardEdge,
                children: [
                  child!,
                  if(isLastItem) ...[
                    if(showExtra && status.isOngoing) ...[
                      positioned(newPageProgressBuilder(context)),
                    ] else if(status.isSubsequentPageError) ...[
                      positioned(newPageErrorBuilder(context)),
                    ] else if(status.isCompleted && WidgetUtils.hasContent(noMoreItemsBuilder(context))) ...[
                      positioned(noMoreItemsBuilder(context)),
                    ]
                  ]
                ],
              );
            } else {
              return Column(
                spacing: widget.spacing ?? 0.0,
                verticalDirection: widget.verticalDirection ?? VerticalDirection.down,
                textDirection: widget.textDirection,
                textBaseline: widget.textBaseline,
                mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
                crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
                mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  Expanded(child: child!),
                  if(isLastItem) ...[
                    if(showExtra && status.isOngoing) ...[
                      newPageProgressBuilder(context),
                    ] else if(status.isSubsequentPageError) ...[
                      newPageErrorBuilder(context),
                    ] else if(status.isCompleted && WidgetUtils.hasContent(noMoreItemsBuilder(context))) ...[
                      noMoreItemsBuilder(context),
                    ]
                  ]
                ]
              );
            }
          }

          return null;
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          allowImplicitScrolling: widget.allowImplicitScrolling,
          onPageChanged: widget.onPageChanged,
          physics: widget.physics,
          dragStartBehavior: widget.dragStartBehavior,
          hitTestBehavior: widget.hitTestBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          scrollBehavior: widget.scrollBehavior,
          padEnds: widget.padEnds,
          pageSnapping: widget.pageSnapping,
          itemCount: totalItemCount,
          itemBuilder: child,
        );
      }
    );
  }
}