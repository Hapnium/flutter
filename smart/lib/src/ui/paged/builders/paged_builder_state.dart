part of 'paged_builder.dart';

class _PagedBuilderState<Page, Item> extends State<PagedBuilder<Page, Item>> {
  @protected
  Paged<Page, Item> get value => widget.state;

  @protected
  PagedBuilderDelegate<Item> get delegate => widget.builderDelegate;

  // We make sure to only schedule the fetch after the current build is done. This is important to prevent recursive builds.
  @protected
  NextPageCallback get fetchNextPage => () => WidgetsBinding.instance.addPostFrameCallback((_) {
    if(!mounted) return;
    widget.fetchNextPage();
  });

  @protected
  WidgetBuilder get firstPageErrorBuilder => delegate.firstPageErrorIndicatorBuilder ?? (_) => PagedFirstPageErrorIndicator(
    onTryAgain: fetchNextPage,
  );

  @protected
  WidgetBuilder get newPageErrorBuilder => delegate.newPageErrorIndicatorBuilder ?? (_) => PagedNewPageErrorIndicator(
    onTap: fetchNextPage,
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
  ItemWidgetBuilder<Item> get itemBuilder => delegate.itemBuilder;

  @protected
  int get invisibleItemsThreshold => delegate.invisibleItemsThreshold;

  @protected
  List<Item> get list => value.items ?? [];

  @protected
  int get itemCount => list.length;

  @protected
  bool get hasNextPage => value.hasNextPage;

  /// Avoids duplicate requests on rebuilds.
  bool _hasRequestedNextPage = false;

  @override
  void initState() {
    if (value.status.isLoadingFirstPage) {
      fetchNextPage();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PagedBuilder<Page, Item> oldWidget) {
    if (oldWidget.state.notEquals(widget.state)) {
      if (value.status.isLoadingFirstPage) {
        fetchNextPage();
      } else if (value.status.isOngoing) {
        _hasRequestedNextPage = false;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUGGING::::::: PAGED BUILDER STATE: State: $value");
    return PagedBuilderAnimator(
      animateTransitions: delegate.animateTransitions,
      transitionDuration: delegate.transitionDuration,
      child: switch (value.status) {
        PagedStatus.LOADING_FIRST_PAGE => firstPageProgressBuilder(context),
        PagedStatus.FIRST_PAGE_ERROR => firstPageErrorBuilder(context),
        PagedStatus.NO_ITEMS_FOUND => noItemsFoundBuilder(context),
        PagedStatus.ONGOING => widget.loadingBuilder(
          context,
          itemCount,
          newPageProgressBuilder,
          (context, index) => _build(context, index, list)
        ),
        PagedStatus.SUBSEQUENT_PAGE_ERROR => widget.errorBuilder(
          context,
          itemCount,
          newPageErrorBuilder,
          (context, index) => _build(context, index, list)
        ),
        PagedStatus.COMPLETED => widget.completedBuilder(
          context,
          itemCount,
          noMoreItemsBuilder,
          (context, index) => _build(context, index, list)
        ),
      },
    );
  }

  /// Builds a list item and triggers page fetching when nearing the end.
  ///
  /// It calculates a threshold and determines whether it's time to fetch
  /// the next page. If so, it schedules the fetch and marks the request.
  Widget _build(BuildContext context, int index, List<Item> items) {
    if (!_hasRequestedNextPage) {
      final maxIndex = max(0, itemCount - 1);
      final triggerIndex = max(0, maxIndex - invisibleItemsThreshold);

      // It is important to check whether we are past the trigger, not just at it.
      // This is because otherwise, large tresholds will place the trigger behind the user,
      // Leading to the refresh never being triggered.
      // This behaviour is okay because we make sure not to excessively request pages.
      final hasPassedTrigger = index >= triggerIndex;

      if (hasNextPage && hasPassedTrigger) {
        _hasRequestedNextPage = true;
        fetchNextPage();
      }
    }

    ItemMetadata<Item> metadata = ItemMetadata(
      isFirst: index.equals(0),
      isLast: index.equals(itemCount - 1),
      index: index,
      totalItems: itemCount,
      item: items[index],
    );

    return itemBuilder(context, metadata);
  }
}