/// A generic helper class to represent paginated response data from a server.
///
/// This class is useful when dealing with APIs that return paginated results,
/// such as lists of users, posts, or products. It includes metadata such as
/// the current page, total number of items, and the page limit.
///
/// Example usage:
/// ```dart
/// final page = ZapPage<User>(
///   data: [User.fromJson(json)],
///   total: 100,
///   page: 1,
///   limit: 10,
/// );
/// ```
class ZapPage<T> {
  /// The list of items returned for the current page.
  ///
  /// This will usually be deserialized objects of type [T].
  final List<T> data;

  /// The total number of items available across all pages.
  ///
  /// This value is typically provided by the server.
  final int total;

  /// The current page index (1-based).
  ///
  /// For example, page 1 means the first set of results.
  final int page;

  /// The maximum number of items per page.
  ///
  /// This value is usually requested by the client or defined by the server.
  final int limit;

  /// Creates a new instance of [ZapPage] with the given data and pagination metadata.
  ///
  /// ---
  /// Parameters:
  /// - [data]: The list of items in the current page.
  /// - [total]: The total number of items available.
  /// - [page]: The current page index (starting at 1).
  /// - [limit]: The maximum number of items per page.
  const ZapPage({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  /// Returns `true` if there is a next page available.
  ///
  /// This is calculated as `(page * limit) < total`.
  bool get hasNextPage => (page * limit) < total;

  /// Returns `true` if there is a previous page available.
  ///
  /// For example, page 2 and above have previous pages.
  bool get hasPreviousPage => page > 1;

  /// Returns the total number of pages available.
  ///
  /// This is calculated by dividing the total number of items by the page limit
  /// and rounding up.
  int get totalPages => (total / limit).ceil();
}