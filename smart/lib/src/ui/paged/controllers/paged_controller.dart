import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';
import 'package:smart/exceptions.dart';
import 'package:tracing/tracing.dart' show console;

import '../../export.dart';


/// A controller for a paged widget.
///
/// If you modify the [itemList], [error] or [nextPageKey] properties, the
/// paged widget will be notified and will update itself appropriately.
///
/// The [itemList], [error] or [nextPageKey] properties can be set from within
/// a listener added to this controller. If more than one property need to be
/// changed then the controller's [value] should be set instead.
///
/// This object should generally have a lifetime longer than the widgets
/// itself; it should be reused each time a paged widget constructor is called.
class PagedController<PageKeyType, ItemType> extends ValueNotifier<Paged<PageKeyType, ItemType>> {
  PagedController({
    required this.firstPageKey,
    bool showLog = false,
    this.invisibleItemsThreshold
  }) : super(Paged<PageKeyType, ItemType>(nextPageKey: firstPageKey, showLog: showLog));

  /// Creates a controller from an existing [Paged)].
  ///
  /// [firstPageKey] is the key to be used in case of a [refresh].
  PagedController.fromValue(Paged<PageKeyType, ItemType> value, {
    required this.firstPageKey,
    this.invisibleItemsThreshold,
  }) : super(value);

  ObserverList<PagedStatusListener>? _statusListeners = ObserverList<PagedStatusListener>();
  ObserverList<PagedRequestListener<PageKeyType>>? _pageRequestListeners = ObserverList<PagedRequestListener<PageKeyType>>();

  /// The number of remaining invisible items that should trigger a new fetch.
  final int? invisibleItemsThreshold;

  /// The key for the first page to be fetched.
  final PageKeyType firstPageKey;

  /// Indicates whether the list can be reloaded.
  bool _hasListenerFired = false;

  /// List with all items loaded so far. Initially `null`.
  List<ItemType>? get itemList => value.itemList;

  /// The current error, if any. Initially `null`.
  dynamic get error => value.error;

  /// The key for the next page to be fetched.
  ///
  /// Initialized with the same value as [firstPageKey], received in the
  /// constructor.
  PageKeyType? get nextPageKey => value.nextPageKey;

  /// Whether to show logs or not
  bool get showLog => value.showLog;

  /// This signifies where the log is coming from for easy reading
  String get logContext => "[PAGED CONTROLLER: ${ItemType}]";

  /// Indicates whether the list can be reloaded.
  ///
  /// The list can be reloaded if it is in an error state, if it is loading the
  /// first page, and if the item list is empty.
  ///
  /// **Returns:**
  ///
  /// `true` if the list can be reloaded, `false` otherwise.
  ///
  /// **Usage:**
  ///
  /// Use this property to determine whether to enable or show a reload button
  /// or indicator. The list can be refreshed by calling the [reload] method.
  Boolean get canReload => (error != null || value.status == PagedStatus.loadingFirstPage) && (itemList ?? []).isEmpty;

  /// Sets the list of items and updates the internal state.
  ///
  /// This updates the [itemList] with the [newItemList] values. However, it does not update
  /// the [error] nor the [nextPageKey].
  set itemList(List<ItemType>? newItemList) {
    value = Paged<PageKeyType, ItemType>(
      error: error,
      itemList: newItemList,
      nextPageKey: nextPageKey,
    );
  }

  /// Sets the error and updates the internal state.
  ///
  /// This updates the [error] with the [newError] values. However, it does not update
  /// the [itemList] nor the [nextPageKey].
  set error(dynamic newError) {
    value = Paged<PageKeyType, ItemType>(
      error: newError,
      itemList: itemList,
      nextPageKey: nextPageKey,
    );
  }

  /// Sets the next page key to be fetched and updates the internal state.
  ///
  /// This updates the [nextPageKey] with the [newNextPageKey] values. However, it does not update
  /// the [itemList] nor the [error].
  set nextPageKey(PageKeyType? newNextPageKey) {
    value = Paged<PageKeyType, ItemType>(
      error: error,
      itemList: itemList,
      nextPageKey: newNextPageKey,
    );
  }

  /// Corresponding to [ValueNotifier.value].
  @override
  set value(Paged<PageKeyType, ItemType> newValue) {
    if (value.status.notEquals(newValue.status)) {
      tappyStatusListeners(newValue.status);
    }

    super.value = newValue;
  }

  /// Appends [newItems] to the previously loaded ones and replaces
  /// the next page's key.
  void appendPage(List<ItemType> newItems, PageKeyType? nextPageKey) {
    List<ItemType> previousItems = value.itemList ?? [];
    List<ItemType> itemList = previousItems + newItems;

    value = Paged<PageKeyType, ItemType>(
      itemList: itemList,
      error: null,
      nextPageKey: nextPageKey,
    );
  }

  /// Appends [newItems] to the previously loaded ones and sets the next page
  /// key to `null`.
  void appendLastPage(List<ItemType> newItems) => appendPage(newItems, null);

  /// Erases the current error.
  void retryLastFailedRequest() {
    error = null;
  }

  /// Resets [value] to its initial state.
  void refresh() {
    if(showLog) {
      console.log("Refreshing paged controller.", tag: logContext);
    }

    value = Paged<PageKeyType, ItemType>(
      nextPageKey: firstPageKey,
      error: null,
      itemList: null,
    );
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_pageRequestListeners.isNull || _statusListeners.isNull) {
        throw SmartException(
          'A PagedController was used after being disposed.\nOnce you have '
              'called dispose() on a PagedController, it can no longer be '
              'used.\nIf you’re using a Future, it probably completed after '
              'the disposal of the owning widget.\nMake sure dispose() has not '
              'been called yet before using the PagedController.',
        );
      }
      return true;
    }());
    return true;
  }

  /// Reloads the list, triggering a request for the first page.
  ///
  /// This method reloads the list by tappying all page request listeners
  /// to fetch the first page of data. It should only be called if the list
  /// can be reloaded, as indicated by the [canReload] property.
  ///
  /// **Assertion:**
  ///
  /// * Throws an assertion error if the widget is disposed during debug mode.
  ///
  /// **Behavior:**
  ///
  /// * If [canReload] is `true`, it calls `tappyPageRequestListeners(firstPageKey)`
  ///   to refresh the data.
  /// * If [canReload] is `false`, it does nothing.
  void reload() {
    assert(_debugAssertNotDisposed());

    if(canReload && _hasListenerFired.isFalse) {
      if(showLog) {
        console.log("Reloading paged controller.", tag: logContext);
      }

      tappyPageRequestListeners(firstPageKey);
    }
  }

  /// Calls listener every time the status of the pagination changes.
  ///
  /// Listeners can be removed with [removeStatusListener].
  void addStatusListener(PagedStatusListener listener) {
    assert(_debugAssertNotDisposed());

    if(showLog) {
      console.log("Adding status listener ${listener.runtimeType}.", tag: logContext);
    }

    _statusListeners?.add(listener);
  }

  /// Stops calling the listener every time the status of the pagination
  /// changes.
  ///
  /// Listeners can be added with [addStatusListener].
  void removeStatusListener(PagedStatusListener listener) {
    assert(_debugAssertNotDisposed());

    if(showLog) {
      console.log("Removing status listener ${listener.runtimeType}.", tag: logContext);
    }

    _statusListeners?.remove(listener);
  }

  /// Calls all the status listeners.
  ///
  /// If listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void tappyStatusListeners(PagedStatus status) {
    assert(_debugAssertNotDisposed());

    if (_statusListeners?.isEmpty ?? true) {
      if(showLog) {
        console.log("No status listener has been registered yet.", tag: logContext);
      }

      return;
    }

    List<PagedStatusListener> localListeners = List<PagedStatusListener>.from(_statusListeners!);

    if(showLog) {
      console.log("There are ${localListeners.length} status listeners registered.", tag: logContext);
    }

    for (PagedStatusListener listener in localListeners) {
      if (_statusListeners!.contains(listener)) {
        listener(status);
      }
    }
  }

  /// Calls listener every time new items are needed.
  ///
  /// Listeners can be removed with [removePageRequestListener].
  void addPageRequestListener(PagedRequestListener<PageKeyType> listener) {
    assert(_debugAssertNotDisposed());

    if(showLog) {
      console.log("Registering page request listener ${listener.runtimeType}.", tag: logContext);
    }

    _pageRequestListeners?.add(listener);

    if(showLog) {
      console.log("Page request listener ${listener.runtimeType} registered.", tag: logContext);
    }
  }

  /// Stops calling the listener every time new items are needed.
  ///
  /// Listeners can be added with [addPageRequestListener].
  void removePageRequestListener(PagedRequestListener<PageKeyType> listener) {
    assert(_debugAssertNotDisposed());

    if(showLog) {
      console.log("Removing page request listener ${listener.runtimeType}.", tag: logContext);
    }

    _pageRequestListeners?.remove(listener);

    if(showLog) {
      console.log("Page request listener ${listener.runtimeType} removed.", tag: logContext);
    }
  }

  /// Calls all the page request listeners.
  ///
  /// If listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void tappyPageRequestListeners(PageKeyType pageKey) {
    assert(_debugAssertNotDisposed());

    if (_pageRequestListeners?.isEmpty ?? true) {
      if(showLog) {
        console.log("No page request listener has been registered yet.", tag: logContext);
      }
      _hasListenerFired = false;

      return;
    }

    List<PagedRequestListener<PageKeyType>> localListeners = List<PagedRequestListener<PageKeyType>>.from(_pageRequestListeners!);

    if(showLog) {
      console.log("There are ${localListeners.length} page request listeners registered.", tag: logContext);
    }

    for (PagedRequestListener<PageKeyType> listener in localListeners) {
      if (_pageRequestListeners!.contains(listener)) {
        _hasListenerFired = true;
        listener(pageKey);
      }
    }
  }

  @override
  void dispose() {
    assert(_debugAssertNotDisposed());

    if(showLog) {
      console.log("Disposing paged controller.", tag: logContext);
    }

    _statusListeners = null;
    _pageRequestListeners = null;

    super.dispose();
  }
}