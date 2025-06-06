import 'package:hapnium/hapnium.dart';

import '../exceptions/secure_database_exception.dart';

/// An abstract service interface defining CRUD (Create, Read, Update, Delete)
/// operations for data of type [T].
///
/// Implementations of this interface provide a standardized way to interact
/// with a data storage mechanism (e.g., a database, local storage).  This
/// interface does *not* handle the storage logic itself; it defines the
/// contract that concrete implementations must adhere to.
///
/// Implementors are expected to throw a [SecureDatabaseException] if any error
/// occurs during data access.
abstract class RepositoryService<T> {
  /// Creates or inserts the provided [item] into the database.
  ///
  /// This method should either create a new entry for the [item] or update an
  /// existing entry if a matching key or identifier is found.  The specific
  /// behavior (insert vs. update) depends on the implementation.
  ///
  /// Throws a [SecureDatabaseException] if an error occurs during the operation.
  Future<T> save(T item);

  /// Reads data from the database.
  ///
  /// This method retrieves a single item from the database. The specific
  /// criteria for selecting the item (e.g., by ID, by key) depends on the
  /// implementation.
  ///
  /// Throws a [SecureDatabaseException] if an error occurs during the operation.
  T get();

  /// Fetches all items from the database.
  ///
  /// This method retrieves all items stored in the database. The order of the
  /// returned list is not guaranteed unless specified by the implementation.
  ///
  /// Throws a [SecureDatabaseException] if an error occurs during the operation.
  Future<List<T>> fetchAll();

  /// Deletes multiple items from the database.
  ///
  /// This method deletes a list of items from the database.  The specific
  /// criteria for identifying the items to delete depends on the
  /// implementation.
  ///
  /// Throws a [SecureDatabaseException] if an error occurs during the operation.
  Future<void> deleteAll(List<T> items);

  /// Deletes data from the database.
  ///
  /// This method deletes data from the database. The specific data being deleted depends on the implementation.
  ///
  /// Throws a [SecureDatabaseException] if an error occurs during the operation.
  Future<Optional<T>> delete();

  /// Closes the repository.
  ///
  /// This method closes the repository and releases any resources held by the
  /// repository.  It should be called when the repository is no longer needed.
  ///
  /// **Returns:**
  ///
  /// A `Future<bool>` that completes when the repository is closed.
  Future<bool> close();
}