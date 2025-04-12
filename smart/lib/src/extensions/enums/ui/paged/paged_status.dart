import '../../../../enums/ui/paged/paged_status.dart';

/// Provides expressive boolean checks for [PagedStatus].
///
/// This extension simplifies status checks by replacing `==` comparisons
/// with readable getters.
extension PagedStatusExtension on PagedStatus {
  /// Returns `true` if the paged status is [PagedStatus.completed].
  bool get isCompleted => this == PagedStatus.completed;

  /// Returns `true` if no items were found.
  bool get isNoItemsFound => this == PagedStatus.noItemsFound;

  /// Returns `true` if the first page is currently being loaded.
  bool get isLoadingFirstPage => this == PagedStatus.loadingFirstPage;

  /// Returns `true` if pagination is ongoing (more items are being loaded).
  bool get isOngoing => this == PagedStatus.ongoing;

  /// Returns `true` if an error occurred while loading the first page.
  bool get isFirstPageError => this == PagedStatus.firstPageError;

  /// Returns `true` if an error occurred while loading a subsequent page.
  bool get isSubsequentPageError => this == PagedStatus.subsequentPageError;
}