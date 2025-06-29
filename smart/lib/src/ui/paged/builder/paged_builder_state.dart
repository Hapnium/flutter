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
  bool get hasNextPage => nextKey.isNotNull;

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
        
        if (pagingController.showLog) {
          console.log("Status changed to: $status, hasNextPage: $hasNextPage, nextKey: $nextKey", tag: pagingController.logContext);
        }
        
        if (status.equals(PagedStatus.loadingFirstPage)) {
          pagingController.notifyPageRequestListeners(pagingController.firstPageKey);
        }
        
        // Reset the request flag when a page load completes (success or error)
        // But NOT when it's ongoing (which means currently loading)
        if (status.equals(PagedStatus.completed) || 
            status.equals(PagedStatus.subsequentPageError) ||
            status.equals(PagedStatus.firstPageError) ||
            status.equals(PagedStatus.noItemsFound)) {
          _hasRequestedNextPage = false;
          _currentRequestedPageKey = null;
          
          if (pagingController.showLog) {
            console.log("Reset request flags due to status: $status", tag: pagingController.logContext);
          }
        }
        
        // Special case: when we transition from loading to ongoing (page loaded successfully)
        if (status.equals(PagedStatus.ongoing) && _hasRequestedNextPage) {
          _hasRequestedNextPage = false;
          _currentRequestedPageKey = null;
          
          if (pagingController.showLog) {
            console.log("Reset request flags - page loaded successfully", tag: pagingController.logContext);
          }
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
      // Check if we should trigger next page request
      _checkAndTriggerNextPageRequest(index, state);

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

  /// Checks if we should trigger a next page request and does so if needed
  void _checkAndTriggerNextPageRequest(int index, Paged<PageKeyType, ItemType> state) {
    // Calculate trigger index
    int newPageRequestTriggerIndex = max(0, itemCount - invisibleItemsThreshold);
    bool isBuildingTriggerIndexItem = index.equals(newPageRequestTriggerIndex);
    
    if (pagingController.showLog && isBuildingTriggerIndexItem) {
      console.log("Building trigger item at index $index (trigger: $newPageRequestTriggerIndex)", tag: pagingController.logContext);
      console.log("Status: ${state.status}, hasNextPage: $hasNextPage, hasRequested: $_hasRequestedNextPage", tag: pagingController.logContext);
      console.log("NextKey: $nextKey, CurrentRequested: $_currentRequestedPageKey", tag: pagingController.logContext);
    }
    
    // Don't request if we already have a pending request
    if (_hasRequestedNextPage) {
      if (pagingController.showLog && isBuildingTriggerIndexItem) {
        console.log("Skipping - already requested", tag: pagingController.logContext);
      }
      return;
    }
    
    // Don't request if we're currently loading the first page
    if (state.status.isLoadingFirstPage) {
      if (pagingController.showLog && isBuildingTriggerIndexItem) {
        console.log("Skipping - loading first page", tag: pagingController.logContext);
      }
      return;
    }
    
    // Don't request if there's no next page
    if (!hasNextPage) {
      if (pagingController.showLog && isBuildingTriggerIndexItem) {
        console.log("Skipping - no next page", tag: pagingController.logContext);
      }
      return;
    }
    
    // Check if we've reached the trigger point
    if (!isBuildingTriggerIndexItem) return;
    
    // Don't request if we've already requested this page key
    if (_currentRequestedPageKey != null && _currentRequestedPageKey == nextKey) {
      if (pagingController.showLog) {
        console.log("Skipping - already requested this page key", tag: pagingController.logContext);
      }
      return;
    }
    
    // All conditions met - schedule the request
    if (pagingController.showLog) {
      console.log("Scheduling next page request for key: $nextKey", tag: pagingController.logContext);
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Final check before making the request
      if (!_hasRequestedNextPage && 
          hasNextPage && 
          !pagingController.value.status.isLoadingFirstPage &&
          (_currentRequestedPageKey == null || _currentRequestedPageKey != nextKey)) {
        
        if (pagingController.showLog) {
          console.log("Executing next page request for key: $nextKey", tag: pagingController.logContext);
        }
        
        _hasRequestedNextPage = true;
        _currentRequestedPageKey = nextKey;
        pagingController.notifyPageRequestListeners(nextKey as PageKeyType);
      } else {
        if (pagingController.showLog) {
          console.log("Final check failed - not executing request", tag: pagingController.logContext);
          console.log("hasRequested: $_hasRequestedNextPage, hasNextPage: $hasNextPage", tag: pagingController.logContext);
          console.log("isLoadingFirstPage: ${pagingController.value.status.isLoadingFirstPage}", tag: pagingController.logContext);
        }
      }
    });
  }
}