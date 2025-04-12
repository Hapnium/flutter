import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';

/// The current item's list, error, and next page key state for a paginated
/// widget.
@immutable
class Paged<PageKeyType, ItemType> {
  const Paged({
    this.nextPageKey,
    this.itemList,
    this.error,
    this.showLog = false,
  });

  /// List with all items loaded so far.
  final List<ItemType>? itemList;

  /// The current error, if any.
  final dynamic error;

  /// The key for the next page to be fetched.
  final PageKeyType? nextPageKey;

  /// Whether to show logs or not.
  final bool showLog;

  /// The current pagination status.
  PagedStatus get status {
    if (_isOngoing) {
      return PagedStatus.ongoing;
    }

    if (_isCompleted) {
      return PagedStatus.completed;
    }

    if (_isLoadingFirstPage) {
      return PagedStatus.loadingFirstPage;
    }

    if (_hasSubsequentPageError) {
      return PagedStatus.subsequentPageError;
    }

    if (_isEmpty) {
      return PagedStatus.noItemsFound;
    } else {
      return PagedStatus.firstPageError;
    }
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'Paged')}(itemList: \u2524'
          '$itemList\u251C, error: $error, nextPageKey: $nextPageKey, showLog: $showLog)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Paged &&
        other.itemList == itemList &&
        other.error == error &&
        other.nextPageKey == nextPageKey &&
        other.showLog == showLog;
  }

  @override
  int get hashCode => Object.hash(
    itemList.hashCode,
    error.hashCode,
    nextPageKey.hashCode,
    showLog.hashCode,
  );

  int? get _itemCount => itemList?.length;

  bool get _hasNextPage => nextPageKey.isNotNull;

  bool get _hasItems {
    final itemCount = _itemCount;
    return itemCount.isNotNull && itemCount!.isGt(0);
  }

  bool get _hasError => error != null;

  bool get _isListingUnfinished => _hasItems && _hasNextPage;

  bool get _isOngoing => _isListingUnfinished && !_hasError;

  bool get _isCompleted => _hasItems && !_hasNextPage;

  bool get _isLoadingFirstPage => _itemCount == null && !_hasError;

  bool get _hasSubsequentPageError => _isListingUnfinished && _hasError;

  bool get _isEmpty => _itemCount.isNotNull && _itemCount == 0;
}