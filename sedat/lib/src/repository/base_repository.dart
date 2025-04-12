import 'dart:async';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:hapnium/hapnium.dart';
import 'package:tracing/tracing.dart';

import '../exceptions/secure_database_exception.dart';
import 'repository_service.dart';

/// An abstract repository class providing CRUD (Create, Read, Update, Delete) operations
/// for data of type [T].
///
/// This class serves as a base for implementing repositories that interact with
/// a local storage using Hive. It handles the underlying storage logic,
/// allowing subclasses to focus on the specific data mapping and business
/// logic.
///
/// Type parameters:
///
/// * [T]: The type of the data you want to work with (e.g., `User`, `Address`,
///   `List<Item>`). This is the type your application will use.
/// * [E]: The type of the data as it's stored in the Hive box (e.g.,
///   `Map<String, dynamic>`, `List<Map<String, dynamic>>`, `String`).  This
///   is often a serialized form of [T].
///
/// Subclasses *must* implement the [toStore] and [fromStore] methods to handle
/// the conversion between [T] and [E].
abstract class BaseRepository<T, E> implements RepositoryService<T> {
  /// The Hive box used for storing the data.
  late Box<dynamic> _box;

  /// Whether the repository has been initialized.
  bool _isInitialized = false;

  /// Whether to destroy saved data while uploading changes
  bool _canDestroy = true;

  /// Whether to show logs during repository operations.
  bool _showLogs = true;

  /// Device identifier for data key.
  String _device = "";

  /// Prefix for database box names.
  String _prefix = "";

  /// Platform identifier for data key.
  String _platform = "";

  /// The name of the Hive box.
  late String _name;

  /// The key used for storing data in the Hive box.
  late String _key;

  /// Tag for log messages from this class.
  String _from = "[SD-REPOSITORY]";

  /// Tag for exception messages from this class.
  String _exPrefix = "[SD-EXCEPTION]";

  /// Creates a new [BaseRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.  It will be
  /// combined with the prefix, device, and platform to create the final box name.
  BaseRepository(String boxName) {
    _name = "$boxName-database";
  }

  /// Opens the Hive box and initializes the repository.
  ///
  /// This method *must* be called before using the repository.  It opens the
  /// Hive box with the given name (combined with prefix, device, and platform)
  /// and sets the [_isInitialized] flag to `true`.
  ///
  /// The optional [prefix], [device], [platform], and [showLogs] parameters
  /// can be used to customize the box name and logging behavior.
  @nonVirtual
  Future<void> open({
    String? prefix,
    String? device,
    String? platform,
    bool showLogs = true,
    bool canDestroy = true
  }) async {
    _showLogs = showLogs;
    _device = device ?? "";
    _platform = platform ?? "";
    _prefix = prefix ?? "";
    _canDestroy = canDestroy;
    _name = "${_prefix.toLowerCase()}-$_name";

    _key = "[${_prefix.toUpperCase()}]";

    if (_device.isNotEmpty) {
      _key = ":$_device";
    }

    if (_platform.isNotEmpty) {
      _key += ":$_platform";
    }

    _key += ":$_name";

    if (_showLogs) {
      console.log("Opening $_name local storage box", from: _from);
    }

    _box = await Hive.openBox<dynamic>(_name);
    _isInitialized = true;

    if(_showLogs) {
      console.log("$_name local storage box is now open and initialized with key set as $_key", from: _from);
    }
  }

  @override
  Future<T> save(T item) async {
    if(!_isInitialized) {
      throw SecureDatabaseException("$_exPrefix - Repository is not initialized. Call open() first.");
    } else if(put().isNotNull) {
      return await put()!(_box, _key, item);
    } else {
      E data = toStore(item);

      if (data.instanceOf<JsonMap>()) {
        await _box.putAll(data as JsonMap);
      } else if (data.instanceOf<JsonMapCollection>()) {
        for (int i = 0; i < (data as JsonMapCollection).length; i++) {
          String key = i.toString();
          JsonMap value = data[i];

          if(_canDestroy) {
            int index = 0;
            while (_box.containsKey(index.toString())) {
              await _box.delete(index.toString());
              index++;
            }
          } else if(_box.containsKey(key)) {
            int index = _box.keys.findIndex((i) => i == key);
            if(index.notEquals(-1)) {
              _box.putAt(index, value);
            } else {
              await _box.delete(key);
            }
          }

          await _box.put(key, value);
        }
      } else {
        await _box.put(_key, data);
      }

      return item;
    }
  }

  @override
  @nonVirtual
  T get() {
    if(!_isInitialized) {
      throw SecureDatabaseException("$_exPrefix - Repository is not initialized. Call open() first.");
    } else if(read().isNotNull) {
      return read()!(_box, _key);
    } else {
      dynamic data;

      if (E.instanceOf<JsonMap>()) {
        JsonMap map = {};

        for (final key in _box.keys) {
          if (key is String) {
            var value = _box.get(key);

            if(Instance.of<Map>(value)) {
              value = decode(value);
            }

            map[key] = value;
          }
        }
        data = map;
      } else if (E.instanceOf<JsonMapCollection>()) {
        JsonMapCollection list = [];

        for (int i = 0;; i++) {
          dynamic item = _box.get(i.toString());
          if (item == null) break;

          if (Instance.of<Map>(item)) {
            item = decode(item);
            list.add(item);
          }
        }
        data = list;
      } else {
        data = _box.get(_key);
      }

      return fromStore(data);
    }
  }

  /// The stream subscription for listening to Hive box events.
  StreamSubscription<BoxEvent>? _subscription;

  /// The stream controller for broadcasting data changes.
  StreamController<T> _controller = StreamController<T>.broadcast();

  /// Returns a stream of data changes from the Hive box.
  ///
  /// This method provides a stream that emits the current data and any
  /// subsequent changes to the data in the Hive box.
  ///
  /// **Returns:**
  ///
  /// A `Stream<T>` that emits the current data and any changes.
  ///
  /// **Throws:**
  ///
  /// * [SecureDatabaseException] if the repository is not initialized.
  @nonVirtual
  Stream<T> get stream async* {
    if (!_isInitialized) {
      throw SecureDatabaseException(
          "$_exPrefix - Repository is not initialized. Call open() first.");
    } else {
      _controller.add(get()); // Emit the current data

      _subscription = _box.watch(key: _key).listen((event) {
        if (event.deleted) {
          _controller.add(fromStore(null)); // Emit null if deleted
        } else {
          _controller.add(fromStore(event.value)); // Emit the new value
        }
      });

      yield* _controller.stream; // Yield the stream from the controller
    }
  }

  /// Disposes of the repository and cancels the stream subscription.
  ///
  /// This method should be called when the repository is no longer needed to
  /// release resources and prevent memory leaks.
  @mustCallSuper
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }

  /// Returns an iterable of the keys in the Hive box.
  ///
  /// **Returns:**
  ///
  /// An `Iterable<dynamic>` containing the keys.
  @nonVirtual
  Iterable<dynamic> get keys => _box.keys;

  /// Returns the number of items in the Hive box.
  ///
  /// **Returns:**
  ///
  /// The number of items as an `int`.
  @nonVirtual
  int get length => _box.length;

  /// Returns whether the Hive box is empty.
  ///
  /// **Returns:**
  ///
  /// `true` if the box is empty, `false` otherwise.
  @nonVirtual
  bool get isEmpty => _box.isEmpty;

  /// Returns whether the Hive box is not empty.
  ///
  /// **Returns:**
  ///
  /// `true` if the box is not empty, `false` otherwise.
  @nonVirtual
  bool get isNotEmpty => _box.isNotEmpty;

  /// Returns the key at the specified index in the Hive box.
  ///
  /// **Parameters:**
  ///
  /// * `index`: The index of the key to retrieve.
  ///
  /// **Returns:**
  ///
  /// The key at the specified index.
  @nonVirtual
  dynamic keyAt(int index) => _box.keyAt(index);

  /// Returns the name of the Hive box.
  ///
  /// **Returns:**
  ///
  /// The name of the box as a `String`.
  @nonVirtual
  String get name => _name;

  /// Recursively decodes a dynamic data structure, handling nested lists and maps.
  ///
  /// This function converts nested lists and maps into appropriate Dart types,
  /// ensuring that maps are represented as `JsonMap` objects.  Basic types are
  /// returned as-is.
  ///
  /// **Parameters:**
  ///
  /// * `data`: The dynamic data structure to decode. This can be a `Map`, a
  ///   `List`, or any other type.
  ///
  /// **Returns:**
  ///
  /// The decoded data structure.  Lists are returned as `List<dynamic>`, maps
  /// as `JsonMap`, and other types are returned as their original type.
  ///
  /// **Behavior:**
  ///
  /// * **Lists:** If `data` is a `List`, the function recursively calls itself
  ///   on each item in the list and returns a new `List` containing the
  ///   decoded items.
  /// * **Maps:** If `data` is a `Map`, the function recursively calls itself
  ///   on each value in the map and returns a `JsonMap` with the same keys
  ///   and the recursively decoded values.
  /// * **Other types:** If `data` is neither a `List` nor a `Map`, it is returned
  ///   as-is.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// dynamic nestedData = {
  ///   'name': 'Example',
  ///   'items': [
  ///     {'id': 1, 'value': 'A'},
  ///     {'id': 2, 'value': 'B'},
  ///   ],
  ///   'details': {
  ///     'address': '123 Main St',
  ///     'city': 'Anytown',
  ///   },
  /// };
  ///
  /// dynamic decodedData = decode(nestedData);
  ///
  /// print(decodedData);
  /// // Output: {name: Example, items: [{id: 1, value: A}, {id: 2, value: B}], details: {address: 123 Main St, city: Anytown}}
  /// ```
  dynamic decode(dynamic data) {
    if (Instance.of<List>(data)) {
      // If it's a list, recursively apply to all items
      return (data as List).map((dynamic item) => decode(item)).toList();
    } else if (Instance.of<Map>(data)) {
      return JsonMap.from(data.map((dynamic key, dynamic nested) {
        return MapEntry(key, decode(nested));
      }));
    } else {
      return data;
    }
  }

  /// Converts the item [T] to the storage format [E].
  ///
  /// This method *must* be implemented by subclasses to define how the data
  /// is stored in the database.  The conversion process depends on the types
  /// of [T] and [E].
  ///
  /// **Common Cases:**
  ///
  /// * **`JsonMap` (T is your data model, E is `Map<String, dynamic>`):**
  ///   Convert your data model object into a `Map<String, dynamic>` that can
  ///   be stored in the database.  This typically involves serializing the
  ///   data model's properties into a map.
  /// * **`JsonMapCollection` (T is your data model, E is `List<Map<String, dynamic>>`):**
  ///   If you are storing a collection of your data models, convert each data
  ///   model object into a `Map<String, dynamic>` and return a `List` of
  ///   these maps.
  /// * **Other Types (T and E are the same or different):**
  ///   For other data types, implement the appropriate conversion logic.  If
  ///   [T] and [E] are the same, you might not need to do any conversion.  If
  ///   they are different, you'll need to transform the data from the format
  ///   of [T] to the format of [E].
  ///
  /// Example (`JsonMap` case):
  ///
  /// ```dart
  /// @override
  /// Map<String, dynamic> toStore(User user) {
  ///   return {
  ///     'name': user.name,
  ///     'age': user.age,
  ///   };
  /// }
  /// ```
  ///
  /// Example (`JsonMapCollection` case):
  ///
  /// ```dart
  /// @override
  /// List<Map<String, dynamic>> toStore(List<User> users) {
  ///   return users.map((user) => user.toJson()).toList();
  /// }
  /// ```
  E toStore(T item);

  /// Converts the storage format [E] to the item format [T].
  ///
  /// This method *must* be implemented by subclasses to define how the data
  /// is retrieved from the database and converted back into your data model.
  /// The conversion process depends on the types of [T] and [E].  It should be
  /// the inverse of the [toStore] method.
  ///
  /// **Common Cases:**
  ///
  /// * **`JsonMap` (T is your data model, E is `Map<String, dynamic>`):**
  ///   Convert the `Map<String, dynamic>` retrieved from the database back
  ///   into an instance of your data model.  This typically involves
  ///   deserializing the map's properties into the data model's fields.
  /// * **`JsonMapCollection` (T is your data model, E is `List<Map<String, dynamic>>`):**
  ///   If you stored a collection of data models, convert each `Map<String, dynamic>`
  ///   in the list back into an instance of your data model.
  /// * **Other Types (T and E are the same or different):**
  ///   For other data types, implement the appropriate conversion logic to
  ///   reconstruct your data model from the stored data.
  ///
  /// Example (`JsonMap` case):
  ///
  /// ```dart
  /// @override
  /// User fromStore(Map<String, dynamic>? data) {
  ///   if (data == null) {
  ///     return User(name: '', age: 0); // Or handle null as needed
  ///   }
  ///   return User(
  ///     name: data['name'] as String,
  ///     age: data['age'] as int,
  ///   );
  /// }
  /// ```
  ///
  /// Example (`JsonMapCollection` case):
  ///
  /// ```dart
  /// @override
  /// List<User> fromStore(List<Map<String, dynamic>>? data) {
  ///   if (data == null) {
  ///     return []; // Or handle null as needed
  ///   }
  ///   return data.map((json) => User.fromJson(json)).toList();
  /// }
  /// ```
  T fromStore(E? data);

  /// User-provided put function.
  ///
  /// This function allows users to provide a custom implementation for
  /// storing data in the Hive box.
  ///
  /// If provided, this function will be used instead of the default put logic.
  ///
  /// **Parameters:**
  ///
  /// * `Box<dynamic> box`: The Hive box to store the data in.
  /// * `String key`: The key to use for storing the data.
  /// * `T value`: The value to store.
  ///
  /// **Returns:**
  ///
  /// A `Future<T>` that completes when the data is stored, or `null` if the
  /// default put logic should be used.
  Future<T> Function(Box<dynamic>, String, T)? put() {
    return null;
  }

  /// User-provided read function.
  ///
  /// This function allows users to provide a custom implementation for
  /// reading data from the Hive box.
  ///
  /// If provided, this function will be used instead of the default read logic.
  ///
  /// **Parameters:**
  ///
  /// * `Box<dynamic> box`: The Hive box to read the data from.
  /// * `String key`: The key to use for retrieving the data.
  ///
  /// **Returns:**
  ///
  /// The value read from the box, or `null` if the default read logic should
  /// be used.
  T Function(Box<dynamic>, String)? read() {
    return null;
  }

  /// Handles the deletion of data.
  ///
  /// This method is responsible for deleting data from the storage.
  /// Subclasses can override this method to provide custom deletion logic.
  ///
  /// By default, this method performs no action.
  ///
  /// **Returns:**
  ///
  /// A `Future<void>` that completes when the deletion is finished.
  Future<void> runDelete() async {}

  @override
  @nonVirtual
  Future<Optional<T>> delete() async {
    if(!_isInitialized) {
      throw SecureDatabaseException("$_exPrefix - Repository is not initialized. Call open() first.");
    } else {
      await _box.delete(_key);

      runDelete();
      return Optional<T>.empty();
    }
  }

  @override
  Future<List<T>> fetchAll() async {
    throw SecureDatabaseException("$_exPrefix - Method not implemented");
  }

  @override
  Future<void> deleteAll(List<T> items) async {
    throw SecureDatabaseException("$_exPrefix - Method not implemented");
  }
}