/// Represents the possible status of a pagination operation.
///
/// This enum defines all possible states that a pagination operation
/// can be in, such as completed, loading, encountering errors,
/// or indicating that no items were found.
enum PagedStatus {
  /// Indicates that the pagination operation has completed successfully.
  COMPLETED,

  /// Indicates that no items were found during the pagination operation.
  NO_ITEMS_FOUND,

  /// Indicates that the first page of data is currently being loaded.
  LOADING_FIRST_PAGE,

  /// Indicates that the pagination operation is currently in progress.
  ONGOING,

  /// Indicates that an error occurred while loading the first page of data.
  FIRST_PAGE_ERROR,

  /// Indicates that an error occurred while loading a subsequent page of data.
  SUBSEQUENT_PAGE_ERROR,
}