/// Represents the possible status of a pagination operation.
///
/// This enum defines all possible states that a pagination operation
/// can be in, such as completed, loading, encountering errors,
/// or indicating that no items were found.
enum PagedStatus {
  /// Indicates that the pagination operation has completed successfully.
  completed,

  /// Indicates that no items were found during the pagination operation.
  noItemsFound,

  /// Indicates that the first page of data is currently being loaded.
  loadingFirstPage,

  /// Indicates that the pagination operation is currently in progress.
  ongoing,

  /// Indicates that an error occurred while loading the first page of data.
  firstPageError,

  /// Indicates that an error occurred while loading a subsequent page of data.
  subsequentPageError,
}