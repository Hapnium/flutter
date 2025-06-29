import 'package:flutter/foundation.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/enums.dart';
import 'package:smart/exceptions.dart';
import 'package:tracing/tracing.dart' show console;

import '../../export.dart';


/// A controller for a paged widget.
///
/// If you modify the [itemList], [error] or [nextPage] properties, the
/// paged widget will be notified and will update itself appropriately.
///
/// The [itemList], [error] or [nextPage] properties can be set from within
/// a listener added to this controller. If more than one property need to be
/// changed then the controller's [value] should be set instead.
///
/// This object should generally have a lifetime longer than the widgets
/// itself; it should be reused each time a paged widget constructor is called.
class PagedController<Page, Item> extends ValueNotifier<Paged<Page, Item>> {
  PagedController({
    required this.firstPage,
    bool showLog = false,
    this.invisibleItemsThreshold
  }) : super(Paged<Page, Item>(nextPage: firstPage, showLog: showLog));

  /// Creates a controller from an existing [Paged)].
  ///
  /// [firstPage] is the key to be used in case of a [refresh].
  PagedController.fromValue(Paged<Page, Item> value, {
    required this.firstPage,
    this.invisibleItemsThreshold,
  }) : super(value);

  ObserverList<PagedStatusListener>? _statusListeners = ObserverList<PagedStatusListener>();
  ObserverList<PagedRequestListener<Page>>? _pageRequestListeners = ObserverList<PagedRequestListener<Page>>();

  /// The number of remaining invisible items that should trigger a new fetch.
  final int? invisibleItemsThreshold;

  /// The key for the first page to be fetched.
  final Page firstPage;

  /// Indicates whether the list can be reloaded.
  bool _hasListenerFired = false;

  /// List with all items loaded so far. Initially `null`.
  List<Item>? get itemList => value.itemList;

  /// The current error, if any. Initially `null`.
  dynamic get error => value.error;

  /// The key for the next page to be fetched.
  ///
  /// Initialized with the same value as [firstPage], received in the
  /// constructor.
  Page? get nextPage => value.nextPage;

  /// Whether to show logs or not
  bool get showLog => value.showLog;

  /// This signifies where the log is coming from for easy reading
  String get logContext => "[PAGED CONTROLLER: ${Item}]";

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
  /// the [error] nor the [nextPage].
  set itemList(List<Item>? newItemList) {
    value = Paged<Page, Item>(
      error: error,
      itemList: newItemList,
      nextPage: nextPage,
    );
  }

  /// Sets the error and updates the internal state.
  ///
  /// This updates the [error] with the [newError] values. However, it does not update
  /// the [itemList] nor the [nextPage].
  set error(dynamic newError) {
    value = Paged<Page, Item>(
      error: newError,
      itemList: itemList,
      nextPage: nextPage,
    );
  }

  /// Sets the next page key to be fetched and updates the internal state.
  ///
  /// This updates the [nextPage] with the [newNextPageKey] values. However, it does not update
  /// the [itemList] nor the [error].
  set nextPage(Page? newNextPageKey) {
    value = Paged<Page, Item>(
      error: error,
      itemList: itemList,
      nextPage: newNextPageKey,
      previousPage: value.nextPage,
    );
  }

  /// Corresponding to [ValueNotifier.value].
  @override
  set value(Paged<Page, Item> newValue) {
    if (value.status.notEquals(newValue.status)) {
      notifyStatusListeners(newValue.status);
    }

    super.value = newValue;
  }

  /// Appends [newItems] to the previously loaded ones and replaces
  /// the next page's key.
  void appendPage(List<Item> newItems, Page? nextPage) {
    List<Item> previousItems = value.itemList ?? [];
    List<Item> itemList = previousItems + newItems;

    value = Paged<Page, Item>(
      itemList: itemList,
      error: null,
      nextPage: nextPage,
      previousPage: value.nextPage,
    );
  }

  /// Appends [newItems] to the previously loaded ones and sets the next page
  /// key to `null`.
  void appendLastPage(List<Item> newItems) => appendPage(newItems, null);

  /// Erases the current error.
  void retryLastFailedRequest() {
    error = null;
  }

  /// Resets [value] to its initial state.
  void refresh() {
    if(showLog) {
      console.log("Refreshing paged controller.", tag: logContext);
    }

    value = Paged<Page, Item>(
      nextPage: firstPage,
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
  /// This method reloads the list by notifying all page request listeners
  /// to fetch the first page of data. It should only be called if the list
  /// can be reloaded, as indicated by the [canReload] property.
  ///
  /// **Assertion:**
  ///
  /// * Throws an assertion error if the widget is disposed during debug mode.
  ///
  /// **Behavior:**
  ///
  /// * If [canReload] is `true`, it calls `notifyPageRequestListeners(firstPageKey)`
  ///   to refresh the data.
  /// * If [canReload] is `false`, it does nothing.
  void reload() {
    assert(_debugAssertNotDisposed());

    if(canReload && _hasListenerFired.isFalse) {
      if(showLog) {
        console.log("Reloading paged controller.", tag: logContext);
      }

      notifyPageRequestListeners(firstPage);
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
  void notifyStatusListeners(PagedStatus status) {
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
  void addPageRequestListener(PagedRequestListener<Page> listener) {
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
  void removePageRequestListener(PagedRequestListener<Page> listener) {
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
  void notifyPageRequestListeners(Page pageKey) {
    assert(_debugAssertNotDisposed());

    if (_pageRequestListeners?.isEmpty ?? true) {
      if(showLog) {
        console.log("No page request listener has been registered yet.", tag: logContext);
      }
      _hasListenerFired = false;

      return;
    }

    List<PagedRequestListener<Page>> localListeners = List<PagedRequestListener<Page>>.from(_pageRequestListeners!);

    if(showLog) {
      console.log("There are ${localListeners.length} page request listeners registered.", tag: logContext);
    }

    for (PagedRequestListener<Page> listener in localListeners) {
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