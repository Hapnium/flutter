part of 'paged_builder.dart';

class _PagedBuilderState<Page, Item> extends State<PagedBuilder<Page, Item>> {
  @protected
  PagedController<Page, Item> get pagingController => widget.controller;

  @protected
  PagedChildBuilderDelegate<Item> get delegate => widget.builderDelegate;

  @protected
  WidgetBuilder get firstPageErrorBuilder => delegate.firstPageErrorIndicatorBuilder ?? (_) => PagedFirstPageErrorIndicator(
    onTryAgain: pagingController.retryLastFailedRequest,
  );

  @protected
  WidgetBuilder get newPageErrorBuilder => delegate.newPageErrorIndicatorBuilder ?? (_) => PagedNewPageErrorIndicator(
    onTap: pagingController.retryLastFailedRequest,
  );

  @protected
  WidgetBuilder get firstPageProgressBuilder => delegate.firstPageProgressIndicatorBuilder ?? (_) => PagedFirstPageProgressIndicator();

  @protected
  WidgetBuilder get newPageProgressBuilder => delegate.newPageProgressIndicatorBuilder ?? (_) => PagedNewPageProgressIndicator();

  @protected
  WidgetBuilder get noItemsFoundBuilder => delegate.noItemsFoundIndicatorBuilder ?? (_) => PagedNoItemsFoundIndicator();

  @protected
  WidgetBuilder get noMoreItemsBuilder => delegate.noMoreItemsIndicatorBuilder ?? (_) => SizedBox.shrink();

  @protected
  ItemWidgetBuilder<Item> get itemBuilder => widget.builderDelegate.itemBuilder;

  @protected
  int get invisibleItemsThreshold => pagingController.invisibleItemsThreshold ?? 3;

  @protected
  int get itemCount => pagingController.itemList?.length ?? 0;

  @protected
  Page? get nextPage => pagingController.nextPage;

  @protected
  bool get hasNextPage => nextPage.isNotNull && nextPage.notEquals(pagingController.firstPage);

  @protected
  PagedChildBuilder<Page, Item> get childBuilder => widget.childBuilder;

  /// Avoids duplicate requests on rebuilds.
  bool _hasRequestedNextPage = false;

  @override
  void didUpdateWidget(covariant PagedBuilder<Page, Item> oldWidget) {
    if(oldWidget.builderDelegate.notEquals(widget.builderDelegate)) {
      setState(() {});
    } else if(oldWidget.controller.notEquals(widget.controller)) {
      setState(() {});
    } else if(oldWidget.controller.itemList.notEquals(widget.controller.itemList)) {
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableListener(
      listenable: pagingController,
      listener: () {
        final status = pagingController.value.status;

        if (status.isLoadingFirstPage) {
          pagingController.notifyPageRequestListeners(pagingController.firstPage);
        }

        if (status.isOngoing || status.isCompleted || status.isSubsequentPageError) {
          _hasRequestedNextPage = false;
        }
      },
      child: ValueListenableBuilder<Paged<Page, Item>>(
        valueListenable: pagingController,
        builder: (BuildContext context, Paged<Page, Item> state, _) {
          if (itemCount.equals(0)) {
            WidgetBuilder child;
            switch (state.status) {
              case PagedStatus.loadingFirstPage:
                child = firstPageProgressBuilder;
                break;
              case PagedStatus.firstPageError:
                child = firstPageErrorBuilder;
                break;
              case PagedStatus.noItemsFound:
                child = noItemsFoundBuilder;
                break;
              default:
                child = noItemsFoundBuilder;
            }

            return child(context);
          }

          int count = itemCount + (PagedHelper.canAddExtra(state.status) ? 1 : 0);
          IndexedWidgetBuilder builder = (BuildContext context, int index) => childItemBuilder(context, index, state, count);
          bool showExtra = state.status.isSubsequentPageError
            || state.status.isCompleted
            || (state.status.isOngoing && _hasRequestedNextPage);

          return childBuilder(count, state.status, showExtra, builder);
        },
      ),
    );
  }

  @protected
  Widget childItemBuilder(BuildContext context, int index, Paged<Page, Item> state, int count) {
    bool isExtraWidget = index.equals(count - 1) && PagedHelper.canAddExtra(state.status);

    if(isExtraWidget.isFalse) {
      if (!_hasRequestedNextPage && hasNextPage) {
        int newPageRequestTriggerIndex = max(0, itemCount - invisibleItemsThreshold);
        bool isBuildingTriggerIndexItem = index.equals(newPageRequestTriggerIndex);

        if (isBuildingTriggerIndexItem) {
          // Schedule the request for the end of this frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_hasRequestedNextPage && hasNextPage) {
              _hasRequestedNextPage = true;
              pagingController.notifyPageRequestListeners(nextPage as Page);
            }
          });
        }
      }

      final itemList = pagingController.itemList;

      ItemMetadata<Item> metadata = ItemMetadata(
        isFirst: index.equals(0),
        isLast: index.equals(itemCount - 1),
        index: index,
        totalItems: itemCount,
        item: itemList![index],
      );

      return itemBuilder(context, metadata);
    }

    switch (state.status) {
      case PagedStatus.ongoing:
        return _hasRequestedNextPage ? newPageProgressBuilder(context) : SizedBox.shrink();
      case PagedStatus.completed:
        return noMoreItemsBuilder(context);
      case PagedStatus.subsequentPageError:
        return newPageErrorBuilder(context);
      default:
        return SizedBox.shrink();
    }
  }
}