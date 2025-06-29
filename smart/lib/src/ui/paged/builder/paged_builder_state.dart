part of 'paged_builder.dart';

class _PagedBuilderState<PageKeyType, ItemType> extends State<PagedBuilder<PageKeyType, ItemType>> {
  @protected
  PagedController<PageKeyType, ItemType> get pagingController => widget.controller;

  @protected
  PagedChildBuilderDelegate<ItemType> get delegate => widget.builderDelegate;

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
  ItemWidgetBuilder<ItemType> get itemBuilder => widget.builderDelegate.itemBuilder;

  @protected
  int get invisibleItemsThreshold => pagingController.invisibleItemsThreshold ?? 3;

  @protected
  int get itemCount => pagingController.itemList?.length ?? 0;

  @protected
  PageKeyType? get nextKey => pagingController.nextPageKey;

  @protected
  bool get hasNextPage => nextKey.isNotNull && nextKey.notEquals(pagingController.firstPageKey);

  @protected
  PagedChildBuilder<PageKeyType, ItemType> get childBuilder => widget.childBuilder;

  /// Avoids duplicate requests on rebuilds.
  bool _hasRequestedNextPage = false;
  
  /// Track the current page key to prevent duplicate requests for the same page
  PageKeyType? _currentRequestedPageKey;

  @override
  void didUpdateWidget(covariant PagedBuilder<PageKeyType, ItemType> oldWidget) {
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
          pagingController.notifyPageRequestListeners(pagingController.firstPageKey);
        }
        
        // Reset the request flag when a new page is successfully loaded or an error occurs
        if (status.isOngoing || status.isCompleted || status.isSubsequentPageError) {
          _hasRequestedNextPage = false;
          _currentRequestedPageKey = null;
        }
      },
      child: ValueListenableBuilder<Paged<PageKeyType, ItemType>>(
        valueListenable: pagingController,
        builder: (BuildContext context, Paged<PageKeyType, ItemType> state, _) {
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
  Widget childItemBuilder(BuildContext context, int index, Paged<PageKeyType, ItemType> state, int count) {
    bool isExtraWidget = index.equals(count - 1) && PagedHelper.canAddExtra(state.status);

    if(isExtraWidget.isFalse) {
      // Only trigger next page request if we haven't already requested it and we're not currently loading
      if (!_hasRequestedNextPage && !state.status.isLoadingFirstPage && !state.status.isOngoing) {
        int newPageRequestTriggerIndex = max(0, itemCount - invisibleItemsThreshold);
        bool isBuildingTriggerIndexItem = index.equals(newPageRequestTriggerIndex);

        if (hasNextPage && 
            isBuildingTriggerIndexItem && 
            (_currentRequestedPageKey == null || _currentRequestedPageKey != nextKey)) {
          
          // Schedules the request for the end of this frame.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Double-check that we still need to make the request
            if (!_hasRequestedNextPage && hasNextPage && (_currentRequestedPageKey == null || _currentRequestedPageKey != nextKey)) {
              _hasRequestedNextPage = true;
              _currentRequestedPageKey = nextKey;
              pagingController.notifyPageRequestListeners(nextKey as PageKeyType);
            }
          });
        }
      }

      final itemList = pagingController.itemList;
      ItemMetadata<ItemType> metadata = ItemMetadata(
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